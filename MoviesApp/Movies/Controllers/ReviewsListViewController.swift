//
//  ReviewsListViewController.swift
//  Movies
//
//  Created by ios-manha-07 on 15/07/24.
//

import Foundation
import UIKit

class ReviewsListViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        addRateOptions()
    }
    
    private func addRateOptions() {
        segmentedControl.removeAllSegments()
        
        for (index, option) in RateOptions.allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: option.rawValue, at: index, animated: false)
        }
        
        segmentedControl.removeSegment(at: 0, animated: false)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
    }
    
    
    @IBAction func filterTapped(_ sender: Any) {
        
    }
    
    
    
    
}
