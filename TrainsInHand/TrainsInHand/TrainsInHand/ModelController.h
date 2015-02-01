//
//  ModelController.h
//  TrainsInHand
//
//  Created by Adam Tang on 01/02/2015.
//  Copyright (c) 2015 Adam Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

