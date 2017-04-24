//
//  ViewController.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController : UIViewController {
    
    //Getting db container from AppDelegate
    var dbContainer : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //PruductListController viewModel
    let productListViewModel = ProductListViewModel()
    
    //Curret selected category
    var currentCategory = "all_categories"

    //UI outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var cancelCategoryButton: UIButton!
    
    //Loading View UI 
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewIndicator: UIActivityIndicatorView!
    
    
    //FetchedResultsController
    var fetchedResultsController : NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Delegate the viewModel
        productListViewModel.delegate = self
        
        //Init tableView
        initializeTableView()
        
        //Init categoryView
        initializeCategoryView()
        
        //Init database
        fetchDatabase()
    }
    
    //Fetch db from model
    func fetchDatabase() {
        //Fetch db
        productListViewModel.initializeDbContent()
        
        //Show loading view
        showLoadingView()
    }
    
    //Initialize tableView
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        //Remove tableView row separator
        tableView.separatorStyle = .none
        
        //Give to the loadingView the same size of the tableView
        loadingView.frame = tableView.frame
    }
    
    //Initialize Category View
    func initializeCategoryView() {
        //Add bottom border
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: categoryView.frame.size.height - 1, width: categoryView.frame.size.width, height: 0.7)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        categoryView.layer.addSublayer(bottomBorder)
    }
    
    //Update UI tableView
    func updateUI(withCategory currentCategory: String?) {
        guard let context = dbContainer?.viewContext else {
            return //handle the error
        }
        
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if currentCategory != nil { //if not nill query the db for category
            request.predicate = NSPredicate(format: "any categories.categoryId = %@", currentCategory!)
        }
        
        fetchedResultsController = NSFetchedResultsController<Product>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            showErrorAlertView(withTitle: "Error", andMessage: "Sorry, there was an error getting the data. Pleae try again later!")
        }
        
        //Little Hacky way to get the tableView scroll to the top on 
        //Data reload
        if tableView.numberOfRows(inSection: 0) > 0 {
            let scrollIndexPat = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: scrollIndexPat, at: .top, animated: false)
        } else {
            //in case of no row check if app is online
            checkConnectionStatus()
        }
        
        removeLoadingView()
        
    }
    
    //Check if app online
    func checkConnectionStatus() {
        let connectionStatus = ConnectionStatus()
        
        if connectionStatus.currentReachabilityStatus == .notReachable {
            showErrorAlertView(withTitle: "Error", andMessage: "Sorry is seems that you are offline, please connect the device and try again")
        }
    }
    
    
    //On open category button tap
    @IBAction func onCategoryButtonTap(_ sender: UIButton) {
        
        //Before to open the category check if is already expanded
        if categoryView.frame.size.height <= 40 {
            productListViewModel.getCategoryList()
        }
    }
    
    
    //On close category button tap
    @IBAction func onCancelCategoryButton(_ sender: UIButton) {
        closeCategoryView()
    }
    
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailsController" {
            if let detailsController = segue.destination as? ProductDetailsViewController {
                let currentCell = tableView.cellForRow(at: sender as! IndexPath) as! ProductCell
                let currentProduct = currentCell.cellInfo
                detailsController.productInfo = currentProduct
                detailsController.backgroundImage = currentCell.backgroundImageView.image
            }
        }
        
    }
    
    
    //Create loading view UI
    func showLoadingView() {
        if loadingView.isHidden {
            self.view.bringSubview(toFront: loadingView)
            loadingView.isHidden = false
        }
    }
    
    //Remove loading view
    func removeLoadingView() {
        if !loadingView.isHidden {
            loadingView.isHidden = true
        }
    }
    
    //Show an error alert view
    func showErrorAlertView(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertOkAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// ViewModel delegation
extension ProductListViewController : ProductListViewModelDelegate {
    
    func onDatabaseFetchFinish() {
        
        //Need to call the method on the main queue
        DispatchQueue.main.async { [weak self] in
            if self?.currentCategory == "all_categories" {
                self?.updateUI(withCategory: nil)
            } else {
                self?.updateUI(withCategory: self?.currentCategory)
            }
        }
    }
    
    func onCategoryListRetrieved(_ categoryList: [Category]) {
        //on list received open the category view
        openCategoriesScrollView(withCategories: categoryList)
    }
    
}


// tableView and DataSource
extension ProductListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailsController", sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellIdentifier, for: indexPath) as? ProductCell
        
        if let product = fetchedResultsController?.object(at: indexPath) {
            cell?.cellInfo = product
        }
        
        return cell!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
}


/*
 * This extension contains all the methods
 * to manage the Categories View.
 * A view to chose wich category we want to see
 *
 * It will create and open an animated view
 * showing all the category options in a vertical 
 * scrollview
 *
 */
extension ProductListViewController {
    
    func openCategoriesScrollView(withCategories categories: [Category]) {
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y + 150, width: UIScreen.main.bounds.width, height: self.tableView.frame.size.height - 150)
            self.categoryView.frame = CGRect(x: 0, y: self.categoryView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.categoryView.frame.size.height + 150)
            self.cancelCategoryButton.alpha = 1
            
            //move cancel button on centre
            self.cancelCategoryButton.frame.origin.x = (UIScreen.main.bounds.size.width / 2) - (self.cancelCategoryButton.frame.size.width / 2)
        }) { (finish) in
            self.addCategoriesButtons(withCategories: categories)
        }
    }
    
    func addCategoriesButtons(withCategories categories: [Category]) {
        
        //remove all scrollview content and resetting the scrollview content size
        categoryScrollView.subviews.forEach({ $0.removeFromSuperview() })
        categoryScrollView.contentSize = CGSize(width: categoryScrollView.frame.size.width, height: categoryScrollView.frame.size.height)
        
        var scrollViewWithCount = 110
        var buttonsCount = 1
        
        //Add the All Categories Button
        let allCategoriesIcon = getCategoryIconAtPosition(CGRect(x: 0, y: 5, width: 100, height: 50))
        let allCategoriesButton = getCategoryButtonAtPosition(CGRect(x: 0, y: 5, width: 100, height: 70), withCategoryId: "all_categories", andCategoryTitle: "All Categories")
        addScrollViewUI(withButton: allCategoriesButton, andIcon: allCategoriesIcon)
        
        //Add a button for each visible category
        for category in categories {
            
            if category.hidden { continue }
            
            //Set up the category icon
            let categoryIcon = getCategoryIconAtPosition(CGRect(x: buttonsCount*110, y: 5, width: 100, height: 50))
            
            //Set up the button
            let buttonPosition = CGRect(x: buttonsCount*110, y: 5, width: 100, height: 70)
            let button = getCategoryButtonAtPosition(buttonPosition, withCategoryId: category.categoryId!, andCategoryTitle: category.title!)
            scrollViewWithCount += 110
            addScrollViewUI(withButton: button, andIcon: categoryIcon)
            
            buttonsCount += 1
        }
        
        categoryScrollView.contentSize = CGSize(width: CGFloat(scrollViewWithCount + 50), height: categoryScrollView.frame.size.height)
        
    }
    
    //Create an icon for each category
    func getCategoryIconAtPosition(_ position: CGRect) -> UIImageView {
        let categoryIcon = UIImageView()
        categoryIcon.frame = position
        categoryIcon.image = UIImage(named: "category_icon.png")
        categoryIcon.contentMode = .scaleAspectFit
        categoryIcon.alpha = 0
        return categoryIcon
    }
    
    //Create a button for each category
    func getCategoryButtonAtPosition(_ position: CGRect, withCategoryId categoryId: String, andCategoryTitle categoryTitle: String) -> UIButton {
        let button = UIButton()
        button.setTitle(categoryTitle, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: (button.titleLabel?.font.fontName)!, size: 13)
        button.frame = position
        button.accessibilityIdentifier = categoryId
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(ProductListViewController.onChosenCategoryTap(_:)), for: .touchUpInside)
        button.alpha = 0
        return button
    }
    
    //Add button and icon in the scrollview
    func addScrollViewUI(withButton button: UIButton, andIcon icon: UIImageView) {
        categoryScrollView.addSubview(icon)
        categoryScrollView.addSubview(button)
        categoryScrollView.bringSubview(toFront: button)
        
        UIView.animate(withDuration: 0.3, animations: {
            icon.alpha = 1
            button.alpha = 1
        })
    }
    
    //On CategoryButton Click event - reaload the data filtering for the category
    func onChosenCategoryTap(_ button: UIButton) {
        
        //On category chosen fetch again db and online content
        //To get the most fresh data
        currentCategory = button.accessibilityIdentifier!
        fetchDatabase()
        
        closeCategoryView()
        categoryButton.setTitle(button.title(for: .normal), for: .normal)
    }
    
    func closeCategoryView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.categoryScrollView.subviews.forEach({ $0.removeFromSuperview() })
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y - 150, width: UIScreen.main.bounds.width, height: self.tableView.frame.size.height + 150)
            self.categoryView.frame = CGRect(x: 0, y: self.categoryView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.categoryView.frame.size.height - 150)
            self.cancelCategoryButton.alpha = 0
        })
    }
}

