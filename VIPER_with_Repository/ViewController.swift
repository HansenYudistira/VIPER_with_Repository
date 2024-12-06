//
//  ViewController.swift
//  VIPER_with_Repository
//
//  Created by Hansen Yudistira on 04/12/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

}
