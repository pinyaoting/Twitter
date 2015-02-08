//
//  Tweet.m
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.tweetId = dictionary[@"id_str"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.retweetCount = [NSString stringWithFormat:@"%@",dictionary[@"retweet_count"]];
        self.favoriteCount = [NSString stringWithFormat:@"%@",dictionary[@"favorite_count"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";

        self.createdAt = [formatter dateFromString:createdAtString];
    }
    
    return self;
}

- (void)retweet {
    [[TwitterClient sharedInstance] retweet:_tweetId];
}

- (void)favorite {
    [[TwitterClient sharedInstance] favorite:_tweetId];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary* dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (void)tweetsFromHomeTimelineWithParams:(NSArray *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:completion];
}

@end
