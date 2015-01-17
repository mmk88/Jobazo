//
//  MMKMatchViewController.h
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


//341

@protocol MMKMatchViewControllerDelegate <NSObject>

-(void)presentMatchesViewController;

@end

@interface MMKMatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage; //339

//341
@property (weak) id <MMKMatchViewControllerDelegate> delegate;

@end