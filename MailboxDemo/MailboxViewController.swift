//
//  MailboxViewController.swift
//  MailboxDemo
//
//  Created by Scott Horsfall on 6/2/16.
//  Copyright © 2016 Scott Horsfall. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var mainViewPan: UIPanGestureRecognizer!
    
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var archiveImage: UIImageView!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var archiveIconView: UIView!
    @IBOutlet weak var laterIconView: UIView!
    
    //icons
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    
    //screenswipe vars 
    var mainRightOffset: CGFloat!
    var mainLeft: CGPoint!
    var mainRight: CGPoint!
    
    //original centers
    var mainViewOriginalCenter: CGPoint!
    var messageOriginalCenter: CGPoint!
    var archiveIconOriginalCenter: CGPoint!
    var laterIconOriginalCenter: CGPoint!
    
    //message positions
    var messageRight: CGPoint!
    var messageLeft: CGPoint!
    var messageOffset: CGFloat!
    
    //message status
    var isMessageInView: Bool! = true
    
    //colors
    var backgroundRed = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    var backgroundGreen = UIColor(red: 25/255.0, green: 156/255.0, blue: 54/255.0, alpha: 1.0)
    var backgroundGrey = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
    var backgroundYellow = UIColor(red: 248/255.0, green: 203/255.0, blue: 39/255.0, alpha: 1.0)
    var backgroundBrown = UIColor(red: 206/255.0, green: 150/255.0, blue: 98/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add height of all images in scroll view
        let imageViewHeight = feedImage.frame.height + helpImage.frame.height + searchImage.frame.height
        // add height of all images into CGSize variable
        let imageViewSize = CGSize(width: feedImage.frame.width, height: imageViewHeight)
        
        scrollView.contentSize = imageViewSize
        
        //setup the screenedge swipe vals
        mainRightOffset = 284
        mainLeft = mainView.center
        mainRight = CGPoint(x: mainView.center.x + mainRightOffset, y: mainView.center.y)
        
        //hide some of the icons images
        laterIconView.alpha = 0
        archiveIconView.alpha = 0
        deleteIconImage.alpha = 0
        listIconImage.alpha = 0
        
        rescheduleImage.alpha = 0
        archiveImage.alpha = 0
        
        //disable pan gesture on load, enable mainview when swiped right
        mainViewPan.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func messageInView(add: Bool) {
        
        // move message view + feed view up the height of message view
        let messageViewHeight = messageView.frame.height + 1
        
        if add {
            // add message to view
            
            self.messageView.alpha = 1
            
            UIView.animateWithDuration(0.2, animations: {
                self.messageView.center.y += messageViewHeight
                self.feedImage.center.y += messageViewHeight
                self.scrollView.contentSize.height += messageViewHeight
            }) { (Bool) in
                // change scrollview size
                
            }

            isMessageInView = true
        } else {
            // remove message from view
            
            UIView.animateWithDuration(0.2, animations: {
                self.messageView.center.y -= messageViewHeight
                self.feedImage.center.y -= messageViewHeight
                
            }) { (Bool) in
                //hide the messageView when animation complete
                self.messageView.alpha = 0
                
                // change scrollview size
                self.scrollView.contentSize.height -= messageViewHeight
            }
            
            isMessageInView = false
        }
    }
    
    
    @IBAction func onTapFullImage(sender: UITapGestureRecognizer) {
        //for this assignment, use same action function from both archive and reschedule images
        self.archiveImage.alpha = 0
        self.rescheduleImage.alpha = 0
        
        messageInView(false)
        
    }
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            messageOriginalCenter = messageImage.center
            archiveIconOriginalCenter = archiveIconView.center
            laterIconOriginalCenter = laterIconView.center
            
            //Moving Message
            messageOffset = 320
            messageRight = CGPoint(x: messageImage.center.x + messageOffset, y: messageImage.center.y)
            messageLeft = CGPoint(x: messageImage.center.x - messageOffset, y: messageImage.center.y)
            
            //reset colors and alphas
            messageView.backgroundColor = backgroundGrey
            archiveIconImage.alpha = 1
            deleteIconImage.alpha = 0
            laterIconImage.alpha = 1
            listIconImage.alpha = 0
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageImage.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            messageView.backgroundColor = backgroundGrey
            
            // determine swipe direction
            if messageImage.center.x > messageOriginalCenter.x {
                //archive
                
                let progress = convertValue(abs(translation.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIconView.alpha = progress
                
                if abs(translation.x) >= 60 {
                    //move icon
                    archiveIconView.center = CGPoint(x: archiveIconOriginalCenter.x + translation.x - 60, y: archiveIconOriginalCenter.y)
                    
                    //change to green
                    messageView.backgroundColor = backgroundGreen
                    
                    //for when moving back from 260
                    archiveIconImage.alpha = 1
                    deleteIconImage.alpha = 0
                    
                    if abs(translation.x) >= 260 {
                        // change icon to delete icon
                        archiveIconImage.alpha = 0
                        deleteIconImage.alpha = 1
                        // background color to red
                        messageView.backgroundColor = backgroundRed
                    }
                }

            } else {
                //later
               
                let progress = convertValue(abs(translation.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                laterIconView.alpha = progress
                
                if abs(translation.x) >= 60 {
                    //move icon
                    laterIconView.center = CGPoint(x: laterIconOriginalCenter.x + translation.x + 60, y: laterIconOriginalCenter.y)
                    
                    //change to yellow
                    messageView.backgroundColor = backgroundYellow
                    
                    //for when moving back from 260
                    laterIconImage.alpha = 1
                    listIconImage.alpha = 0
                    
                    if abs(translation.x) >= 260 {
                        // change icon to list icon
                        laterIconImage.alpha = 0
                        listIconImage.alpha = 1
                        // background color to brown
                        messageView.backgroundColor = backgroundBrown
                    }
                }
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if abs(translation.x) >= 60 {
                //swipe that stuff away yo'
                //tl;dr if translated more than 60 in either direction
                
                if velocity.x > 0 {
                    //archive the message
                    
                    messageView.backgroundColor = backgroundRed
                    self.archiveIconView.alpha = 0
                    
                    UIView.animateWithDuration(0.2, animations: {
                        //animate the message
                        self.messageImage.center = self.messageRight
                        }, completion: { (Bool) in
                            //when anim complete, show image
                            self.archiveImage.alpha = 1
                    })
                    
                } else {
                    //later the message
                    
                    messageView.backgroundColor = backgroundBrown
                    self.laterIconView.alpha = 0
                    
                    UIView.animateWithDuration(0.2, animations: {
                        //animate the message
                        self.messageImage.center = self.messageLeft
                        }, completion: { (Bool) in
                            //when anim complete, show image
                            self.rescheduleImage.alpha = 1
                    })
                    
                }
                
            } else {
                // reset to center, didn't translate 60
                
                resetMessageView(true)
                
                /*
                UIView.animateWithDuration(0.2, animations: {
                    self.messageImage.center = self.messageOriginalCenter
                })
                
                //reset icons
                archiveIconView.alpha = 0
                laterIconView.alpha = 0
                
                archiveIconView.center = archiveIconOriginalCenter
                laterIconView.center = laterIconOriginalCenter
                */
            }
        }
    }
    
    func resetMessageView(animate: Bool) {
        
        if animate {
            UIView.animateWithDuration(0.2, animations: {
                self.messageImage.center = self.messageOriginalCenter
            })
        } else {
            self.messageImage.center = self.messageOriginalCenter
        }
        
        //reset icons
        archiveIconView.alpha = 0
        laterIconView.alpha = 0
        
        archiveIconView.center = archiveIconOriginalCenter
        laterIconView.center = laterIconOriginalCenter
    }
    
    func mainViewSnap(snapright: Bool) {
        // custom function to snap the main view
        // used in the screen edge pan gesture and
        
        if snapright {
            //snap to the right
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1,  options: [], animations: {
                () -> Void in self.mainView.center = self.mainRight
                }, completion: { (Bool) -> Void in
                    //disable the mainViewPan gesture
                    self.mainViewPan.enabled = true
            })
        } else {
            //snap to the left
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,  options: [], animations: {
                () -> Void in self.mainView.center = self.mainLeft
                }, completion: { (Bool) -> Void in
                    //disable the mainViewPan gesture
                    self.mainViewPan.enabled = false
            })
        }
    }
    
    func mainViewPan(sender: UIPanGestureRecognizer) {
        // main function to handle both edge and pan gestures
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            mainViewOriginalCenter = mainView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            mainView.center.x = mainViewOriginalCenter.x + translation.x
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if velocity.x > 0 {
                // move right
                mainViewSnap(true)
            } else {
                // move left
                mainViewSnap(false)
            }
        }
    }
    
    @IBAction func onMainViewPanGesture(sender: UIPanGestureRecognizer) {
        
        mainViewPan(sender)
        
    }
    
    @IBAction func onScreenEdgeGesture(sender: UIScreenEdgePanGestureRecognizer) {
        
        mainViewPan(sender)
    }
    
    @IBAction func onSegmentedControlTap(sender: AnyObject) {
        
        if sender.selectedSegmentIndex == 0 {
            
            print("Go to scheduled")
            
        } else if sender.selectedSegmentIndex == 1 {
            
            print("Go to main mailbox")
            
        } else if sender.selectedSegmentIndex == 2 {
            
            print("Go to archive")
            
        }
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && isMessageInView == false {
            
            let undoAlert = UIAlertController(title: "Undo Remove", message: nil, preferredStyle: .Alert)
            
            let undoAction = UIAlertAction(title: "Undo", style: .Default) { (action) in
                
                //undo removing from view
                self.resetMessageView(false)
                //TODO: this isn't animating now... :/
                self.messageInView(true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // do nothing
            }
            
            // add buttons
            undoAlert.addAction(cancelAction)
            undoAlert.addAction(undoAction)
            
            presentViewController(undoAlert, animated: true) {
                // when finished presenting
            }
            
        }
        
    }
    
}
