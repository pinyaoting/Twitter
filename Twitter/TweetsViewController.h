//
//  TweetsViewController.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetsViewControllerDelegate <NSObject>

- (void)presentViewController:(UIViewController *)vc;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, assign) NSInteger timeline;
@property (nonatomic, weak) id<TweetsViewControllerDelegate> delegate;

- (void)onRefresh;

@end
