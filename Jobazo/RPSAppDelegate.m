//
//  RPSAppDelegate.m
//  Jobazo
//
//  Created by Munaf Kachwala on 1/17/15.
//  Copyright (c) 2015 Munaf M. Kachwala. All rights reserved.
//

#import "RPSAppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>

#import <Bolts/Bolts.h>

#import "MMKFindFriendsViewController.h"

@implementation RPSAppDelegate

#pragma mark - Class methods

/*
+ (RPSCall)callFromAppLinkURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    BFURL *appLinkURL = [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
    NSURL *appLinkTargetURL = [appLinkURL targetURL];
    if (!appLinkTargetURL) {
        return RPSCallNone;
    }
    NSString *queryString = [appLinkTargetURL query];
    for(NSString *component in [queryString componentsSeparatedByString:@"&"]) {
        NSArray *pair = [component componentsSeparatedByString:@"="];
        NSString *param = pair[0];
        NSString *val = pair[1];
        if ([param isEqualToString:@"gesture"]) {
            if ([val isEqualToString:@"rock"]) {
                return RPSCallRock;
            } else if ([val isEqualToString:@"paper"]) {
                return RPSCallPaper;
            } else if ([val isEqualToString:@"scissors"]) {
                return RPSCallScissors;
            }
        }
    }
    
    return RPSCallNone;
}
 */

#pragma mark - UIApplicationDelegate

/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        // Check for an app link to parse out a call to show
                        RPSCall appLinkCall = [RPSAppDelegate callFromAppLinkURL:url sourceApplication:sourceApplication];
                        if (appLinkCall != RPSCallNone) {
                            RPSDeeplyLinkedViewController *vc = [[RPSDeeplyLinkedViewController alloc] initWithCall:appLinkCall];
                            [self.navigationController presentViewController:vc animated:YES completion:nil];
                        }
                    }];
}

*/

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // all good things must come to an end
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIViewController *viewControllerGame;
    
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewControllerGame = [[RPSGameViewController alloc] initWithNibName:@"RPSGameViewController_iPhone" bundle:nil];
    } else {
        viewControllerGame = [[RPSGameViewController alloc] initWithNibName:@"RPSGameViewController_iPad" bundle:nil];
    }
     */
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerGame];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [FBSession openActiveSessionWithAllowLoginUI:NO];
    
    return YES;
}

@end
