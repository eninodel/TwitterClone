//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Edwin Delgado on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "../Models/Tweet.h"
#import "../API/APIManager.h"
#import "DateTools.h"

@interface TweetTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfShares;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UILabel *screenNameAndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
- (IBAction)favoriteAction:(id)sender;
- (IBAction)retweetAction:(id)sender;

@end


@implementation TweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initializeCell {
    
    [self.shareButton setTitle:@"" forState: UIControlStateNormal];
    [self.retweetButton setTitle: @"" forState: UIControlStateNormal];
    [self.likeButton setTitle:@"" forState: UIControlStateNormal];
    [self.messageButton setTitle:@"" forState: UIControlStateNormal];
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData: urlData];
    [self.userImage setImage:image];
    NSString *nameAndDateLabelString = @" . ";
    nameAndDateLabelString = [nameAndDateLabelString stringByAppendingString: self.tweet.createdAtString];
    self.screenNameAndDateLabel.text = [self.tweet.user.screenName stringByAppendingString: nameAndDateLabelString];
    [self setTweet];
}

- (IBAction)retweetAction:(id)sender {
    if(self.tweet.retweeted){
        self.tweet.retweetCount -= 1;
        self.tweet.retweeted = false;
    } else{
        self.tweet.retweetCount += 1;
        self.tweet.retweeted = true;
    }

    [self setTweet];
    [[APIManager shared] retweet:self.tweet completion: ^(Tweet *tweet, NSError *error){
        if(error){
            NSLog(@"error retweeting tweet");
        } else{
            NSLog(@"success in retweeting tweet!");
        }

    }];
}

- (IBAction)favoriteAction:(id)sender {
    if(self.tweet.favorited){
        self.tweet.favorited = false;
        self.tweet.favoriteCount -= 1;
    } else{
        self.tweet.favoriteCount += 1;
        self.tweet.favorited = true;
    }

    [self setTweet];
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error){
        if(error){
            NSLog(@"error favoriting tweet");
        } else{
            NSLog(@"success in favoriting tweet!");
        }

    }];
}

- (void) setTweet {
    if(self.tweet.favorited){
        UIImage *redFavorIcon = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:redFavorIcon forState:UIControlStateNormal];
    } else{
        UIImage *greyFavorIcon = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:greyFavorIcon forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted){
        UIImage *greenRetweetIcon =[UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:greenRetweetIcon forState: UIControlStateNormal];
    } else{
        UIImage *greyRetweetIcon = [UIImage imageNamed:@"retweet-icon"];
        [self.retweetButton setImage:greyRetweetIcon forState: UIControlStateNormal];
    }
    self.tweetBodyLabel.text = self.tweet.text;
    self.userName.text = self.tweet.user.name;
    self.numberOfShares.text = @"0";
    self.numberOfRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount? self.tweet.retweetCount: 0];
    self.numberOfLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount? self.tweet.favoriteCount : 0];
}
@end
