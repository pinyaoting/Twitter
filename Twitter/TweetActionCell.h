//
//  TweetActionCell.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetActionCellDelegate <NSObject>

- (void)replyToStatus:(NSString *)statusId fromAuthor:(NSString *)screenName;
- (void)onRetweet;
- (void)onFavorite;

@end

@interface TweetActionCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetActionCellDelegate> delegate;

@end
