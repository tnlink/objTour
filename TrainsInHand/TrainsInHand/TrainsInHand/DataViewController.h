//
//  DataViewController.h
//  TrainsInHand
//
//  Created by Adam Tang on 01/02/2015.
//  Copyright (c) 2015 Adam Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PollAction;
@property (weak, nonatomic) IBOutlet UIButton *TimerStartButton;
@property (weak, nonatomic) IBOutlet UITextField *SetTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *RemainTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UILabel *CurrentTime;

// actions
- (IBAction)startTimeDidPress:(id)sender;
- (void) updateTimer:(NSTimer *)timer;

@end

