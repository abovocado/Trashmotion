//
//  ThrowView.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/16.
//

import SwiftUI
import AVFoundation

struct ThrowView: View {
    var item: Item
    @State private var currentPosition: CGPoint = .zero
    @State private var velocity: CGPoint = .zero
    @State private var timer: Timer?
    @State private var scale: CGFloat = 1.0
    @State var isShowingTitle = true
    
    @Binding var isSubView1Presented : Bool
    @Binding var isSubView2Presented : Bool
    @State var isSubView3Presented = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let click = Bundle.main.path(forResource: "MP_Blop", ofType: "mp3")
    
    var body: some View {
        GeometryReader{geo in
            if isShowingTitle {
                Spacer()
                Text("Please drag and throw \n your Trash-motion")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.custom("Chalkduster", size:18))
            }
            
            ZStack{
                Image(item.thumbNailImg)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .position(currentPosition)
                    .scaleEffect(scale)
                    .onChange(of: currentPosition, perform: { _ in
//                        if currentPosition.x < 0 || currentPosition.x > UIScreen.main.bounds.width {
//                            velocity.x = -velocity.x
//                        }
                        if currentPosition.y < 0 {
                            velocity.y = -velocity.y
                        }
                        if currentPosition.y > UIScreen.main.bounds.height  {
                            timer?.invalidate()
                            timer = nil
                            currentPosition.y = UIScreen.main.bounds.height
                            velocity = .zero
                            scale = 0.0
                            if scale == 0.0{
                                isSubView3Presented = true
                            }
                        }
                        
                        if currentPosition.y <= 0 {
                            timer?.invalidate()
                            timer = nil
                            velocity = .zero
                            scale = 0.0
                            if scale == 0.0{
                                isSubView3Presented = true
                            }
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.currentPosition = value.location
                                timer?.invalidate()
                                timer = nil
                                scale = 1.0
                                isShowingTitle = false
                            }
                            .onEnded {  value in
                                velocity = CGPoint(x: value.translation.width, y: value.translation.height)
                                //generator.impactOccurred()
                                timer = Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { _ in
                                    currentPosition.x += velocity.x / 50
                                    currentPosition.y += velocity.y / 50
                                    velocity.y += 2.0
                                }
                            }
                        )
                    .onTapGesture {
                        timer?.invalidate()
                        timer = nil
                        scale = 1.0
                        isShowingTitle = false
                    }
                
                if scale == 0.0 &&  isSubView3Presented == true{
                    
                    FinalView(item:item, isSubView1Presented: $isSubView1Presented, isSubView2Presented: $isSubView2Presented, isSubView3Presented: $isSubView3Presented)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .edgesIgnoringSafeArea(.bottom)
        }// geo
        .onAppear{
            currentPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
        }
        .background(Image(item.backgroundImg)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.bottom)
            .opacity(0.7)
        )
    } //body
} // View
//        .onTapGesture {
//            timer?.invalidate()
//            timer = nil
//            scale = 1.0
//            isShowingTitle = false
//        }
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    self.currentPosition = value.location
//                    timer?.invalidate()
//                    timer = nil
//                    scale = 1.0
//                    isShowingTitle = false
//                }
//                .onEnded {  value in
//                    velocity = CGPoint(x: value.translation.width, y: value.translation.height)
//                    timer = Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { _ in
//                        currentPosition.x += velocity.x / 50
//                        currentPosition.y += velocity.y / 50
//                        velocity.y += 2.0
//                    }
//                }
//            )
            
    //        .onChange(of: currentPosition, perform: { _ in
    //            if currentPosition.x < 0 || currentPosition.x > UIScreen.main.bounds.width {
    //                velocity.x = -velocity.x
    //            }
    //            if currentPosition.y < 0 {
    //                velocity.y = -velocity.y
    //            }
    //            if currentPosition.y > UIScreen.main.bounds.height  {
    //                timer?.invalidate()
    //                timer = nil
    //                currentPosition.y = UIScreen.main.bounds.height
    //                velocity = .zero
    //                scale = 1.0
    //
    //            }
    //
    //        })




struct ThrowView_Previews: PreviewProvider {
    static var previews: some View {
        ThrowView(item: Store.init().items[0], isSubView1Presented: .constant(true), isSubView2Presented: .constant(true))
    }
}
