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

@end
