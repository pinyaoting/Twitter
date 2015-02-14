//
//  Tweet.h
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *retweetCount;
@property (nonatomic, strong) NSString *favoriteCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)retweet;
- (void)untweet;
- (void)favorite;
- (void)unfavorite;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
+ (void)tweetsFromHomeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
+ (void)tweetsFromMentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
+ (void)tweets:(NSString *)status inReplyToStatus:(NSString *)statusId completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
