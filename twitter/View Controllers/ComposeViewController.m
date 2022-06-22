//
//  ComposeViewController.m
//  twitter
//
//  Created by Edwin Delgado on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "../API/APIManager.h"
#import "../Models/Tweet.h"


@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
- (IBAction)exitAction:(id)sender;
- (IBAction)tweetAction:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.borderColor = UIColor.blackColor.CGColor;
    self.inputTextView.layer.cornerRadius = 10;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tweetAction:(id)sender {
    
    
    [[APIManager shared] postStatusWithText:self.inputTextView.text completion: ^(Tweet *tweet, NSError *error){
        if(tweet){
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }else{
            NSLog(@"error in posting a tweet");
            NSLog(error.description);
        }
    }];
}

- (IBAction)exitAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
