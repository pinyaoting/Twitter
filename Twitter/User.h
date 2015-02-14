//
//  User.h
//  Twitter
//
//  Created by Pythis Ting on 2/4/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBannerImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *followersCount;
@property (nonatomic, strong) NSString *friendsCount;
@property (nonatomic, strong) NSString *tweetsCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User*)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;
+ (void)userDetailsWithScreenName:(NSString *)screenName completion:(void (^)(User *user, NSError *error))completion;

@end
