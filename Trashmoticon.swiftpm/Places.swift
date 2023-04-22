//
//  Places.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/14.
//

import SwiftUI

struct Places: Identifiable{
    var id: UUID
    var name: String
    var action: String
    var sceneName: String
    var BGMName: String
    var effectSoundName: String
        
    init(id: UUID = UUID(), name: String, action: String, sceneName: String, BGMName: String, effectSoundName: String) {
        self.id = id
        self.name = name
        self.action = action
        self.sceneName = sceneName
        self.BGMName = BGMName
        self.effectSoundName = effectSoundName
    }
    
    
}

extension Places{
    static var colorList:[Color] = [.blue, .green, .orange, .red, .gray, .pink, .yellow]
    
    static var places = [
        Places(name: "바다", action: "유리병 던지기", sceneName: "Ocean", BGMName: "BGM_Ocean", effectSoundName: "Effect_Ocean"),
        Places(name: "우주", action: "로케트 날리기", sceneName: "Space", BGMName: "BGM_Space", effectSoundName: "Effect_Space"),
        Places(name: "빵집", action: "빵으로 굽기", sceneName: "Bakery", BGMName: "BGM_Bakery", effectSoundName: "Effect_Bakery"),
        Places(name: "꽃밭", action: "꽃으로 틔우기", sceneName: "Flower", BGMName: "BGM_Flower", effectSoundName: "Effect_Flower"),
        Places(name: "다트", action: "다트핀 던지기", sceneName: "Pin", BGMName: "BGM_Pin", effectSoundName: "Effect_Pin")
    ]
}



struct CardView: View {
    var backgroundColor: Color
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            Spacer()
        }
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

