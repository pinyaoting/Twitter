//
//  Tweet.m
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@interface Tweet()

@property (nonatomic, strong) NSString *retweetId;

@end

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.tweetId = dictionary[@"id_str"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.retweetCount = [NSString stringWithFormat:@"%@",dictionary[@"retweet_count"]];
        self.favoriteCount = [NSString stringWithFormat:@"%@",dictionary[@"favorite_count"]];
        self.retweeted = [[NSString stringWithFormat:@"%@", dictionary[@"retweeted"]] isEqual: @"0"] ? NO : YES;
        self.favorited = [[NSString stringWithFormat:@"%@", dictionary[@"favorited"]] isEqual: @"0"] ? NO : YES;
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";        
        self.createdAt = [formatter dateFromString:createdAtString];
    }
    
    return self;
}

- (void)retweet {
    self.retweeted = YES;
    self.retweetCount = [NSString stringWithFormat:@"%ld", [self.retweetCount integerValue] + 1];
    [[TwitterClient sharedInstance] retweet:self.tweetId completion:^(Tweet *tweet, NSError *error) {
        self.retweetId = tweet.tweetId;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tweet.tweetId forKey:self.tweetId];
    }];
}

- (void)untweet {
    self.retweeted = NO;
    self.retweetCount = [NSString stringWithFormat:@"%ld", [self.retweetCount integerValue] - 1];
    NSString *retweetId = self.retweetId;
    if (retweetId == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        retweetId = [defaults objectForKey:self.tweetId];
        NSLog(@"retweetId:%@", retweetId);
    }
    [[TwitterClient sharedInstance] untweet:retweetId origTweet:self];
}

- (void)favorite {
    self.favorited = YES;
    self.favoriteCount = [NSString stringWithFormat:@"%ld", [self.favoriteCount integerValue] + 1];
    [[TwitterClient sharedInstance] favorite:_tweetId];
}

- (void)unfavorite {
    self.favorited = NO;
    self.favoriteCount = [NSString stringWithFormat:@"%ld", [self.favoriteCount integerValue] - 1];
    [[TwitterClient sharedInstance] unfavorite:_tweetId];
}

+ (void)tweets:(NSString *)status inReplyToStatus:(NSString *)statusId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [[TwitterClient sharedInstance] tweets:status inReplyToStatus:statusId completion:completion];
}


+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary* dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (void)tweetsFromHomeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:completion];
}

@end
