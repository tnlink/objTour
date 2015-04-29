//
//  DataViewController.h
//  TrainsInHand
//
//  Created by Adam Tang on 01/02/2015.
//  Copyright (c) 2015 Adam Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pollAction;
@property (weak, nonatomic) IBOutlet UIButton *timerStartButton;
@property (weak, nonatomic) IBOutlet UITextField *expectedTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UILabel *CurrentTime;
@property (weak, nonatomic) IBOutlet UISwitch *beepInHalfTime;

// actions
- (IBAction)startTimeDidPress:(id)sender;
- (void) updateTimer:(NSTimer *)timer;
- (IBAction)resetTimer:(id)sender;

@end

