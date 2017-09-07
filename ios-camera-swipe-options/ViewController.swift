//
//  ViewController.swift
//  ios-camera-swipe-options
//
//  Created by Minhaz on 07/09/17.
//  Copyright © 2017 aub. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iOSSwipeOptionsDelegate {

    @IBOutlet weak var swipe_view : iOSSwipeOptions!
    
    // selected index
    var itemIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup swipable view
        self.setupiOSSwipableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // select item index
        self.swipe_view.selectItemAtIndex(index: itemIndex)
    }
    
    // Setup ios swipe options view
    func setupiOSSwipableView() {
        
        swipe_view.delegate = self
        swipe_view.swippableView = self.view
        swipe_view.items = ["TIME-LAPSE","SLO-MO","VIDEO","PHOTO","SQUARE","PANO"]
        swipe_view.setup()
    }
    
    //MARK: - iOSSwipeOptionsDelegate
    func didSwipeToItem(_ item: String, index: Int) {
        print(">> item : \(item)   : index : \(index)")
    }

}

