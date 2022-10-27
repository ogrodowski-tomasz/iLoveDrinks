//
//  IngredientsResponse.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import Foundation

// Endpoint: www.thecocktaildb.com/api/json/v1/1/list.php?i=list

struct IngredientsResponse: Codable {
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case ingredients = "drinks"
    }
}

struct Ingredient: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient1"
    }
}
