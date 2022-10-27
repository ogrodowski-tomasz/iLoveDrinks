//
//  HomeViewController.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import RxSwift
import UIKit

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var categories = [Category]()
    private var alcoholic = [Alcoholic]()
    private var glasses = [Glass]()
    private var ingredients = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: IngredientsTableViewCell.identifier)
        tableView.register(GenericHomeTableViewCell.self, forCellReuseIdentifier: GenericHomeTableViewCell.identifier)
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        populateGlasses()
        populateAlcoholic()
        populateCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func populateGlasses() {
        glasses = [
            Glass(name: "Highball glass", image: UIImage(named: "glass0")),
            Glass(name: "Cocktail glass", image: UIImage(named: "glass1")),
            Glass(name: "Old-fashioned glass", image: UIImage(named: "glass2")),
            Glass(name: "Whiskey glass", image: UIImage(named: "glass3")),
            Glass(name: "Collins glass", image: UIImage(named: "glass4")),
            Glass(name: "Pousse cafe glass", image: UIImage(named: "glass5")),
            Glass(name: "Champagne flute", image: UIImage(named: "glass6")),
            Glass(name: "Whiskey sour glass", image: UIImage(named: "glass7")),
            Glass(name: "Cordial glass", image: UIImage(named: "glass8")),
            Glass(name: "Brandy snifter", image: UIImage(named: "glass9")),
            Glass(name: "White wine glass", image: UIImage(named: "glass10")),
            Glass(name: "Nick and Nora glass", image: UIImage(named: "glass11")),
            Glass(name: "Hurricane glass", image: UIImage(named: "glass12")),
            Glass(name: "Coffee mug", image: UIImage(named: "glass13")),
            Glass(name: "Shot glass", image: UIImage(named: "glass14")),
            Glass(name: "Jar", image: UIImage(named: "glass15")),
            Glass(name: "Irish coffee cup", image: UIImage(named: "glass15")),
            Glass(name: "Punch bowl", image: UIImage(named: "glass16")),
            Glass(name: "Pitcher", image: UIImage(named: "glass16")),
            Glass(name: "Pint glass", image: UIImage(named: "glass16")),
            Glass(name: "Copper Mug", image: UIImage(named: "glass17")),
            Glass(name: "Wine Glass", image: UIImage(named: "glass18")),
            Glass(name: "Beer mug", image: UIImage(named: "glass19")),
            Glass(name: "Margarita / Coupette glass", image: UIImage(named: "glass20")),
            Glass(name: "Beer pilsner", image: UIImage(named: "glass21")),
            Glass(name: "Beer glass", image: UIImage(named: "glass22")),
            Glass(name: "Parfait glass", image: UIImage(named: "glass23")),
            Glass(name: "Mason jar", image: UIImage(named: "glass24")),
            Glass(name: "Margarita glass", image: UIImage(named: "glass25")),
            Glass(name: "Martini glass", image: UIImage(named: "glass26")),
            Glass(name: "Baloon glass", image: UIImage(named: "glass27")),
            Glass(name: "Coupe glass", image: UIImage(named: "glass28")),
        ]
    }

    private func populateAlcoholic() {
        self.alcoholic = [
            Alcoholic(name: "Alcoholic", image: UIImage(named: "alcoholic")),
            Alcoholic(name: "Non Alcoholic", image: UIImage(named: "nonalcoholic")),
            Alcoholic(name: "Optional Alcohol", image: UIImage(named: "optionalalcohol"))
        ]
    }
    
    private func populateCategories() {
        categories = [
            Category(name: "Ordinary Drink", image: UIImage(named: "category0")),
            Category(name: "Cocktail", image: UIImage(named: "category1")),
            Category(name: "Shake", image: UIImage(named: "category2")),
            Category(name: "Other/Unknown", image: UIImage(named: "category3")),
            Category(name: "Cocoa", image: UIImage(named: "category4")),
            Category(name: "Shot", image: UIImage(named: "category5")),
            Category(name: "Coffee / Tea", image: UIImage(named: "category6")),
            Category(name: "Homemade Liqueur", image: UIImage(named: "category7")),
            Category(name: "Punch / Party Drink", image: UIImage(named: "category8")),
            Category(name: "Beer", image: UIImage(named: "category9")),
            Category(name: "Soft Drink", image: UIImage(named: "category10"))
        ]
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Categories"
        case 1:
            return "Alcoholic"
        case 2:
            return "Glasses"
        case 3:
            return "Ingredients"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // CATEGORIES TableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericHomeTableViewCell.identifier, for: indexPath) as! GenericHomeTableViewCell
            let categoriesTitles = categories.map { $0.name }
            let categoriesImages = categories.map { $0.image }
            cell.configure(titles: categoriesTitles, images: categoriesImages)
            cell.publishSubjectObservable
                .subscribe(onNext: { selectedCategory in
                    let vc = DrinksViewController(source: .category(value: selectedCategory))
                    vc.title = "\(selectedCategory)"
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: disposeBag)
            return cell
        case 1:
            // Alcoholic
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericHomeTableViewCell.identifier, for: indexPath) as! GenericHomeTableViewCell
            let alcoholicTitles = alcoholic.map { $0.name }
            let alcoholicImages = alcoholic.map { $0.image }
            cell.configure(titles: alcoholicTitles, images: alcoholicImages)
            cell.publishSubjectObservable
                .subscribe(onNext: { selectedAlcoholic in
                    let vc = DrinksViewController(source: .alcoholic(value: selectedAlcoholic))
                    vc.title = "\(selectedAlcoholic)"
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: disposeBag)
            return cell
        case 2:
            // Glasses TableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericHomeTableViewCell.identifier, for: indexPath) as! GenericHomeTableViewCell
            let glassesTitles = glasses.map { $0.name }
            let glassesImages = glasses.map { $0.image }
            cell.configure(titles: glassesTitles, images: glassesImages)
            cell.publishSubjectObservable
                .subscribe(onNext: { selectedGlass in
                    let vc = DrinksViewController(source: .glass(value: selectedGlass))
                    vc.title = "\(selectedGlass) drinks"
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: disposeBag)
            return cell
        case 3:
            // Ingredients TableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier, for: indexPath) as! IngredientsTableViewCell
            cell.ingredientSubjectObservable
                .subscribe(onNext: { selectedIngredient in
                let vc = DrinksViewController(source: .ingredients(value: selectedIngredient))
                    vc.title = selectedIngredient
                self.navigationController?.pushViewController(vc, animated: true)
            })
                .disposed(by: disposeBag)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 325
        case 1:
            return 162
        case 2:
            return (165)*3
        case 3:
            return 410
        default:
            return 0
        }
    }
}
