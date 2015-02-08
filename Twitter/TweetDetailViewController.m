//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
}

- (void)onRefresh {
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
    self.retweetLabel.text = _tweet.retweetCount;
    self.favoriteLabel.text = _tweet.favoriteCount;

}

- (IBAction)onReply:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.inReplyToStatusId = _tweet.tweetId;
    vc.inReplyToScreenName = _tweet.user.screenName;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    [_tweet retweet];
}

- (IBAction)onFavorite:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    [_tweet favorite];
}

@end
