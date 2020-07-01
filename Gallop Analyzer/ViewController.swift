//
//  ViewController.swift
//  Gallop Analyzer
//
//  Created by Vishaal Kumar on 6/20/20.
//  Copyright © 2020 Vishaal Kumar. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentImageView: UIImageView!
    
    //This is the classifier we are using to segment the tweets
    let sentimentClassifier = GallopSentimentClassifier()
    
    //TODO :- Insert the registered Twitter Keys
    let swifter = Swifter(consumerKey: "Insert ConsumerKey" , consumerSecret: "Inster ConsumerSecretKey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func predictButtonPressed(_ sender: UIButton) {
        
        if let text = textField.text {
            
            
            
            //Scraping through Twitter returtning the 100 latest english tweets related to the inputted text
            swifter.searchTweet(using: text, lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                
                //array of extracted tweets
                var scrapedTweets = [GallopSentimentClassifierInput]()
                
                for i in 0 ..< 100 {
                    if let tweet = results[i]["full_text"].string {
                        //Converting the tweet string into a ClassifierInput object
                        let ciObject = GallopSentimentClassifierInput(text: tweet)
                        scrapedTweets.append(ciObject)
                    }
                }
                
                do {
                    
                    //Array of objects whose label is a string which contains a value of the sentiment of the inputted tweet
                    let predictions = try self.sentimentClassifier.predictions(inputs: scrapedTweets)
                    
                    // This is the score assessing the overall sentiment of the 100 tweets
                    var score = 0
                    
                    for prediction in predictions {
                        let sentiment = prediction.label
                        if sentiment == "Pos" {
                            score += 1
                        } else if sentiment == "Neg" {
                            score -= 1
                        }
                    }
                    
                    print(score)
                    
                    //TODO:- Insert conditions based on score value
                    // If score is greater than 50, then display a certain image, etc.
                    
                } catch {
                    print("Error in making predcitions : \(error)")
                }
                
            }) { (error) in
                print("Twitter API Request Error : \(error)")
            }
        }
    }
    
}

