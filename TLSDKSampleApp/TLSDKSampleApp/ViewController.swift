//
//  ViewController.swift
//  TLSDKSampleApp
//
//  Copyright © 2017 TripleLift. All rights reserved.
//

import UIKit
import TripleLiftSDK

class ViewController: UIViewController, TLAdLoadDelegate {

    var adView : TLAdView? = nil
    @IBOutlet weak var placeHoldeview : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loadAd() {
        adView = TLAdView(frame: (placeHoldeview?.bounds)!)
        adView?.tagURLString = "http://tlx.3lift.net/mw/auction?id=10838"
        let signals =  TLAdSignals().appSignalsData()
        adView?.adSignals = signals
        adView?.adLoadDelegate = self
        adView?.loadAd()
        
        placeHoldeview?.subviews.forEach { $0.removeFromSuperview() }
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray);
        spinner.center = CGPoint(x: (placeHoldeview?.frame.width)! / 2.0, y: (placeHoldeview?.frame.height)! / 2.0)
        placeHoldeview?.addSubview(spinner)
        spinner.startAnimating()
    }
    
    // MARK: - TLAdLoadDelegate methods
    func adReady(_ adView: TLAdView!) {
        placeHoldeview?.subviews.forEach { $0.removeFromSuperview() }
        placeHoldeview?.addSubview(adView)
    }
    
    func adLoadFailed(_ error: TLAdError) {
        print("Error: %@", error)
    }
}



