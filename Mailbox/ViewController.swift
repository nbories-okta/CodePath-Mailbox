//
//  ViewController.swift
//  Mailbox
//
//  Created by Nicolas Bories on 2/21/15.
//  Copyright (c) 2015 Nico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {


    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainSegmentedController: UISegmentedControl!
    

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageBGView: UIView!
    
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    
    // Main
    var mainViewStartingX: CGFloat!
    
    // Message
    var messageViewOriginalCenter: CGPoint!
    var messageStartingX: CGFloat!
    var messageStartingXPanBegan: CGFloat!
    var messageFinalX: CGFloat!
    
    // Icons
    var iconBuffer: CGFloat!
    var laterIconX: CGFloat!
    var archiveIconX: CGFloat!
    
    // Colors
    var bgYellow = UIColor(red: 0.98, green: 0.83, blue: 0.2, alpha: 1.0)
    var bgBrown = UIColor(red: 0.85, green: 0.65, blue: 0.46, alpha: 1.0)
    var bgGreen = UIColor(red: 0.43, green: 0.85, blue: 0.38, alpha: 1.0)
    var bgRed = UIColor(red: 0.92, green: 0.32, blue: 0.2, alpha: 1.0)
    var bgGray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.contentSize = CGSize(width: 320, height: 1370)
        
        messageStartingX = messageImageView.frame.origin.x
        mainViewStartingX = mainView.frame.origin.x
        
        laterIconX = laterIcon.frame.origin.x
        archiveIconX = archiveIcon.frame.origin.x
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        self.mainView.addGestureRecognizer(edgeGesture)
        edgeGesture.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer){

        var translation = sender.translationInView(view)
        if (sender.state == UIGestureRecognizerState.Began) {
            mainViewStartingX = mainView.center.x
        } else  if (sender.state == UIGestureRecognizerState.Changed) {
            println("Translation of edge pan x: \(translation.x)")
            println("Center x of main container: \(mainViewStartingX)")
            println("main.center.x: \(mainView.center.x)")
            
            mainView.center.x = mainViewStartingX + translation.x
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (translation.x > 100) {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    //
                    self.mainView.center.x = 605
                    }, completion: { (Bool) -> Void in
                        //
                })
            } else if (translation.x < 100) {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    //
                    self.mainView.center.x = 320
                    }, completion: { (Bool) -> Void in
                        //
                })
            }
        }
    }
    
    @IBAction func didPressHamburgerButton(sender: UIButton) {
        if (mainView.center.x == 160.0) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.center.x = 605
            })
            
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.center.x = 320
            })
        }

    }
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var location = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            
            messageStartingXPanBegan = messageImageView.frame.origin.x
            laterIcon.alpha = 0
            archiveIcon.alpha = 0
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            messageFinalX = messageStartingXPanBegan + translation.x
            messageImageView.frame.origin.x = messageFinalX
            
            // short swipe left, show yellow on the right
            if (messageFinalX <= -60 && messageFinalX >= -260) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBGView.backgroundColor = self.bgYellow
                    self.laterIcon.alpha = 1
                    self.laterIcon.frame.origin.x = self.laterIconX + self.messageFinalX + 60
                    self.laterIcon.image = UIImage(named: "later_icon")
                })
                
            }
                
                // long swipe left, show brown on the right
            else if (messageFinalX <= -260) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBGView.backgroundColor = self.bgBrown
                    self.laterIcon.alpha = 1
                    self.laterIcon.image = UIImage(named: "list_icon") // change later icon image to list icon image
                })
            }
                
                // short swipe right, show buttons on the left
            else if messageFinalX >= 60 && messageFinalX <= 260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBGView.backgroundColor = self.bgGreen
                    self.archiveIcon.alpha = 1
                    self.archiveIcon.frame.origin.x = self.archiveIconX + self.messageFinalX - 60
                    self.archiveIcon.image = UIImage(named: "archive_icon")
                })
            }
                
                // long swipe right, show buttons on the left
            else if messageFinalX >= 260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBGView.backgroundColor = self.bgRed
                    self.archiveIcon.alpha = 1
                    self.archiveIcon.image = UIImage(named: "delete_icon") // change archive icon image to delete icon image
                })
            }
                
                // did not swipe far enough, reset to center
            else
            {
                messageBGView.backgroundColor = self.bgGray
                // use translate to figure out how much is visible, turn into a fraction to get opacity on icon
                laterIcon.alpha = -(translation.x)/60
                archiveIcon.alpha = (translation.x)/60
                //println("\(archiveIcon.alpha)")
            }
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            
            // when letting go on short left swipe, extend yellow and show reschedule screen
            if messageFinalX <= -60 && messageFinalX >= -260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.revealAllLeft ()
                    self.rescheduleView.alpha = 1
                })
            }
                
                
                // when letting go on long left swipe, extend brown and show list screen
            else if messageFinalX <= -260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.revealAllLeft ()
                    self.listView.alpha = 1
                })
            }
                
            else if messageFinalX >= 60 && messageFinalX <= 260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.revealAllRight()
                    })
                    {
                        // after the reveal animation is done, then do the collapse
                        (finished: Bool) -> Void in
                        self.collapseMessageView()
                }
                
            }
                
                
                // long swipe right, show buttons on the left
            else if messageFinalX >= 260
            {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.revealAllRight()
                    })
                    {
                        (finished: Bool) -> Void in
                        self.collapseMessageView()
                }
            }
                
                
                // did not swipe far enough, reset to center
            else
            {
                resetAll()
            }
        }
    }

    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.listView.alpha = 0
        })
        collapseMessageView()
    }
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rescheduleView.alpha = 0
        })
        collapseMessageView()
    }
    
    @IBAction func didPressReset(sender: UIButton) {
                resetAll()
    }
    
    
    
// functions
    func revealAllLeft () {
        self.messageImageView.frame.origin.x = -320
        self.laterIcon.frame.origin.x = 20
        self.archiveIcon.alpha = 0
    }
    
    
    func revealAllRight () {
        self.messageImageView.frame.origin.x = 320
        self.archiveIcon.frame.origin.x = 290
        self.laterIcon.alpha = 0
    }
    
    
    func collapseMessageView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messageBGView.frame.origin.y = -86
            self.feedImageView.frame.origin.y = self.feedImageView.frame.origin.y - self.messageBGView.frame.height
            self.resetButton.alpha = 1
        })
    }
    
    
    func resetAll() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.messageBGView.frame.origin.y = 79
            self.feedImageView.frame.origin.y = 165
            self.messageImageView.frame.origin.x = 0
            self.resetButton.alpha = 0
        })
    }

}

