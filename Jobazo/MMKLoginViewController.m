//
//  MMKLoginViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKLoginViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MMKLoginViewController ()


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation MMKLoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Number A");
    self.activityIndicator.hidden =YES;
    
}




-(void)viewDidAppear:(BOOL)animated
{
   
    //CODE BELOW, LETS USER AUTOLOGIN IF THEY HAVE BEEN LOGGED IN PREVIOUSLY, DISABLING FOR REASONS
    
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        NSLog(@"Number B");
        [self updateUserInformation];
        NSLog(@"Number C");
        [self performSegueWithIdentifier:@"loginToEmployeeEditProfileSegue" sender:self];
         //[self performSegueWithIdentifier:@"loginToHomeSegue" sender:self]; <--Previously

    }
     
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -IBActions



- (IBAction)loginButtonPreseed:(UIButton *)sender {

    NSLog(@"Number D");
     self.activityIndicator.hidden =NO;
    [self.activityIndicator startAnimating];
    
    NSLog(@"Number E");
    
    NSArray *permissionsArray = @[@"user_about_me", @"user_location", @"user_interests",@"user_relationships", @"user_birthday", @"user_relationship_details"];
    
    NSLog(@"Number F");
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    
    NSLog(@"Number G");
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden =YES;
        
        if (!user){
            if (!error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The Facebook Login was Canceled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }
        else
            NSLog(@"Number 3");
        {
            
            [self updateUserInformation];
            NSLog(@"Number 4");
            [self performSegueWithIdentifier:@"loginToEmployeeEditProfileSegue" sender:self];
            //[self performSegueWithIdentifier:@"loginToHomeSegue" sender:self]; <--Previously
            
        }
    }];
    
}




- (IBAction)loginButtonPressed:(UIButton *)sender {
    NSLog(@"Number H");
    [self performSegueWithIdentifier:@"businessLoginSegue1" sender:self];
}







#pragma mark - Helper Method

- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    
        NSLog(@"Number I");
        if (!error) {
            NSDictionary *userDictionary =(NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
            
            NSLog(@"Number J");
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            
            if (userDictionary[@"name"]){
                userProfile[kMMKUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"]){
                userProfile[kMMKUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"]){
                userProfile[kMMKUserProfileLocationKey] = userDictionary[@"location"];
            }
            if (userDictionary[@"gender"]){
                userProfile[kMMKUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"]){
                userProfile[kMMKUserProfileBirthdayKey] = userDictionary[@"birthday"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter
                                dateFromString:userDictionary[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds /31536000;
                userProfile[kMMKUserProfileAgeKey] = @(age);
            }
            if (userDictionary[@"interestedIn"]){
                userProfile[kMMKUserProfileInterestedInKey] = userDictionary[@"interestedIn"];
            }
            if (userDictionary[@"relationship_status"]){
                userProfile[kMMKUserProfileRelationshopStatusKey] = userDictionary[@"relationship_status"];
            }
            
            NSLog(@"Number K");
            
            
            if ([pictureURL absoluteString]) {
                userProfile[kMMKUserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:@1 forKey:kMMKActivityTracker];
            [[PFUser currentUser] setObject:userProfile forKey:kMMKUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            
            NSLog(@"Number L");
            [self requestImage];
            
        }
        else {
            NSLog(@"Error in FB request %@", error);
        }
        
    }];
}


-(void)uploadPFFileToParse:(UIImage *)image

{
    NSLog(@"Number M");
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (!imageData){
        NSLog (@"imageData was not found.");
        return;
    }
    
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    NSLog(@"Number N");
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            PFObject *photo = [PFObject objectWithClassName:kMMKPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kMMKPhotoUserKey];
            [photo setObject:photoFile forKey:kMMKPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully");
                
            }];
            
        }
        
    }];
    
}

-(void)requestImage {
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number ==0)
        {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kMMKUserProfileKey][kMMKUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:12.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection){
                NSLog(@"Failed to Download Picture");
            }
            
            
        }
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [self.imageData appendData:data];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
