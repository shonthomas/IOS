//
//  ComposeViewController.h
//  Twitter
//
//  Created by Shon Thomas on 9/20/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@optional
- (void)didTweetSuccessfully;

@end

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic, strong) Tweet *replyToTweet;
@property (nonatomic, strong) User *messageToUser;

@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;

@end
