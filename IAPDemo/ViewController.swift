//
//  ViewController.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IAPurchaceViewControllerDelegate
{

    @IBOutlet weak var viewCanvas: CanvasView!
    
    @IBOutlet weak var btnGreen: UIButton!
    
    @IBOutlet weak var btnBlue: UIButton!
    
    @IBOutlet weak var btnBlack: UIButton!
    
    @IBOutlet weak var btnGray: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnGreen.hidden = true
        btnBlue.hidden = true
        btnBlack.hidden = true
        btnGray.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: IBAction method implementation
    
    @IBAction func setColor(sender: AnyObject) {
        viewCanvas.selectedStrokeColor = (sender as! UIButton).backgroundColor!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueIAP" {
            let iapViewController = segue.destinationViewController as! IAPurchaceViewController
            iapViewController.delegate = self
        }
    }
    
    func didBuyColorsCollection(collectionIndex: Int) {
        if collectionIndex == 0 {
            btnGreen.hidden = false
            btnBlue.hidden = false
        }
        else {
            btnBlack.hidden = false
            btnGray.hidden = false
        }
    }
}

