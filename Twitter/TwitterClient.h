//
//  TwitterClient.h
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

@end
