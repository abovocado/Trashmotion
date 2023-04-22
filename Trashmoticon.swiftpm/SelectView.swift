//
//  SelectView.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/19.
//

import SwiftUI
import AVFoundation

struct SelectView: View {
    
    @StateObject var store = Store()
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State var itemHere : Item
    @State var audioPlayer: AVAudioPlayer!
    @State private var isSubView1Presented = false
    
    let click = Bundle.main.path(forResource: "MP_Blop", ofType: "mp3")

    
    var body: some View {
        
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
        // NavigationView
        
        
    }//body
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
        return sin(angle) * 200
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView(itemHere:Store.init().items[0])
    }
}
