//
//  DetailsResponse.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import Foundation

struct DetailsResponse: Codable {
    let details: [Details]
    
    enum CodingKeys: String, CodingKey {
        case details = "drinks"
    }
}

struct Details: Codable {
    let id: String
    let name: String
    let category: String
    let alcoholic: String
    let glass: String
    let instructions: String
    
    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let ingredient9: String?
    let ingredient10: String?
    let ingredient11: String?
    let ingredient12: String?
    let ingredient13: String?
    let ingredient14: String?
    let ingredient15: String?
    
    lazy var ingredients: [String?] = {
       return [
        ingredient1,
        ingredient2,
        ingredient3,
        ingredient4,
        ingredient5,
        ingredient6,
        ingredient7,
        ingredient8,
        ingredient9,
        ingredient10,
        ingredient11,
        ingredient12,
        ingredient13,
        ingredient14,
        ingredient15
       ]
    }()
    
    let dose1: String?
    let dose2: String?
    let dose3: String?
    let dose4: String?
    let dose5: String?
    let dose6: String?
    let dose7: String?
    let dose8: String?
    let dose9: String?
    let dose10: String?
    let dose11: String?
    let dose12: String?
    let dose13: String?
    let dose14: String?
    let dose15: String?
    
    lazy var doses: [String?] = {
       return [
        dose1,
        dose2,
        dose3,
        dose4,
        dose5,
        dose6,
        dose7,
        dose8,
        dose9,
        dose10,
        dose11,
        dose12,
        dose13,
        dose14,
        dose15
       ]
    }()
    
    lazy var isAlcoholic: Bool = {
        if alcoholic == "Non Alcoholic" {
            return true
        }
        return false
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case glass = "strGlass"
        case instructions = "strInstructions"

        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        
        case dose1 = "strMeasure1"
        case dose2 = "strMeasure2"
        case dose3 = "strMeasure3"
        case dose4 = "strMeasure4"
        case dose5 = "strMeasure5"
        case dose6 = "strMeasure6"
        case dose7 = "strMeasure7"
        case dose8 = "strMeasure8"
        case dose9 = "strMeasure9"
        case dose10 = "strMeasure10"
        case dose11 = "strMeasure11"
        case dose12 = "strMeasure12"
        case dose13 = "strMeasure13"
        case dose14 = "strMeasure14"
        case dose15 = "strMeasure15"
        
    }
    
    
    lazy var combinedIngredients: [String : String] = {
        
        var output = [String : String]()
        
        let unwrappedIngredients = ingredients.compactMap { $0 }
        let unwrappedDoses = doses.compactMap { $0 }
        
        for i in 0..<unwrappedIngredients.count {
            output[unwrappedIngredients[i]] = unwrappedDoses[i]
        }
        
        return output
    }()
    
}
