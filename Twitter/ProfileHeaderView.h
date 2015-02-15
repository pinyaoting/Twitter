//
//  ProfileHeaderView.h
//  Twitter
//
//  Created by Pythis Ting on 2/14/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *profileBannerView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;

@end
