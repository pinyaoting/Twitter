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
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)retweet;
- (void)favorite;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
+ (void)tweetsFromHomeTimelineWithParams:(NSArray *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
