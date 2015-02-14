//
//  TwitterClient.m
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"R5RO1q6I6fJOVsnx4NvDju1iS";
NSString * const kTwitterConsumerSecret = @"98SpU91kQUTbk8dczzPNKa1FsoMTOYYD1S5MlxIQXn44tOBfVv";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token!");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {

        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];

            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token!");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)tweets:(NSString *)status inReplyToStatus:(NSString *)statusId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:status forKey:@"status"];
    if (statusId != nil) {
        [params setObject:statusId forKey:@"in_reply_to_status_id"];
    }
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:nil];
}

- (void)retweet:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:[@"1.1/statuses/retweet/" stringByAppendingString:[tweetId stringByAppendingString:@".json"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:nil];
}

- (void)untweet:(NSString *)tweetId origTweet:(Tweet *)origTweet {
    // un-retweeting in same session which the tweet got re-tweeted, so re-tweetId is availible for un-retweet.
    if (tweetId != nil) {
        [self POST:[@"1.1/statuses/destroy/" stringByAppendingString:[tweetId stringByAppendingString:@".json"]] parameters:nil success:nil failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self unretweetByLookup:origTweet];
        }];
        return;
    } else {
        [self unretweetByLookup:origTweet];
    }
}

- (void)unretweetByLookup:(Tweet *)origTweet {
    // try finding the re-tweeted tweet from user timeline
    [self GET:@"1.1/statuses/user_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        for (Tweet *tweet in tweets) {
            if ([tweet.text isEqualToString:origTweet.text]) {
                [self POST:[@"1.1/statuses/destroy/" stringByAppendingString:[tweet.tweetId stringByAppendingString:@".json"]] parameters:nil success:nil failure:nil];
            }
        }
    } failure:nil];
}

- (void)favorite:(NSString *)tweetId {
    NSDictionary *params = [NSDictionary dictionaryWithObject:tweetId forKey:@"id"];
    [self POST:@"1.1/favorites/create.json" parameters:params success:nil failure:nil];
}

- (void)unfavorite:(NSString *)tweetId {
    NSDictionary *params = [NSDictionary dictionaryWithObject:tweetId forKey:@"id"];
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:nil failure:nil];
}

@end
