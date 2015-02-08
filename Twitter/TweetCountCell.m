//
//  TweetCountCell.m
//  Twitter
//
//  Created by Pythis Ting on 2/7/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TweetCountCell.h"

@interface TweetCountCell()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;


@end

@implementation TweetCountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.retweetLabel.text = tweet.retweetCount;
    self.favoriteLabel.text = tweet.favoriteCount;
}

@end
