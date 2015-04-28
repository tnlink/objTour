//
//  DataViewController.m
//  TrainsInHand
//
//  Created by Adam Tang on 01/02/2015.
//  Copyright (c) 2015 Adam Tang. All rights reserved.
//

#import "DataViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DataViewController ()

@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (nonatomic) NSTimeInterval offset;
@property (nonatomic) SystemSoundID soundID;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CurrentTime.text = [DataViewController displayTime];
    self.expectedTimeTextField.delegate = self;
    
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[NSURL URLWithString:@"/System/Library/Audio/UISounds/alarm.caf"], &(_soundID));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

+ (NSString *)displayTime{
    NSDateFormatter *formatter;
    NSString *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss MM/dd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}

- (IBAction)pollDidPressed:(id)sender {
    [self startPoll];
}

- (void)longPoll
{
    //compose the request
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSURL* requestUrl = [NSURL URLWithString:@"http://ec2-52-10-127-200.us-west-2.compute.amazonaws.com:1337/"];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestUrl];
    
    //send the request (will block until a response comes back)
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response error:&error];
    
    //pass the response on to the handler (can also check for errors here, if you want)
    [self performSelectorOnMainThread:@selector(dataReceived:)
                           withObject:responseData waitUntilDone:YES];
    
    //send the next poll request
    [self performSelectorInBackground:@selector(longPoll) withObject: nil];
}

- (void)startPoll
{
    //not covered in this example:  stopping the poll or ensuring that only 1 poll is active at any given time
    [self performSelectorInBackground:@selector(longPoll) withObject: nil];
}

- (void)dataReceived:(NSData*)theData
{
    //process the response here
    NSString *response = [[NSString alloc] initWithData:theData encoding:NSStringEncodingConversionAllowLossy];
    if (response != nil) {
        NSLog(@"%@", response);
    }
}

- (void)updateTimer:(NSTimer *)timer
{
    self.offset -= 1;
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSDate *newTime = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(self.offset)];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:newTime];
    self.remainTimeLabel.text = timeString;
    
    [self.view endEditing:YES];
    
    if (self.offset <= 0)
    {
        self.remainTimeLabel.text = @"Time is up";
        self.timerStartButton.enabled = YES;
        [self.stopWatchTimer invalidate];
        AudioServicesPlaySystemSound(_soundID);
    }
}

- (IBAction)startTimeDidPress:(id)sender
{
    NSString *text = self.expectedTimeTextField.text;
    
    NSArray *comps = [text componentsSeparatedByString:@":"];
    if ([comps count] == 2) {
        int minutes = [comps[0] intValue];
        int seconds = [comps[1] intValue];
        self.offset = minutes * 60 + seconds;
    }
    
    self.remainTimeLabel.text = text;

    // Create the stop watch timer that fires every 1 second
    if ([self.stopWatchTimer isValid]) {
        [self.stopWatchTimer invalidate];
    }
    
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    self.timerStartButton.enabled = NO;
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self startTimeDidPress:self];
    
    return YES;
}

#pragma viewwillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    AudioServicesDisposeSystemSoundID(_soundID);
}

@end
