//
//  ComposeViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic, assign) BOOL startedTyping;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    
    // init text view
    self.tweetTextView.delegate = self;
    self.startedTyping = NO;
    if (self.inReplyToScreenName != nil) {
        self.tweetTextView.textColor = [UIColor blackColor];
        self.tweetTextView.text = [self.inReplyToScreenName stringByAppendingString:@" "];
        self.startedTyping = YES;
    } else {
        self.tweetTextView.selectedRange = NSMakeRange(0, 0);
    }
    [self.tweetTextView becomeFirstResponder];
    
    // init navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.startedTyping == NO) {
        self.startedTyping = YES;
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
        self.startedTyping = YES;
        return YES;
    }
    
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = textView.text.length + text.length - range.length;
    return (newLength > 255) ? NO : YES;
}

- (void)setUser:(User *)user {
    _user = user;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: _user.profileImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.profileImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.profileImageView.image = image;
        } completion:nil];
    } failure:nil];
    
    self.nameLabel.text = _user.name;
    self.screenNameLabel.text = _user.screenName;
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    [Tweet tweets:self.tweetTextView.text inReplyToStatus:self.inReplyToStatusId completion:^(Tweet *tweet, NSError *error) {
        [self.delegate reloadTweetInView:tweet];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end