//
//  Endpoint.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import Foundation

enum DrinksSourceFilter {
    case alcoholic(value: String)
    case ingredients(value: String)
    case glass(value: String)
    case category(value: String)
}

enum Endpoint {
    case getIngredients
    case getIngredientsThumbnail(name: String)
    case getDrinks(source: DrinksSourceFilter)
    case getDetails(drinkId: String)
}
// www.thecocktaildb.com/images/ingredients/gin-Medium.png


extension Endpoint {
    
    var host: String { "thecocktaildb.com" }
    
    var path: String {
        switch self {
        case .getIngredients:
            return "/api/json/v1/1/list.php"
        case .getIngredientsThumbnail(let name):
            return "/images/ingredients/\(name)-Medium.png"
        case .getDrinks:
            return "/api/json/v1/1/filter.php"
        case .getDetails:
            return "/api/json/v1/1/lookup.php"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getIngredients:
            return [URLQueryItem(name: "i", value: "list")]
        case .getIngredientsThumbnail:
            return []
        case .getDrinks(let source):
            switch source {
            case .alcoholic(let value):
                return [URLQueryItem(name: "a", value: value)]
            case .ingredients(let value):
                return [URLQueryItem(name: "i", value: value)]
            case .glass(let value):
                return [URLQueryItem(name: "g", value: value)]
            case .category(let value):
                return [URLQueryItem(name: "c", value: value)]
            }
        case .getDetails(let id):
            return [URLQueryItem(name: "i", value: id)]
        }
    }
    
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
