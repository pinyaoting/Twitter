//
//  UserProfileViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/14/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileHeaderView.h"
#import "TweetCell.h"
#import "UserDetailsCell.h"
#import "Tweet.h"

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* tweets;
@property (nonatomic, strong) ProfileHeaderView *header;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGPoint initialPosition;

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHome)];
    
    
    // The onCustomPan: method will be defined in Step 3 below.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserDetailsCell" bundle:nil] forCellReuseIdentifier:@"UserDetailsCell"];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self initHeader];
    [self reloadData];
    [self updateUIAsync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.tweets != nil) {
            return self.tweets.count;
        } else {
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserDetailsCell"];
        cell.user = self.user;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else {
        TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        cell.tweet = self.tweets[indexPath.row];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (void) reloadData {
    [Tweet tweetsFromUserTimelineWithParams:@{@"screen_name": self.user.screenName} completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
}

- (void) initHeader {
    // profile banner
    self.header = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 215)];
    self.header.profileBannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 120)];
    [self.header addSubview:self.header.profileBannerView];
    
    // profile image
    self.header.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 80, 72, 72)];
    self.header.profileImageView.layer.borderWidth = 3;
    self.header.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.header.profileImageView.layer.cornerRadius = 5;
    [self.header.profileImageView setClipsToBounds:YES];
    [self.header addSubview:self.header.profileImageView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    __weak UserProfileViewController *vc = self;
    [self.header.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UserProfileViewController *strongRetainedViewController = vc;
        [UIView transitionWithView:strongRetainedViewController.header.profileImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ strongRetainedViewController.header.profileImageView.image = image;
        } completion:nil];
    } failure:nil];

    // followers, friends, tweets count
    UIFont *font= [UIFont systemFontOfSize:17];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect nameLabelRect = [self.user.name boundingRectWithSize:CGSizeMake(self.screenWidth - 30, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    self.header.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 160, nameLabelRect.size.width, nameLabelRect.size.height)];
    self.header.nameLabel.text = self.user.name;
    self.header.nameLabel.font = font;
    [self.header addSubview:self.header.nameLabel];
    
    font= [UIFont systemFontOfSize:11];
    attributes = @{NSFontAttributeName: font};
    CGRect screenNameLabelRect = [self.user.screenName boundingRectWithSize:CGSizeMake(self.screenWidth - 30, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    self.header.screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 162 + nameLabelRect.size.height, screenNameLabelRect.size.width, screenNameLabelRect.size.height)];
    self.header.screenNameLabel.text = self.user.screenName;
    self.header.screenNameLabel.textColor = [UIColor lightGrayColor];
    self.header.screenNameLabel.font = font;
    [self.header addSubview:self.header.screenNameLabel];
    
    // make this custom UIView the header of tableview
    self.tableView.tableHeaderView = self.header;
}

- (void) updateUIAsync {
    [User userDetailsWithScreenName:self.user.screenName completion:^(User *user, NSError *error) {
        self.user = user;
        __weak UserProfileViewController *vc = self;
    
        // update friends, follwers and status count
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        [self.tableView endUpdates];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileBannerImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
        [self.header.profileBannerView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            UserProfileViewController *strongRetainedViewController = vc;
            [UIView transitionWithView:strongRetainedViewController.header.profileBannerView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ strongRetainedViewController.header.profileBannerView.image = image;
            } completion:nil];
        } failure:nil];
        
        [self.tableView reloadData];
    }];
}

- (void)onHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGFloat deltaOfPosition = self.initialPosition.y - translation.y;
    CGFloat large = 72.0;
    CGFloat small = 48.0;
    CGFloat deltaOfScaleInScalar = large - small;
    CGFloat dowardScale = small / large;
    CGFloat targetScale = deltaOfPosition / deltaOfScaleInScalar;
    CGFloat scale = dowardScale * targetScale;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.initialPosition = [panGestureRecognizer locationInView:self.view];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (targetScale < 1) {
            self.header.profileImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

@end
