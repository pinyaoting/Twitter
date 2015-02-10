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
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "SVProgressHUD.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetDetailViewControllerDelegate, TweetCellDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* tweets;

@property (nonatomic, assign) BOOL isInBuffer;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.isInBuffer = YES;
    
    [self onRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

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

- (void)onCompose {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onLogout {
    [User logout];
}

- (void)onRefresh {
    [Tweet tweetsFromHomeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.isInBuffer = NO;
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)moreTweets {
    [SVProgressHUD showWithStatus:@"Loading"];
    NSInteger size = self.tweets.count - 1;
    Tweet *lastTweet = self.tweets[size];
    [Tweet tweetsFromHomeTimelineWithParams:@{@"max_id": lastTweet.tweetId} completion:^(NSArray *tweets, NSError *error) {
        self.isInBuffer = NO;
        [SVProgressHUD dismiss];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
}

@end