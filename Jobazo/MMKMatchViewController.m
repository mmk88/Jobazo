//
//  MMKMatchViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKMatchViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MMKMatchViewController ()

//334


@property (strong, nonatomic) IBOutlet UIButton *viewChatButton;

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;

@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;


@end

@implementation MMKMatchViewController


//dont know saw this in 340 ?

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        //custom initialization
        
    }
    return self;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //340
    
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMMKPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.currentUserImageView.image = [UIImage imageWithData:data];
                self.matchedUserImageView.image = self.matchedUserImage;
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -IBActions

//334

- (IBAction)viewChatsButtonPressed:(UIButton *)sender {
    
     //[self.delegate presentMatchesViewController];
    
    [self performSegueWithIdentifier:@"CongratulationsToMatchesForBusinessUserSeeingNewEmployeesSegue" sender:nil];
}

- (IBAction)keepSearchingButtonPressed:(UIButton *)sender {

    //340
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end


