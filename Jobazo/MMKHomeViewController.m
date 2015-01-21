//
//  MMKHomeViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKHomeViewController.h"
#import "MMKMatchViewController.h"
#import "MMKTestUser.h"
#import "MMKProfileViewController.h"

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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface MMKHomeViewController () <MMKMatchViewControllerDelegate> //341

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel     *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel     *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel     *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel     *statusLabel;
@property (weak, nonatomic)   IBOutlet UIButton    *infoButton;
@property (strong, nonatomic) IBOutlet UILabel     *tagLineLabel;
@property (strong, nonatomic) IBOutlet UILabel     *employerJob1Label;
@property (strong, nonatomic) IBOutlet UILabel     *positionJob1Label;
@property (strong, nonatomic) IBOutlet UILabel     *durationJob1Label;

@property (strong, nonatomic) IBOutlet UILabel     *employerJob2Label;
@property (strong, nonatomic) IBOutlet UILabel     *positionJob2Label;
@property (strong, nonatomic) IBOutlet UILabel     *durationJob2Label;
@property (strong, nonatomic) IBOutlet UILabel     *pastEmploymentLabel;

@property (weak, nonatomic) IBOutlet UIButton      *likeButton;
@property (weak, nonatomic) IBOutlet UIButton      *dislikeButton;

@property (strong, nonatomic) NSArray              *photos; /*this created a new class in parse*/
@property (strong, nonatomic) PFObject             *photo; //*this created a new class in parse*/
@property (strong, nonatomic) NSMutableArray       *activities; /*318*/

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;/*318*/
@property (nonatomic) BOOL isDislikedByCurrentUser;/*318*/


@property (strong, nonatomic) IBOutlet UILabel *employmentHistoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *historyLabel1;
@property (strong, nonatomic) IBOutlet UILabel *historyLabel2;




@end

@implementation MMKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xe67e22)];
    //[MMKTestUser saveTestUserToParse]; //326
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xe67e22)];
    
    self.photoImageView.image = nil;
    self.firstNameLabel.text = nil;
    self.ageLabel.text = nil;
    self.sexLabel.text = nil;
    self.statusLabel.text = nil;
    self.tagLineLabel.text = nil;
    
    self.employerJob1Label.text = nil;
    self.positionJob1Label.text = nil;
    self.durationJob1Label.text = nil;
    
    self.employerJob2Label.text = nil;
    self.positionJob2Label.text = nil;
    self.durationJob2Label.text = nil;
    
    self.pastEmploymentLabel.text = nil;
    //self.employmentHistoryLabel.text=nil;
    //self.historyLabel1.text =nil;
    //self.historyLabel2.text =nil;
    


    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey notEqualTo:[PFUser currentUser]]; //326//
    [query includeKey:kMMKPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             self.photos = objects;
             
             //359
             if([self allowEmployeePhoto] ==NO){
                 [self setupNextPhoto];
             }
             else {
             [self queryForCurrentPhotoIndex];
             }
         }
         else {
             NSLog(@"%@",error);
         }
     }
     
     ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//327

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"])
    {
        MMKProfileViewController *profileVC =segue.destinationViewController;
        profileVC.photo =self.photo;
    }
    
    //339
    else if ([segue.identifier isEqualToString:@"homeToMatchSeque"])
    {
        MMKMatchViewController *matchVC =segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.delegate = self;
    }
}

#pragma mark - IBActions

- (IBAction)settingsBarButtonPressed:(UIBarButtonItem *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_SettingsChecked"];
    [mixpanel flush];
    
    [self performSegueWithIdentifier:@"employeeViewVCtoBusinessSettingsVCSegue" sender:nil];
}


- (IBAction)likeButtonPressed:(UIButton *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_LikedEmployee"];
    [mixpanel flush];
    
    [self checkLike]; /*322*/
    
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_DisLikedEmployee"];
    [mixpanel flush];
    [self checkDisLike]; /*322*/
}

- (IBAction)infoButtonPressed:(UIButton *)sender { /*327*/
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_RequestEmployeeInfo"];
    [mixpanel flush];
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_CheckChat"];
    [mixpanel flush];
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
}


#pragma mark - Helper Methods


-(void)queryForCurrentPhotoIndex {
    if ([self.photos count] >0) {
        self.photo = self.photos [self.currentPhotoIndex];
        PFFile *file = self.photo[kMMKPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];  /*316*/
            }
            else NSLog(@"%@", error);
        }];
        //323 ..... HERE WE ARE DOING SOME WORK TO CHECK THE PAST LIKES SO THEY DONT SHOW UP AGAIN
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMMKActivityClassKey];
        [queryForLike    whereKey:kMMKActivityPhotoKey     equalTo:self.photo];
        [queryForLike    whereKey:kMMKActivitiyFromUserKey equalTo:[PFUser currentUser]];
        [queryForLike    whereKey:kMMKActivityTypeKey      equalTo:kMMKActivityTypeLikeKey];
        NSLog(@"%@", queryForLike);
        PFQuery *queryForDislike = [PFQuery queryWithClassName: kMMKActivityClassKey];
        [queryForDislike whereKey:kMMKActivityPhotoKey     equalTo:self.photo];
        [queryForDislike whereKey:kMMKActivitiyFromUserKey equalTo:[PFUser currentUser]];
        [queryForDislike whereKey:kMMKActivityTypeKey      equalTo:kMMKActivityTypeDislikeKey];
        NSLog(@"%@", queryForDislike);
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        
        {
            if (!error){
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0)
                {
                     NSLog(@"%@", @"This picture has zero likes");
                     self.isLikedByCurrentUser       = NO;
                     self.isDislikedByCurrentUser    = NO;
                }
                else
                {
                
                    //ENABLE THE CODE 123 below, if you want the employee picture to continutally pop up and disable the code currently active
                
                    // CODE 123
                    
                    /*
                     PFObject *activity = self.activities [0];
                    
                    if ([activity [kMMKActivityTypeKey] isEqualToString:kMMKActivityTypeLikeKey]) {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    
                    else if ([activity [kMMKActivityTypeKey] isEqualToString:kMMKActivityTypeDislikeKey]) {
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else
                    {
                        //some other type of activity
                    }
                    */
                    
                    //CODE 123 ENDS HERE
                
                    if (self.currentPhotoIndex +1 <self.photos.count) {
                        self.currentPhotoIndex ++;
                        [self queryForCurrentPhotoIndex];
                     }
                    else
                    {
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No more Potential Hires to View!" message:@"You previoulsy viewed all Hires available - Check back later for more Hires!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                        //ADDED THIS TO CLEAR OUT IF NO MORE HIRES
                        
                        self.photoImageView.image = nil;
                        self.firstNameLabel.text = nil;
                        self.ageLabel.text = nil;
                        self.sexLabel.text = nil;
                        self.statusLabel.text = nil;
                        self.tagLineLabel.text = nil;
                        
                        self.employerJob1Label.text = nil;
                        self.positionJob1Label.text = nil;
                        self.durationJob1Label.text = nil;
                        
                        self.employerJob2Label.text = nil;
                        self.positionJob2Label.text = nil;
                        self.durationJob2Label.text = nil;
                        
                        self.pastEmploymentLabel.text = nil;
                        //self.employmentHistoryLabel.text=nil;
                        //self.historyLabel1.text =nil;
                        //self.historyLabel2.text =nil;

                        
                        self.likeButton.enabled = NO;
                        self.dislikeButton.enabled = NO;
                        self.infoButton.enabled = NO;
                        
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
                self.infoButton.enabled = YES; //327
            }
        }];
    }
}


/* 316 - Updating the Home View's Information  - name, age, and tagline */


- (void)updateView

{
    self.firstNameLabel.text = self.photo[kMMKPhotoUserKey][kMMKUserProfileKey][kMMKUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.photo[kMMKPhotoUserKey][kMMKUserProfileKey][kMMKUserProfileAgeKey]];
    
    self.sexLabel.text = [NSString stringWithFormat:@"%@",self.photo[kMMKPhotoUserKey][kMMKUserProfileKey][kMMKUserProfileGenderKey]];
    
    self.pastEmploymentLabel.text = [NSString stringWithFormat:@"EMPLOYMENT HISTORY:"];
    
    self.tagLineLabel.text = self.photo[kMMKPhotoUserKey][kMMKUserTagLineKey];
    self.employerJob1Label.text =self.photo[kMMKPhotoUserKey][kMMKUserEmployerJob1Key];
    self.positionJob1Label.text =self.photo[kMMKPhotoUserKey][kMMKUserPositionJob1Key];
    self.durationJob1Label.text =self.photo[kMMKPhotoUserKey][kMMKUserDuationJob1Key];
    
    self.employerJob2Label.text =self.photo[kMMKPhotoUserKey][kMMKUserEmployerJob2Key];
    self.positionJob2Label.text =self.photo[kMMKPhotoUserKey][kMMKUserPositionJob2Key];
    self.durationJob2Label.text =self.photo[kMMKPhotoUserKey][kMMKUserDuationJob2Key];
    
    [self statusCheck];
    
}


/* 317 - checking the next picture */
- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 <self.photos.count) {
        
        self.currentPhotoIndex ++;
        if ([self allowEmployeePhoto] ==NO){ //359
            [self setupNextPhoto];
            NSLog(@"Setup Next Photo");
        }
        else
        {
        [self queryForCurrentPhotoIndex];
            NSLog(@"Query For Next Photo");
        }
    }
    else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        //Added this to make it clear when there is nothing left to view
        
        
        self.photoImageView.image = nil;
        self.firstNameLabel.text = nil;
        self.ageLabel.text = nil;
        self.sexLabel.text = nil;
        self.statusLabel.text = nil;
        self.tagLineLabel.text = nil;
        
        self.employerJob1Label.text = nil;
        self.positionJob1Label.text = nil;
        self.durationJob1Label.text = nil;
        
        self.employerJob2Label.text = nil;
        self.positionJob2Label.text = nil;
        self.durationJob2Label.text = nil;
        
        //self.pastEmploymentLabel.text = nil;
        self.employmentHistoryLabel.text=nil;
        self.historyLabel1.text =nil;
        self.historyLabel2.text =nil;

        
        self.likeButton.enabled = NO;
        self.dislikeButton.enabled = NO;
        self.infoButton.enabled = NO;
        
    }
}


- (BOOL) allowEmployeePhoto
{
    PFObject *photoZ = self.photos[self.currentPhotoIndex];
    PFUser *user = photoZ[kMMKPhotoUserKey];
    
    //ENSURE THEY ARE USER NOT BUSINESS
    
    int BusinessIndication = [user[kMMKBusinessIndicator] intValue];
    NSLog(@"Hello BUSINESS IS %i",BusinessIndication);
    
    if (BusinessIndication==1) {
        NSLog(@"Business Is Business");
    }
    else {
        NSLog(@"Business Is Human");
    }
    
    int employeeActive = [user[kMMKActivityTracker] intValue];
    NSLog(@"hello this employee is Active because %i",employeeActive);
    
    if (BusinessIndication==1) {
        return NO;
    }
    else if (employeeActive==0){
        return NO;
    }
    else
    {
        return YES;
    }
}


/* 318 - this saves like */

- (void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kMMKActivityClassKey];
    [likeActivity setObject:kMMKActivityTypeLikeKey forKey:kMMKActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMMKActivitiyFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMMKPhotoUserKey] forKey:kMMKActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kMMKActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        
        [self checkForPhotoUserLikes]; //338
        
        [self setupNextPhoto];
    }];
}

/* 319 - this saves dislike */

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMMKActivityClassKey];
    [dislikeActivity setObject:kMMKActivityTypeDislikeKey forKey:kMMKActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMMKActivitiyFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMMKPhotoUserKey] forKey:kMMKActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kMMKActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isDislikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
    
}


/* 320 - checks likes then setsup next photo AND deletes from parse the Like/Dislike */

#pragma mark - Helper Methods

- (void)checkLike
{
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
        
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities){
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
        
    }
}

/* 321 - checks dislikes then setsup next photo AND deletes from parse the Like/Dislike */

- (void)checkDisLike
{
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
        
    }
    else if (self.isLikedByCurrentUser) {
        for (PFObject *activity in self.activities){
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
        
    }
}


//337

- (void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:kMMKActivityClassKey];
    [query whereKey:kMMKActivitiyFromUserKey equalTo:self.photo[kMMKPhotoUserKey]];
    [query whereKey:kMMKActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kMMKActivityTypeKey equalTo:kMMKActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([objects count] > 0) {
             //338
             [self createChatRoom];
         }
     }];
    
}

//338

-(void)createChatRoom
{
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[kMMKPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.photo[kMMKPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0){
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[kMMKPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self MatchedAlert];
            }];
        }
    }];
    
}


- (void)statusCheck{
    
    PFObject *photo = self.photos[self.currentPhotoIndex];
    PFUser *user = photo[kMMKPhotoUserKey];
    
    int employeeActive = [user[kMMKActivityTracker] intValue];
    NSLog(@"This Employees Activity Status is %i",employeeActive);
    
    if (employeeActive==0) {
        self.statusLabel.text =[NSString stringWithFormat:@"INACTIVE"];
    }
    else{
        self.statusLabel.text =[NSString stringWithFormat:@"ACTIVE"];
    }
    
}


-(void) MatchedAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"This Employee wants to work with you too! Goto Chats to contact this Employee." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"employerAlertedofLike"];
    [mixpanel flush];
    
    [alert show];
}


#pragma mark - MMKMatchViewController Delegate

-(void) presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}


@end
