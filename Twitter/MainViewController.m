//
//  BurgerViewController.m
//  Twitter
//
//  Created by Pythis Ting on 2/11/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "UserProfileViewController.h"
#import "UserProfileCell.h"
#import "MenuCell.h"
#import "User.h"

int const HAMBURGERVIEW_RIGHT_OFFSET_MIN = 150;

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, TweetsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hamburgerViewRightOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hamburgerViewLeftOffset;
@property (weak, nonatomic) IBOutlet UITableView *hamburgerTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UINavigationController *profileViewController;
@property (nonatomic, strong) UINavigationController *timelineViewController;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) CGFloat initialConstant;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuItems = @[@{@"icon": @"home.png", @"name": @"Home Timeline"}, @{@"icon": @"mention.png", @"name": @"Mentions"}];
    
    [self.hamburgerTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.hamburgerTableView setLayoutMargins:UIEdgeInsetsZero];
    self.hamburgerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.hamburgerTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.hamburgerTableView.dataSource = self;
    self.hamburgerTableView.delegate = self;
    [self.hamburgerTableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellReuseIdentifier:@"UserProfileCell"];
    [self.hamburgerTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    
    // The onCustomPan: method will be defined in Step 3 below.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    tvc.delegate = self;
    self.timelineViewController = [[UINavigationController alloc] initWithRootViewController:tvc];
    self.timelineViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.timelineViewController.view];

    UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
    upvc.user = [User currentUser];
    self.profileViewController = [[UINavigationController alloc] initWithRootViewController:upvc];
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UserProfileCell *cell = [self.hamburgerTableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
        cell.user = [User currentUser];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else {
        MenuCell *cell = [self.hamburgerTableView dequeueReusableCellWithIdentifier:@"MenuCell"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self presentViewController:self.profileViewController animated:YES completion:nil];
        return;
    }
    
    TweetsViewController *vc = (TweetsViewController *)self.timelineViewController.childViewControllers[0];
    vc.timeline = indexPath.row - 1;
    [vc onRefresh];
    [self closeHamburgerView];
}

#pragma mark - TweetsViewControllerDelegate methods

- (void)presentViewController:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)openHamburgerView {
    self.hamburgerViewLeftOffset.constant = 0;
    self.hamburgerViewRightOffset.constant = HAMBURGERVIEW_RIGHT_OFFSET_MIN;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)closeHamburgerView {
    self.hamburgerViewLeftOffset.constant = -self.hamburgerTableView.frame.size.width;
    self.hamburgerViewRightOffset.constant = self.view.frame.size.width;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.initialConstant = self.hamburgerViewRightOffset.constant;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat newOffset = self.initialConstant - translation.x;
        if (newOffset > HAMBURGERVIEW_RIGHT_OFFSET_MIN) {
            self.hamburgerViewLeftOffset.constant = -newOffset;
            self.hamburgerViewRightOffset.constant = newOffset;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self openHamburgerView];
        } else if (velocity.x < 0) {
            [self closeHamburgerView];
        }
        
    }
}

@end
