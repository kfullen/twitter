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
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DateTools.h"
#import "TweetDetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *tweets;
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
            // View controller stores data passed into completion handler
            self.tweets = (NSMutableArray*) tweets;
            
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
    cell.tweet = tweet;
    
    cell.tweetLabel.text = tweet.text;
    cell.userLabel.text = tweet.user.name;
    cell.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];    
    cell.createdAtLabel.text = tweet.ago; //now timestamp instead of created at date
    
    
    NSString *retweets = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [cell.retweetsButton setTitle:retweets forState:UIControlStateNormal];
    if(cell.tweet.retweeted == YES) {
        UIImage *greenRetweetButton = [UIImage imageNamed:@"retweet-icon-green.png"];
        [cell.retweetsButton setImage:greenRetweetButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayRetweetButton = [UIImage imageNamed:@"retweet-icon.png"];
        [cell.retweetsButton setImage:grayRetweetButton forState:UIControlStateNormal];
    }
    
    
    NSString *likes = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.likesButton setTitle:likes forState:UIControlStateNormal];
    if(cell.tweet.favorited == YES) {
        UIImage *redLikeButton = [UIImage imageNamed:@"favor-icon-red.png"];
        [cell.likesButton setImage:redLikeButton forState:UIControlStateNormal];
    }
    else {
        UIImage *grayLikeButton = [UIImage imageNamed:@"favor-icon.png"];
        [cell.likesButton setImage:grayLikeButton forState:UIControlStateNormal];
    }
    
    NSString *profilePicString = tweet.user.profilePicURL;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    cell.profileImageView.image = nil;
    [cell.profileImageView setImageWithURL:profilePicURL];
    
    //self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    //Refetch tweets
    [self fetchTweets];
    
    //Maybe add reload but don't think so
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
    
}

-(void)didTweet:(Tweet *)tweet {
    [self.tweets addObject:tweet];
    //do you need to fetch tweets again???????????
    [self.tweetTableView reloadData];
}

- (IBAction)tapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"tweetSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else {
        UINavigationController *navigationController = [segue destinationViewController];
        TweetDetailsViewController *detailsViewController = (TweetDetailsViewController*)navigationController.topViewController;
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        detailsViewController.tweet = tweet;
       
    }
}



@end
