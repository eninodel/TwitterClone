//
//  DetailsViewController.h
//  twitter
//
//  Created by Edwin Delgado on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate <NSObject>

- (void) onDataChange;

@end

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
