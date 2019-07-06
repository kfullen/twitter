//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by kfullen on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UIButton *retweetsButton;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = self.tweet.user.screenName;
    self.tweetLabel.text = self.tweet.text;
    self.timestampLabel.text = self.tweet.createdAtString;
    
    NSString *profilePicString = self.tweet.user.profilePicURL;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    self.profilePicView.image = nil;
    [self.profilePicView setImageWithURL:profilePicURL];
    
    NSString *likes = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likesButton setTitle:likes forState:UIControlStateNormal];
    if(self.tweet.favorited == YES) {
        UIImage *redLikeButton = [UIImage imageNamed:@"favor-icon-red.png"];
        [self.likesButton setImage:redLikeButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayLikeButton = [UIImage imageNamed:@"favor-icon.png"];
        [self.likesButton setImage:grayLikeButton forState:UIControlStateNormal];
    }
    
    NSString *retweets = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetsButton setTitle:retweets forState:UIControlStateNormal];
    if(self.tweet.retweeted == YES) {
        UIImage *greenRetweetButton = [UIImage imageNamed:@"retweet-icon-green.png"];
        [self.retweetsButton setImage:greenRetweetButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayRetweetButton = [UIImage imageNamed:@"retweet-icon.png"];
        [self.retweetsButton setImage:grayRetweetButton forState:UIControlStateNormal];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
