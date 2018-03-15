//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/15/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    public var correct = 0
    public var length = 0
    
    func incoming(incomingCorrect: Int, incomingLength: Int) {
        self.correct = incomingCorrect
        self.length = incomingLength
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch Double(correct) / Double(length) {
        case 1.0:
            finishLabel!.text = "Perfect!"
        case 0.75..<1.0:
            finishLabel!.text = "Almost!"
        default:
            finishLabel!.text = "Better luck next time..."
        }
        answersLabel!.text = "You got \(correct) out of \(length) questions correct"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "FinishHome":
            let destination = segue.destination as? ViewController
            destination?.setLoaded(load: true)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
