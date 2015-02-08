//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailViewControllerDelegate <NSObject>

- (void)reloadTweetsInView:(NSArray *)tweets;

@end

@interface TweetDetailViewController : UIViewController

@property (nonatomic, weak) id<TweetDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

@end
