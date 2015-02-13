//
//  BurgerViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/11/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "BurgerViewController.h"
#import "TweetsViewController.h"
#import "UserProfileCell.h"
#import "MenuCell.h"
#import "User.h"

@interface BurgerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *burgerView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) CGPoint initialPoint;

@end

@implementation BurgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuItems = @[@{@"icon": @"home.png", @"name": @"Home Timeline"}, @{@"icon": @"mention.png", @"name": @"Mentions"}];
    
    [self.burgerView setSeparatorInset:UIEdgeInsetsZero];
    [self.burgerView setLayoutMargins:UIEdgeInsetsZero];
    self.burgerView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.burgerView.rowHeight = UITableViewAutomaticDimension;
    
    self.burgerView.dataSource = self;
    self.burgerView.delegate = self;
    [self.burgerView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellReuseIdentifier:@"UserProfileCell"];
    [self.burgerView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    
    // The onCustomPan: method will be defined in Step 3 below.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    tvc.view.frame = self.view.frame;

//    UINavigationController *ntvc = [self.navigationController initWithRootViewController:tvc];
//    [self addChildViewController:ntvc];
//    [self.view addSubview:ntvc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UserProfileCell *cell = [self.burgerView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
        cell.user = [User currentUser];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else {
        MenuCell *cell = [self.burgerView dequeueReusableCellWithIdentifier:@"MenuCell"];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        NSDictionary *menuItem = self.menuItems[indexPath.row - 1];
        [cell.iconImageView setImage:[UIImage imageNamed:menuItem[@"icon"]]];
        cell.menuLabel.text = menuItem[@"name"];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
//    vc.tweet = self.tweets[indexPath.row];
//    vc.delegate = self;
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.tweets.count - 1) {
//        // make a call
//        if (self.isInBuffer) {
//            return;
//        }
//        self.isInBuffer = YES;
//        [self moreTweets];
//    }
//}

- (IBAction)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.initialPoint = self.burgerView.center;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"deltaX:%f", translation.x);
        self.burgerView.center = CGPointMake(self.initialPoint.x + translation.x, self.burgerView.center.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
                self.burgerView.center = CGPointMake(155, self.burgerView.center.y);
            } completion:nil];
        } else if (velocity.x < 0) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
                self.burgerView.center = CGPointMake(-158, self.burgerView.center.y);
            } completion:nil];
        }
        
    }
}

@end
