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
#import "TweetCell.h"
#import "TweetDetailCell.h"
#import "TweetCountCell.h"
#import "TweetActionCell.h"

@interface TweetDetailViewController () <UITableViewDataSource, UITableViewDelegate, TweetActionCellDelegate, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* replies;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetDetailCell" bundle:nil] forCellReuseIdentifier:@"TweetDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCountCell" bundle:nil] forCellReuseIdentifier:@"TweetCountCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetActionCell" bundle:nil] forCellReuseIdentifier:@"TweetActionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.replies = [NSMutableArray array];
    self.title = @"Tweet";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHome)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + self.replies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TweetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetDetailCell"];
        cell.tweet = self.tweet;
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else if (indexPath.row == 1) {
        TweetCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCountCell"];
        cell.tweet = self.tweet;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else if (indexPath.row == 2) {
        TweetActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetActionCell"];
        cell.tweet = self.tweet;

        cell.delegate = self;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        cell.tweet = self.replies[indexPath.row - 3];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action delegate methods

- (void)replyToStatus:(NSString *)statusId fromAuthor:(NSString *)screenName {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.inReplyToStatusId = statusId;
    vc.inReplyToScreenName = screenName;
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRetweet {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    // refresh TweetCountCell to reflect updated retweet count
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    [self.tableView endUpdates];
}

- (void)onFavorite {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];

    TweetCountCell *cell = (TweetCountCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"favorited:%s", cell.tweet.favorited?"YES":"NO");
    // refresh TweetCountCell to reflect updated favorite count
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    [self.tableView endUpdates];

}

#pragma mark - Compose delegate methods

- (void)reloadTweetInView:(Tweet *)tweet {
    [self.replies insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)onHome {
    [self.delegate reloadTweetsInView:self.replies];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
