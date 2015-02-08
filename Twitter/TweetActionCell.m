//
//  TweetActionCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetActionCell.h"
#import "ComposeViewController.h"

@interface TweetActionCell()
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetActionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self.tweetButton setSelected:self.tweet.retweeted];
    [self.favoriteButton setSelected:self.tweet.favorited];
}

- (IBAction)onReply:(id)sender {
    [self.delegate replyToStatus:self.tweet.tweetId fromAuthor:self.tweet.user.screenName];
}

- (IBAction)onRetweet:(id)sender {
    BOOL selected = ![sender isSelected];
    [sender setSelected:selected];
    if (selected) {
        [self.tweet retweet];
    } else {
        [self.tweet untweet];
    }
    [self.delegate onRetweet];
}

- (IBAction)onFavorite:(id)sender {
    BOOL selected = ![sender isSelected];
    [sender setSelected:selected];
    if (selected) {
        [self.tweet favorite];
    } else {
        [self.tweet unfavorite];
    }
    [self.delegate onFavorite];
}

@end
