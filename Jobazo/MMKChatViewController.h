//
//  MMKChatViewController.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/6/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "MMKMessageData.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface MMKChatViewController : JSMessagesViewController <JSMessagesViewDelegate,JSMessagesViewDataSource>

@property (strong, nonatomic) PFObject *chatRoom;


@end
