//
//  TweetsViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"
#import "UserProfileViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "SVProgressHUD.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetDetailViewControllerDelegate, TweetCellDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, assign) BOOL isInBuffer;
@property (nonatomic, strong) NSArray *twitterTimelineTitles;
@property (copy) void (^reloadData)(NSArray *tweets, NSError *error);
@property (copy) void (^appendData)(NSArray *tweets, NSError *error);

@end

@implementation TweetsViewController

typedef enum {
    TWITTER_HOME_TIMELINE,
    TWITTER_MENTION_TIMELINE
} TWITTER_TIMELINE;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading"];

    self.twitterTimelineTitles = @[@"Home", @"Mentions"];
    
    if (!self.timeline) {
        self.timeline = TWITTER_HOME_TIMELINE;
    }
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    self.title = self.twitterTimelineTitles[self.timeline];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.isInBuffer = YES;
    
    self.tweets = [NSMutableArray arrayWithCapacity:200];
    
    [self initCallback];
    [self onRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 19) {
        return;
    }
    if (indexPath.row == self.tweets.count - 1) {
        // make a call
        if (self.isInBuffer) {
            return;
        }
        self.isInBuffer = YES;
        [self moreTweets];
    }
}

#pragma mark - Tweet delegate methods

- (void)replyToStatus:(NSString *)statusId fromAuthor:(NSString *)screenName {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.inReplyToStatusId = statusId;
    vc.inReplyToScreenName = screenName;
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)tapOnProfileImageOfScreenName:(User *)user {
    UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
    upvc.user = user;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:upvc];
    [self presentViewController:nvc animated:YES completion:nil];    
}

#pragma mark - Compose delegate methods

- (void)reloadTweetInView:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Detail delegate methods

- (void)reloadTweetsInView:(NSArray *)tweets {
    [self.tweets insertObjects:tweets atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tweets.count)]];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)initCallback {
    __weak TweetsViewController *tvc = self;
    
    self.reloadData = ^(NSArray *tweets, NSError *error) {
        if (error) {
            return;
        }
        TweetsViewController *strongRetainedViewController = tvc;
        strongRetainedViewController.isInBuffer = NO;
        [SVProgressHUD dismiss];
        [strongRetainedViewController.refreshControl endRefreshing];
        strongRetainedViewController.tweets = [NSMutableArray arrayWithArray:tweets];
        strongRetainedViewController.title = strongRetainedViewController.twitterTimelineTitles[strongRetainedViewController.timeline];
        [strongRetainedViewController.tableView reloadData];
    };
    
    self.appendData = ^(NSArray *tweets, NSError *error) {
        if (error) {
            return;
        }
        TweetsViewController *strongRetainedViewController = tvc;
        strongRetainedViewController.isInBuffer = NO;
        [SVProgressHUD dismiss];
        [strongRetainedViewController.tweets addObjectsFromArray:tweets];
        strongRetainedViewController.title = strongRetainedViewController.twitterTimelineTitles[strongRetainedViewController.timeline];
        [strongRetainedViewController.tableView reloadData];
    };
}

- (void)onCompose {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onLogout {
    [User logout];
}

- (void)refreshWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    switch (self.timeline) {
        case TWITTER_MENTION_TIMELINE:
            [Tweet tweetsFromMentionsTimelineWithParams:nil completion:completion];
            break;
        default:
            [Tweet tweetsFromHomeTimelineWithParams:nil completion:completion];
            break;
    }
}

- (void)onRefresh {
    [self refreshWithParams:nil completion:self.reloadData];
}

- (void)moreTweets {
    [SVProgressHUD showWithStatus:@"Loading"];
    NSInteger size = self.tweets.count - 1;
    Tweet *lastTweet = self.tweets[size];
    [self refreshWithParams:@{@"max_id": lastTweet.tweetId} completion:self.appendData];
}

@end