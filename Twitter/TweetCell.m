//
//  TweetCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
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
    self.createdAtLabel.text = [tweet.createdAt shortTimeAgoSinceNow];
    self.contentLabel.text = _tweet.text;
}

@end
