//
//  UserDetailsCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/15/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "UserDetailsCell.h"

@interface UserDetailsCell()

@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;

@end

@implementation UserDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    self.friendsCountLabel.text = self.user.friendsCount;
    self.followersCountLabel.text = self.user.followersCount;
    self.tweetsCountLabel.text = self.user.tweetsCount;
}

@end
