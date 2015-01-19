//
//  MMKTestUser.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h> 
#import <Mixpanel.h>
#define MIXPANEL_TOKEN @"4c051590a5a3568ec9227f64a282d274"

@interface MMKTestUser : NSObject

+ (void)saveTestUserToParse;


@end
