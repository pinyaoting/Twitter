//
//  ComposeViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

NSInteger const MAX_CHARACTEERS = 255;

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, assign) NSInteger charactersLeft;
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
    self.charactersLeft = MAX_CHARACTEERS;
    self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld", self.charactersLeft];
    self.countdownLabel.font = [UIFont systemFontOfSize:13];
    self.countdownLabel.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *wordCountWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.countdownLabel];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];

    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItems = @[tweetButton, wordCountWrapper];
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
    if (MAX_CHARACTEERS < newLength) {
        return NO;
    }
    self.charactersLeft = MAX_CHARACTEERS - newLength;
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld", self.charactersLeft];
    if (self.charactersLeft == 0) {
        self.countdownLabel.textColor = [UIColor redColor];
    }
    return YES;
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