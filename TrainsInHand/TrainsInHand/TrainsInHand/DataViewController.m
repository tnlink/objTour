//
//  DataViewController.m
//  TrainsInHand
//
//  Created by Adam Tang on 01/02/2015.
//  Copyright (c) 2015 Adam Tang. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
//- (IBAction)timerTextUpdated:(id)sender;

@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate *startDate;



@end

@implementation DataViewController

@synthesize SetTimeTextField;

@synthesize RemainTimeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CurrentTime.text = [DataViewController displayTime];
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

- (void) longPoll {
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

- (void) startPoll {
    //not covered in this example:  stopping the poll or ensuring that only 1 poll is active at any given time
    [self performSelectorInBackground:@selector(longPoll) withObject: nil];
}

- (void) dataReceived: (NSData*) theData {
    //process the response here
    NSString *response = [[NSString alloc] initWithData:theData encoding:NSStringEncodingConversionAllowLossy];
    if (response != nil) {
        NSLog(@"%@", response);
    }
}

- (void) updateTimer:(NSTimer *)timer {
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    self.RemainTimeLabel.text = timeString;
}

- (IBAction) startTimeDidPress: (id) sender {
    NSString *text = self.SetTimeTextField.text;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"mm:ss"];
    // NSDate *duration = [dateformat dateFromString:text];
    RemainTimeLabel.text = text;
    
    self.startDate = [NSDate date];
    
    // Create the stop watch timer that fires every 100 ms
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
}

/*
- (IBAction) timerTextUpdated: (id) sender {
    NSString *text = self.SetTimeTextField.text;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"mm:ss"];
    // NSDate *duration = [dateformat dateFromString:text];
    RemainTimeLabel.text = text;
}
 */

@end
