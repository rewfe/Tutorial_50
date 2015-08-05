//
//  IAPurchaceViewController.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import StoreKit

protocol IAPurchaceViewControllerDelegate {
    
    func didBuyColorsCollection(collectionIndex: Int)
    
}

class IAPurchaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver
{


    @IBOutlet weak var tblProducts: UITableView!
    
    var productIDs: Array<String!> = []
    
    var productsArray: Array<SKProduct!> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    
    var delegate: IAPurchaceViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        tblProducts.delegate = self
        tblProducts.dataSource = self
        productIDs.append("iapdemo_extra_colors_col1")
        productIDs.append("iapdemo_extra_colors_col2")
        requestProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: IBAction method implementation
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellProduct", forIndexPath: indexPath) as! UITableViewCell
        
        let product = productsArray[indexPath.row]
        cell.textLabel?.text = product.localizedTitle
        cell.detailTextLabel?.text = product.localizedDescription
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<NSObject>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            println("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product as! SKProduct)
            }
            
            tblProducts.reloadData()
        }
        else {
            println("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            println(response.invalidProductIdentifiers.description)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProductIndex = indexPath.row
        showActions()
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "IAPDemo", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                println("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                delegate.didBuyColorsCollection(selectedProductIndex)
                
                
            case SKPaymentTransactionState.Failed:
                println("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                println(transaction.transactionState.rawValue)
            }
        }
    }
}
