//
//  TweetDetailCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end

@implementation TweetDetailCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_tweet.user.profileImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.profileImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.profileImageView.image = image;
        } completion:nil];
    } failure:nil];
    
    self.nameLabel.text = _tweet.user.name;
    self.screenNameLabel.text = _tweet.user.screenName;
    self.createdAtLabel.text = [_tweet.createdAt timeAgoSinceNow];
    self.contentLabel.text = _tweet.text;
    [self.contentLabel setPreferredMaxLayoutWidth:self.contentLabel.frame.size.width];
    
    // create tap gesture recognizer in profile image view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
    self.profileImageView.userInteractionEnabled = YES;
}

- (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.delegate tapOnProfileImageOfScreenName:self.tweet.user];
}

@end
