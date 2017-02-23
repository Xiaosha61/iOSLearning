//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Sasa's Macbook on 17/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    // store all strings in my storyboard in this struct
    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            if let ivc = segue.destination.contentViewController as? ImageViewController{
                /*
                if let sendingButton = sender as? UIButton {
                    let imageName = sendingButton.currentTitle
                }
                */
                //using optional chaining instead
                let imageName = (sender as? UIButton)?.currentTitle
                ivc.imageURL = DemoURL.NASAImageNamed(imageName: imageName)
                ivc.title = imageName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController, ivc.imageURL == nil {
                return true // I handle it(screen show CassiniView when imageURL is nil)
            }
        }
        
        return false //system handles it (screen shows ScrollView as planed )
    }

}

extension UIViewController { //extension for all UIViewController
    var contentViewController: UIViewController {
        get {
            if let navcon = self as? UINavigationController{
                return navcon.visibleViewController ?? self
            } else {
                return self
            }
        }
    }
}






