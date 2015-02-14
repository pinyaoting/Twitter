//
//  TweetsViewController.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController

@property (nonatomic, assign) NSInteger timeline;

- (void)onRefresh;

@end
