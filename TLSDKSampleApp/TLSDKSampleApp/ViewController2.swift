//
//  ViewController2ViewController.swift
//  TLSDKSampleApp
//
//  Created by Alexander Prokofiev on 10/3/17.
//  Copyright © 2017 TripleLift. All rights reserved.
//

import UIKit
import TripleLiftSDK


class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate, TLAdLoadDelegate {
    
    let HeadingTag = 10
    let CaptionTag = 11
    let AdViewTag = 12
    
    let CellHeight : CGFloat = 75.0
    
    let CellIdentifier = "CellIdentifier";
    let ADCellIdentifier = "ADCellIdentifier";
    

    @IBOutlet weak var tableView : UITableView?
    
    var adView :TLAdView? = nil
    
    let desiredAdPosition = 3
    
    var items = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6","Item 7"]
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonHandler() {
        self.dismiss(animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if (items[indexPath.row] == "TLAdItem") {
            cell = tableView.dequeueReusableCell(withIdentifier: ADCellIdentifier, for: indexPath)
//            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            adView?.frame = cell.bounds
            cell.contentView.addSubview(adView!)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            let headingLabel : UILabel = cell.contentView.viewWithTag(HeadingTag) as! UILabel;
            let captionLabel : UILabel = cell.contentView.viewWithTag(CaptionTag) as! UILabel;
            headingLabel.text = "Some Caption"
            captionLabel.text = "Some Test Heading"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight
    }

    
    @IBAction func loadAd() {
        adView = TLAdView(frame: (CGRect(x: 0, y: 0, width: (tableView?.frame.width)!, height: CellHeight)))
        adView?.tagURLString = "http://tlx.3lift.net/mw/auction?id=10836"

        let signals =  TLAdSignals().appSignalsData()
        adView?.adSignals = signals
        adView?.adLoadDelegate = self
        adView?.loadAd()
    }
    
    func adReady(_ adView: TLAdView!) {
        items.insert("TLAdItem", at: desiredAdPosition)
        tableView?.reloadData()
    }
    
    func adLoadFailed(_ error: TLAdError) {
        print("Error: %@", error)
    }

}
