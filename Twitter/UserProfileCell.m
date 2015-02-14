//
//  UserProfileCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/11/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end

@implementation UserProfileCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.profileImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.profileImageView.image = image;
        } completion:nil];
    } failure:nil];
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;
}

@end
