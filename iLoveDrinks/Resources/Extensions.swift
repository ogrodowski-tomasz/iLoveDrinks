//
//  Extensions.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit



struct Resource<T: Codable> {
    let endpoint: Endpoint
}

// Extension of URLRequest. Loading data from Network and making response observable
extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T?> {
        return Observable.from([resource.endpoint.url!])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }
            .map { data -> T? in
                return try? JSONDecoder().decode(T.self, from: data)
            }
            .asObservable()
    }
}

// Making using view properties easier
extension UIView {
    
    public var width: CGFloat { frame.size.width }
    
    public var height: CGFloat { frame.size.height }
    
    public var top: CGFloat { frame.origin.y }
    
    public var bottom: CGFloat { top + height }
    
    public var left: CGFloat { frame.origin.x }
    
    public var right: CGFloat { left + width }
    
}


extension String {
    
    /// Replacing any whitespaces with %20 
    func urlFriendly() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
    
}
