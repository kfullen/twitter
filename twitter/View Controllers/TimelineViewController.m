//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    [self fetchTweets];
    
}

- (void) fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.tweets = tweets;
            [self.tweetTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    User *user = tweet.user;
    
    cell.tweetLabel.text = tweet.text;
    //NSLog(@"tweet text: %@", tweet.text);
    cell.userLabel.text = tweet.user.name;
    //NSLog(@"tweet user: %@", tweet.user.name);
    cell.handleLabel.text = user.screenName;
    cell.createdAtLabel.text = tweet.createdAtString;
    
    NSString *retweets = [NSString stringWithFormat:@"rts: %d", tweet.retweetCount];
    [cell.retweetsButton setTitle:retweets forState:UIControlStateNormal];
    
    NSString *likes = [NSString stringWithFormat:@"likes: %d", tweet.favoriteCount];
    [cell.likesButton setTitle:likes forState:UIControlStateNormal];
    
    
    NSString *profilePicString = tweet.user.profilePicURL;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    cell.profileImageView.image = nil;
    [cell.profileImageView setImageWithURL:profilePicURL];
    
    //self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
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
