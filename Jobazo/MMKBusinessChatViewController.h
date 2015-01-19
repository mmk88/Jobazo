//
//  MMKBusinessChatViewController.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "MMKBusinessMessageData.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Mixpanel.h>
#define MIXPANEL_TOKEN @"4c051590a5a3568ec9227f64a282d274"

@interface MMKBusinessChatViewController : JSMessagesViewController <JSMessagesViewDelegate,JSMessagesViewDataSource>

@property (strong, nonatomic) PFObject *chatRoom;


@end
