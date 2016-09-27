//
//  TwitterClient.h
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userDetailsWithScreenName:(NSString *)screenName completion:(void (^)(User *user, NSError *error))completion ;
- (void)tweets:(NSString *)status inReplyToStatus:(NSString *)statusId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweet:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)untweet:(NSString *)tweetId origTweet:(Tweet *)origTweet;
- (void)favorite:(NSString *)tweetId;
- (void)unfavorite:(NSString *)tweetId;

@end
