//
//  Animal.swift
//  It's A Zoo in There
//
//  Created by 宋天瑜 on 16/1/16.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class Animal {
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    var soundPath: String?
    init(name:String, species:String,age:Int,image:UIImage,soundPath:String?)
    {
        self.age = age
        self.image = image
        self.name = name
        self.species = species
        self.soundPath = soundPath
    }
    func dumpAnimalObject()
    {
        print("Animal Object: name=\(name), species=\(species), age=\(age), image=\(image)")
    }
    
}
