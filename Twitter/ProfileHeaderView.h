//
//  ProfileHeaderView.h
//  Twitter
//
//  Created by Pythis Ting on 2/14/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *profileBannerView;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *screenNameLabel;

@end
