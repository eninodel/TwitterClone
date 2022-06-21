//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Edwin Delgado on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "../Models/Tweet.h"
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
    self.userName.text = self.tweet.user.name;
    self.numberOfShares.text = @"0";
    self.numberOfRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount? self.tweet.retweetCount: 0];
    self.numberOfLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount? self.tweet.favoriteCount : 0];
    NSString *nameAndDateLabelString = @" . ";
    nameAndDateLabelString = [nameAndDateLabelString stringByAppendingString:self.tweet.createdAtString];
    self.screenNameAndDateLabel.text = [self.tweet.user.screenName stringByAppendingString: nameAndDateLabelString];
    self.tweetBodyLabel.text = self.tweet.text;
}

@end
