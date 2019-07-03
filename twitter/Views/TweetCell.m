//
//  TweetCell.m
//  twitter
//
//  Created by kfullen on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapLike:(id)sender {
    // Update the local tweet model
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    
    // TODO: Update cell UI
    [self refreshData];
    // TODO: Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    
}

- (void)refreshData{
    if (self.tweet.favorited == YES) {
        UIImage *redLikeButton = [UIImage imageNamed:@"favor-icon-red.png"];
        [self.likesButton setImage:redLikeButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayLikeButton = [UIImage imageNamed:@"favor-icon.png"];
        [self.likesButton setImage:grayLikeButton forState:UIControlStateNormal];
    }
    NSString *likes = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likesButton setTitle:likes forState:UIControlStateNormal];
}

@end
