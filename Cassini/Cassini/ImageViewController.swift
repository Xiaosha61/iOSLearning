 //
//  ImageViewController.swift
//  Cassini
//
//  Created by Sasa's Macbook on 17/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil { //fetch only when the view is currently on the screen
                fetchImage()
            }
            
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            
            /*
            //frozen problem:
            if let imageData = NSData(contentsOf: url as URL) {
                if url == self.imageURL {
                    self.image = UIImage(data: imageData as Data)
                } else {
                    print("ignored data returned from url \(url)")
                }
            }
            */
            
            /*
            //approach1(GCD-API): create a custom queue and schedule tasks on that queue
            let myQueue = DispatchQueue(label: "testGCD")
            myQueue.async {
                if let imageData = NSData(contentsOf: url as URL) {
                    if url == self.imageURL {
                        DispatchQueue.main.async {  //bring UI-related works back to main queue.
                            self.image = UIImage(data: imageData as Data)
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                    
                }
            }
            */
 
            // approach2(GCD-API): dispatch tasks on a global queue(the userInteractive queue) that’s provided by the system
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{ ()-> Void in
                if let imageData = NSData(contentsOf: url as URL) {
                    if url == self.imageURL {
                        DispatchQueue.main.async {
                            self.image = UIImage(data: imageData as Data)
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                }
                
            }

  
            /*
            // approach3(NSOperationQueue-API):
            let myQueue = OperationQueue()
            myQueue.addOperation{()-> Void in
                if let imageData = NSData(contentsOf: url as URL) {
                    if url == self.imageURL {
                        DispatchQueue.main.async {
                            self.image = UIImage(data: imageData as Data)
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                }
            }
            */
  
            
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView() //frame(0,0,0,0)
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // this computed property makes set and get image easier
    // the size will be reset when you set new image  to the imageView
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit() //this will set the imageView's size to whatever the image in it
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil { //prevent repeating loading
            fetchImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView) //view: the view that this controller controls
        //imageURL = NSURL(string: DemoURL.SchumannBau)
    }
}
