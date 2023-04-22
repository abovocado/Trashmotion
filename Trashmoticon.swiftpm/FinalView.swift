//
//  FinalView.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/16.
//

import SwiftUI
import UIKit
import AVFoundation

struct FinalView: View {
    var item:Item
    @State private var navigationController: UINavigationController?
    @State var audioPlayer: AVAudioPlayer!
    
    @Binding var isSubView1Presented: Bool
    @Binding var isSubView2Presented: Bool
    @Binding var isSubView3Presented: Bool
    
    let click = Bundle.main.path(forResource: "MP_Blop", ofType: "mp3")
    let laugh = Bundle.main.path(forResource: "MP_Funny Boy Laugh", ofType: "mp3")
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Button(action: {
                    
                }, label: {
                    Text("Replay")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.custom("Chalkduster", size:18))
                        .onTapGesture {
                            isSubView1Presented = false
                            isSubView2Presented = false
                            isSubView3Presented = false
                            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: click!))
                            audioPlayer?.play()
                        }
                })
            }
            .onAppear{
                isSubView3Presented = true
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: laugh!))
                audioPlayer?.play()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Image(item.finalImg)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.bottom)
                    .opacity(1)
            )
        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        FinalView(item: Store.init().items[0],isSubView1Presented: .constant(true), isSubView2Presented: .constant(true), isSubView3Presented : .constant(true))
    }
}
