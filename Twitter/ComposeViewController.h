//
//  ComposeViewController.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)reloadTweetInView:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, strong) NSString *inReplyToScreenName;

@end
