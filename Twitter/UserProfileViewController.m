//
//  UserProfileViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/14/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImageView.layer.borderWidth = 3;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = 5;
    [self.profileImageView setClipsToBounds:YES];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateUI {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileBannerImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.profileBannerImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.profileBannerImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.profileBannerImageView.image = image;
        } completion:nil];
    } failure:nil];

    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.profileImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.profileImageView.image = image;
        } completion:nil];
    } failure:nil];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenName;
    self.friendsCountLabel.text = self.user.friendsCount;
    self.followersCountLabel.text = self.user.followersCount;
    self.tweetsCountLabel.text = self.user.tweetsCount;
}

@end
