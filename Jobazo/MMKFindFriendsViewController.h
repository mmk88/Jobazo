//
//  MMKFindFriendsViewController.h
//  Jobazo
//
//  Created by Munaf Kachwala on 1/17/15.
//  Copyright (c) 2015 Munaf M. Kachwala. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

@interface MMKFindFriendsViewController : FBFriendPickerViewController

@property (strong, nonatomic) IBOutlet UITextView *activityTextView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)clickInviteFriends:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
