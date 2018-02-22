//
//  ViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var quizTable: UITableView!
    var url : String = ""
    var quizzes : [Quiz]? = nil
    var jsonObj : NSArray = []
    var storedURL : String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberofRowsInSection called")
        return quizzes!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("We are being asked for indexPath \(indexPath)")
        let index = indexPath.row
        let quiz = quizzes![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = quiz.name
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(named: ("\(quiz.image)"))
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.storedURL = UserDefaults.standard.string(forKey: "quiz_url")!
        if self.storedURL.count > 0 {
            downloadJSON(website: self.storedURL)
        } else if self.url.count > 0 {
            downloadJSON(website: self.url)
        } else {
            self.quizzes = UIApplication.shared.quizRepository.getQuizzes()
        }
        quizTable.dataSource = self
        quizTable.delegate = self
        quizTable.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingsPushed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Settings", message: "Settings for the quiz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        alert.addTextField { (textField) in
            textField.text = "https://tednewardsandbox.site44.com/questions.json"
            self.url = textField.text!
        }
        
        alert.addAction(UIAlertAction(title: "Check Now", style: .default) { _ in
            self.downloadJSON(website: self.url)
        })
        
        self.present(alert, animated: true, completion: {
            NSLog("The completion handler fired")
        })
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func downloadJSON(website: String) {
        var q : [Quiz] = []
        if Reachability.isConnectedToNetwork() {
            let url = NSURL(string: website)
            URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
                if error != nil {
                    let jsonAlert = UIAlertController(title: "Error", message: "JSON Download failed", preferredStyle: .alert)
                    jsonAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        jsonAlert.dismiss(animated: true)
                    })
                    self.present(jsonAlert, animated: true)
                } else {
                    if let dat = data {
                        //let jsonData = string?.data(using: .utf8)
                        print("hello")
                        var json = try! JSONSerialization.jsonObject(with: dat, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        self.quizzes = self.getData(jsonObj: json)
                    }
                }
                
            }).resume()
        } else {
            let networkAlert = UIAlertController(title: "Network Error", message: "No Network Connection", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                networkAlert.dismiss(animated: true)
            })
            self.present(networkAlert, animated: true)
            
            self.quizzes = self.loadFromLocalStorage()
        }
    }
    
    func getData(jsonObj : NSArray) -> [Quiz] {
        var q : [Quiz] = []
        for i in 0...jsonObj.count - 1 {
            let quiz = jsonObj[i] as! [String : Any]
            let questions = quiz["questions"] as! [[String: Any]]
            var q_a: [QuestionAnswer] = []
            for question in questions {
                q_a.append(QuestionAnswer(question: question["text"] as! String, answers: question["answers"] as! [String], correctAnswer: Int(question["answer"] as! String)!))
            }
            q.append(Quiz(name: quiz["title"] as! String, description: quiz["desc"] as! String, image: "\(quiz["title"]!).png", questionAnswers: q_a))
        }
        
        DispatchQueue.main.async {
            self.quizTable.reloadData()
        }
        return q
    }
    
    func loadFromLocalStorage() -> [Quiz] {
        var fm = FileManager.default
        let jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.json")
        let data = NSArray(contentsOf: jsonURL) as? NSArray
        return getData(jsonObj: data!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let count = 1
        switch segue.identifier! {
        case "QuestionSegue":
            let destination = segue.destination as! QuestionViewController
            let cell = sender as! UITableViewCell; let indexPath = quizTable.indexPath(for: cell)
            let quiz = self.quizzes![(indexPath?.row)!]
            destination.setQuestionLabel(incoming: quiz.questionAnswers[count - 1].question)
            destination.setAnswers(incomingAnswers: quiz.questionAnswers[count - 1].answers, correctAnswer: quiz.questionAnswers[count - 1].correctAnswer, counter: count, quizLength: quiz.questionAnswers.count)
            destination.setQuiz(incomingQuiz: quiz)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

