//
//  TweetCell.h
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetCellDelegate <NSObject>

- (void)replyToStatus:(NSString *)statusId fromAuthor:(NSString *)screenName;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@property (nonatomic, strong) Tweet *tweet;

@end