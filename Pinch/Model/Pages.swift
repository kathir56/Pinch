//
//  Pages.swift
//  Pinch
//
//  Created by Kathiravan Murali on 25/12/23.
//

import Foundation


struct Page : Identifiable
{
    var id: Int
    var name: String
    
}

extension Page
{
    var thumbnail : String
    {
        return "thumb-" + name
    }
}
