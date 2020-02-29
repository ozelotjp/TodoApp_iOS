//
//  Todo.swift
//  TodoApp
//
//  Created by ozelot on 2020/02/28.
//  Copyright © 2020 nhs70060. All rights reserved.
//

import Foundation

class Todo: NSObject, NSCoding {
    
    var title: String?
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String
        done = coder.decodeBool(forKey: "done")
    }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(done, forKey: "done")
    }

}
