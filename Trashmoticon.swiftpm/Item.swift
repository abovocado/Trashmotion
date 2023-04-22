//
//  Item.swift
//  Trashmoticon
//
//  Created by SY AN on 2023/04/16.
//

import SwiftUI


struct Item: Identifiable {
    var id: Int
    var name: String
    var action: String
    var backgroundImg: String
    var thumbNailImg: String
    var finalImg: String
    var BGMName: String
    var effectSoundName: String
    var index: Int
}

class Store: ObservableObject {
    @Published var items: [Item]
    
    let names: [String] = ["Beach", "Space", "Oven", "Garden", "Dart", "Cave"]
    
    let actions: [String]  = ["Throw a glass bottle letter", "Launch a rocket", "Bake as a bread", "Plant as a flower", "Throw a dart", "Fight with a monster"]
    
    let backgroundImgs: [String]  = ["Back_Beach", "Back_Space", "Back_Oven", "Back_Garden", "Back_Dart", "Back_Cave"]
    
    let thumbNailImgs: [String] = ["Thumb_Beach", "Thumb_Space", "Thumb_Oven", "Thumb_Garden", "Thumb_Dart", "Thumb_Cave"]
    
    let finalImgs:[String] = ["Final_Beach", "Final_Space", "Final_Oven", "Final_Garden", "Final_Dart", "Final_Cave"]
    let BGMs : [String] = ["BGM_Beach", "BGM_Space", "BGM_Bakery", "BGM_Oven", "BGM_Dart", "BGM_Cave"]
    let effects: [String]  = ["E_Beach", "E_Space", "E_Oven", "E_Garden", "E_Dart", "E_Cave"]
    let indexs : [Int] = [5,5,5,5,5,5]
    
    // dummy data
    init() {
        items = []
        for i in 0...5 {
            let new = Item(id: i, name: names[i], action: actions[i], backgroundImg: backgroundImgs[i], thumbNailImg: thumbNailImgs[i], finalImg: finalImgs[i],BGMName: BGMs[i], effectSoundName: effects[i], index: indexs[i])
            items.append(new)
        }
    }
}
