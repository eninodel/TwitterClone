//
//  TweetTableViewCell.h
//  twitter
//
//  Created by Edwin Delgado on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetTableViewCell : UITableViewCell
@property (strong, nonatomic)  Tweet *tweet;
- (void) initializeCell;
@end

NS_ASSUME_NONNULL_END
