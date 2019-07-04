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
    
    // Update cell UI
    [self refreshLikes];
    
    // Send a POST request to the POST favorites/create endpoint
    if (self.tweet.favorited == NO) {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    
    // Update the local tweet model
    if (self.tweet.retweeted == NO) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }
    
    // Update cell UI
    [self refreshRetweets];
    
    // Send a POST request to the POST favorites/create endpoint
    if (self.tweet.retweeted == NO) {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)refreshLikes{
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

- (void)refreshRetweets{
    if (self.tweet.retweeted == YES) {
        UIImage *greenRetweetButton = [UIImage imageNamed:@"retweet-icon-green.png"];
        [self.retweetsButton setImage:greenRetweetButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayRetweetButton = [UIImage imageNamed:@"retweet-icon.png"];
        [self.retweetsButton setImage:grayRetweetButton forState:UIControlStateNormal];
    }
    
    NSString *retweets = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetsButton setTitle:retweets forState:UIControlStateNormal];
}

@end
