//
//  DrinksResponse.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import Foundation

// Endpoint: https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=Gin

struct DrinksResponse: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let name: String
    let imageURL: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case imageURL = "strDrinkThumb"
        case id = "idDrink"
    }
}


