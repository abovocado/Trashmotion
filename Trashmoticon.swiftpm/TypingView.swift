//
//  TypingView.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/15.
//

import SwiftUI
import AVFoundation

struct KeyboardObserver: UIViewRepresentable {
    var keyboardWillShow: (CGSize) -> Void
    var keyboardWillHide: () -> Void
    
    class Coordinator: NSObject {
        var keyboardWillShow: (CGSize) -> Void
        var keyboardWillHide: () -> Void
        
        init(keyboardWillShow: @escaping (CGSize) -> Void, keyboardWillHide: @escaping () -> Void) {
            self.keyboardWillShow = keyboardWillShow
            self.keyboardWillHide = keyboardWillHide
        }
        
        @objc func keyboardWillShow(notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                keyboardWillShow(keyboardSize)
            }
        }
        
        @objc func keyboardWillHide(notification: Notification) {
            keyboardWillHide()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(keyboardWillShow: keyboardWillShow, keyboardWillHide: keyboardWillHide)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(context.coordinator)
        notificationCenter.addObserver(context.coordinator, selector: #selector(Coordinator.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(context.coordinator, selector: #selector(Coordinator.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

struct TypingView: View {
    var item:Item
    @State var text = ""
    @State private var keyboardIsVisible = false
    
    @Binding var isSubView1Presented : Bool
    @State var isSubView2Presented = false
    @State var audioPlayer: AVAudioPlayer!
    @State var audioPlayer1: AVAudioPlayer!
    let click = Bundle.main.path(forResource: "MP_Blop", ofType: "mp3")
    
    var body: some View {
            GeometryReader{geo in
                VStack{
                    VStack{
                        Spacer()
                        
                        ZStack{
                            Image("Paper")
                                .resizable()
                                .cornerRadius(10)
                                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                            
                            TextEditor(text: $text)
                                .font(.custom("Chalkduster", size:18))
                                .background(Color.clear)
                                .cornerRadius(10)
                                .opacity(text.isEmpty ? 0.5 : 0.8)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        if text.isEmpty {
                                            Spacer()
                                            Text("Please pour your trash-motion here.")
                                                .foregroundColor(.gray)
                                                .padding(.leading, 5)
                                                .font(.custom("Chalkduster", size:18))
                                            Spacer()
                                        }
                                    }
                                )
                        }
                        Spacer()
                    }
                    .frame(width: geo.size.width * 0.8, height: geo.size.height*0.8)
                    
                    
                    if self.keyboardIsVisible{
                        
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Completed")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .font(.custom("Chalkduster", size:15))
                            
                        }
                    }
                    
                    if self.keyboardIsVisible == false && text.isEmpty == false{
                        
                        NavigationLink(destination: ThrowView(item: item, isSubView1Presented: $isSubView1Presented, isSubView2Presented: $isSubView2Presented), isActive: $isSubView2Presented) {
                            Text("Let's Go and Throw!")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .font(.custom("Chalkduster", size:18))
                                .onTapGesture {
                                    isSubView2Presented = true
                                    self.audioPlayer1 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: click!))
                                    audioPlayer1?.play()
                                }
                        }
                    }
                } // VStack
                .frame(width: geo.size.width, height: geo.size.height)
            } //geo
            
            .background(Image(item.backgroundImg)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.bottom)
                .opacity(0.7)
            )

            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                    self.keyboardIsVisible = true
                    
                }
                
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                    self.keyboardIsVisible = false
                    
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
    } //body
} // View


struct TypingView_Previews: PreviewProvider {
    static var previews: some View {
        TypingView(item: Store.init().items[0], isSubView1Presented : .constant(true))
    }
}
