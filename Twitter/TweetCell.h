//
//  TweetCell.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@protocol TweetCellDelegate <NSObject>

- (void)replyToStatus:(NSString *)statusId fromAuthor:(NSString *)screenName;
- (void)tapOnProfileImageOfScreenName:(User *)user;

@end

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

- (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer;

@end