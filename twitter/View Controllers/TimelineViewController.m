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
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView; // View controller has table view as subview
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // View controller becomes data source and delegate of table view
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:refreshControl atIndex:0];
    
    [self fetchTweets];
    
}

- (void) fetchTweets {
    // Get timeline, make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            
            // View controller stores data passed into completion handler
            self.tweets = tweets;
            
            // Reload table view
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

// Table view asks for number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return self.tweets.count;
}

//Table view asks for cells for row at
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
    
    NSString *retweets = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [cell.retweetsButton setTitle:retweets forState:UIControlStateNormal];
    
    NSString *likes = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.likesButton setTitle:likes forState:UIControlStateNormal];
    
    NSString *replies = [NSString stringWithFormat:@"%d", tweet.replyCount];
    [cell.repliesButton setTitle:replies forState:UIControlStateNormal];
    
    
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

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    //Refetch tweets
    [self fetchTweets];
    
    //Maybe add reload but don't think so
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
    
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
