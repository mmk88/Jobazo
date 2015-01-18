//
//  RPSAppDelegate.h
//  Jobazo
//
//  Created by Munaf Kachwala on 1/17/15.
//  Copyright (c) 2015 Munaf M. Kachwala. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

// Boolean OG (Rock the Logic!) sample application
//
// The purpose of this sample application is to provide an example of
// how to publish and read Open Graph actions with Facebook. The goal
// of the sample is to show how to use FBRequest, FBRequestConnection,
// and FBSession classes, as well as the FBOpenGraphAction protocol and
// related types in order to create a social app using Open Graph

@interface RPSAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
