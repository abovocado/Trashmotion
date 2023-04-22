import SwiftUI
import AVFoundation


struct ContentView: View {
    @State private var isShaking = false
    @State var hideImage = false
    
    @State var audioPlayer: AVAudioPlayer!
    @StateObject var store = Store()
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State var itemHere : Item
    
    @State private var isFirst = true
    @State private var isSubView1Presented = false
    
    let click = Bundle.main.path(forResource: "MP_Blop", ofType: "mp3")
    
    
    var body: some View {
        if !hideImage {
            GeometryReader{geo in
                ZStack(alignment: .center){
                    Image("Load")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geo.size.height * 0.4)
                        .rotationEffect(isShaking ? Angle.degrees(-10) : Angle.degrees(10)) // Rotate the image left and right
                    
                        .onAppear {
                            isShaking = true
                        }
                        .onDisappear {
                            isShaking = false
                        }
                        .animation(Animation.easeInOut(duration: 0.2).repeatCount(15))
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .background(.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.hideImage = true
                }
            }
        } else if hideImage && !isFirst {
            NavigationView{
                GeometryReader{ geo in
                    ZStack{
                        
                        VStack{
                            Spacer()
                            Text("Please select a place to throw \n your Trash-motion away.")
                                .padding(.bottom, 40.0)
                                .font(.custom("Chalkduster", size:18))
                            
                            ZStack {
                                ForEach(store.items) { item in
                                    VStack{
                                        // article view
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 18)
                                                .overlay(
                                                    Image(item.thumbNailImg)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(18)
                                                        .padding()
                                                )
                                                .foregroundColor(Color.white)
                                        } //Zstack
                                        .frame(width: 200, height: 200)
                                        .scaleEffect(1.0 - abs(distance(item.id)) * 0.2 )
                                        .opacity(1.0 - abs(distance(item.id)) * 0.3 )
                                        .offset(x: myXOffset(item.id), y: 0)
                                        .zIndex(1.0 - abs(distance(item.id)) * 0.1)
                                        .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                                        
                                        if myXOffset(item.id) == 0.0 {
                                            Text(item.name + "\n" + item.action )
                                                .font(.custom("Chalkduster", size:18))
                                                .multilineTextAlignment(.center)
                                            //.background(Color.white)
                                            //.foregroundColor(.black)
                                            //.cornerRadius(10)
                                                .padding(.horizontal)
                                                .onAppear{
                                                    itemHere = item
                                                    
                                                }
                                        } //if
                                    }//VStack
                                }//ForEach
                            }// ZStack
                            .frame(height: 280)
                            
                            Spacer()
                            NavigationLink(destination: TypingView(item: itemHere, isSubView1Presented: self.$isSubView1Presented), isActive: $isSubView1Presented) {
                                Text("Go!")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 80.0)
                                    .padding(.vertical)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .font(.custom("Chalkduster", size:18))
                                    .onTapGesture {
                                        isSubView1Presented = true
                                        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: click!))
                                        audioPlayer?.play()
                                    }
                            }
                            Spacer()
                        }//Vstack
                    }//ZStack
                    
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(
                        Image(itemHere.backgroundImg)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.3)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                draggingItem = snappedItem + value.translation.width / 100
                                
                            }
                            .onEnded { value in
                                withAnimation {
                                    draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                                    draggingItem = round(draggingItem).remainder(dividingBy: Double(store.items.count))
                                    snappedItem = draggingItem
                                }
                            }
                    )
                } // Geo
                .edgesIgnoringSafeArea(.bottom)
            } // NavigationView
        } else if hideImage && isFirst {
            VStack{
            ScrollView{
                Text("""
                    \n\n
                    To everyone who can't seem to let go of their emotions:\n
                     Hello everyone. This space is where you can discard negative emotions that disrupt peaceful sleep at night, gnaw at yourself, and shake your identity.\n
                     It's a place where you can throw away those emotions like trash (trash-motion) so they don't lead you to bad choices.\n\n
                     In this app, you can:\n
                     Choose a place to throw your emotions away\n
                     Express your emotions in text\n
                     Throw away those emotions like a new piece of garbage.\n
                     I hope this helps you protect yourself from negative emotions and allows you to take control of yourself.\n
                     So now, shall we begin?
                    """)
                .foregroundColor(.black)
                .font(.custom("Chalkduster", size:18))
                .padding()
            }
            
            Text("Start")
                .foregroundColor(.white)
                .padding(.horizontal, 80.0)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(10)
                .font(.custom("Chalkduster", size:18))
                .onTapGesture {
                    isFirst = false
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: click!))
                    audioPlayer?.play()
                }
        }.background(
            Image("Paper")
                .opacity(0.6)
        )
    }// else
}//body
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
        return sin(angle) * 200
    }
}//view

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(itemHere:Store.init().items[0])
    }
}
