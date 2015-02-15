//
//  TweetDetailCell.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailCellDelegate <NSObject>

- (void)tapOnProfileImageOfScreenName:(User *)user;

@end

@interface TweetDetailCell : UITableViewCell

@property (nonatomic, weak) id<TweetDetailCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

@end
