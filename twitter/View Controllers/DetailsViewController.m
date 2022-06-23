//
//  DetailsViewController.m
//  twitter
//
//  Created by Edwin Delgado on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenNameAndDate;
@property (weak, nonatomic) IBOutlet UITextView *tweetBody;
@property (weak, nonatomic) IBOutlet UILabel *numberOfShares;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFavorites;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)didFavorite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
- (IBAction)didRetweet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
- (IBAction)didPressBack:(id)sender;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.shareButton setTitle:@"" forState: UIControlStateNormal];
    [self.retweetButton setTitle: @"" forState: UIControlStateNormal];
    [self.favoriteButton setTitle:@"" forState: UIControlStateNormal];
    [self.messageButton setTitle:@"" forState: UIControlStateNormal];
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData: urlData];
    [self.userImage setImage:image];
    self.userImage.layer.cornerRadius = 25.0;
    self.userImage.layer.masksToBounds = true;
    NSString *nameAndDateLabelString = @" . ";
    nameAndDateLabelString = [nameAndDateLabelString stringByAppendingString: self.tweet.createdAtString];
    self.screenNameAndDate.text = [self.tweet.user.screenName stringByAppendingString: nameAndDateLabelString];
    [self setTweet];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)didFavorite:(id)sender {
    if(self.tweet.favorited){
        self.tweet.favorited = false;
        self.tweet.favoriteCount -= 1;
    } else{
        self.tweet.favoriteCount += 1;
        self.tweet.favorited = true;
    }

//    [self setTweet];
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error){
        if(error){
            NSLog(@"error favoriting tweet");
            NSLog(error.description);
        } else{
            [self setTweet];
            [self.delegate onDataChange];
            NSLog(@"success in favoriting tweet!");
        }

    }];

}
- (IBAction)didRetweet:(id)sender {
    if(self.tweet.retweeted){
        self.tweet.retweetCount -= 1;
        self.tweet.retweeted = false;
    } else{
        self.tweet.retweetCount += 1;
        self.tweet.retweeted = true;
    }

//    [self setTweet];
    [[APIManager shared] retweet:self.tweet completion: ^(Tweet *tweet, NSError *error){
        if(error){
            NSLog(@"error retweeting tweet");
        } else{
            [self setTweet];
            [self.delegate onDataChange];
            NSLog(@"success in retweeting tweet!");
        }

    }];
}

- (void) setTweet {
    if(self.tweet.favorited){
        UIImage *redFavorIcon = [UIImage imageNamed:@"favor-icon-red"];
        [self.favoriteButton setImage:redFavorIcon forState:UIControlStateNormal];
    } else{
        UIImage *greyFavorIcon = [UIImage imageNamed:@"favor-icon"];
        [self.favoriteButton setImage:greyFavorIcon forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted){
        UIImage *greenRetweetIcon =[UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:greenRetweetIcon forState: UIControlStateNormal];
    } else{
        UIImage *greyRetweetIcon = [UIImage imageNamed:@"retweet-icon"];
        [self.retweetButton setImage:greyRetweetIcon forState: UIControlStateNormal];
    }
    self.tweetBody.text = self.tweet.text;
    self.userName.text = self.tweet.user.name;
    self.numberOfShares.text = @"0";
    self.numberOfRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount? self.tweet.retweetCount: 0];
    self.numberOfFavorites.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount? self.tweet.favoriteCount : 0];
}

@end
