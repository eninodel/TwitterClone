//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "../Views/TweetTableViewCell.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>
- (IBAction)didTapLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action: @selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:self.refreshControl atIndex:0];
    // Get timeline
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   UINavigationController *navigationController = [segue destinationViewController];
   ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
   composeController.delegate = self;
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet =  (Tweet *)self.arrayOfTweets[indexPath.row];
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.tweet = tweet;
    [cell initializeCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

-(void) fetchData{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = (NSMutableArray*) tweets;
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
            [self.timelineTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}


- (void)didTweet:(nonnull Tweet *)tweet {
    NSMutableArray *tweetsList = [[NSMutableArray alloc] init];
    [tweetsList addObject:tweet];
    for(int i = 0; i < self.arrayOfTweets.count; i++){
        [tweetsList addObject:self.arrayOfTweets[i]];
    }
    self.arrayOfTweets = [tweetsList copy];
    [self.timelineTableView reloadData];
}



@end
