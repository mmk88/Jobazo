//
//  MMKTestUser.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKTestUser.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h> 


@implementation MMKTestUser


//ALL DONE IN 326 xxxxxxxxxxxxxxxxxxx//


+ (void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Julia", @"gender" : @"female",  @"location" :
                                          @"berlin, Germany", @"name" : @"Julie Adams"};
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                {
                    UIImage *profileImage = [UIImage
                                             imageNamed:@"1.jpeg"];
                    NSLog(@"%@", profileImage);
                    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                    
                    PFFile *photoFile = [PFFile fileWithData:imageData];
                    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            PFObject *photo = [PFObject objectWithClassName:kMMKPhotoClassKey];
                            [photo setObject:newUser forKey:kMMKPhotoUserKey];
                            [photo setObject:photoFile forKey:kMMKPhotoPictureKey];
                            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                NSLog(@"photo saved successfully1");
                            }];
                            
                        }
                    }];
                }
            }];
        }
    }];
    
}


@end
