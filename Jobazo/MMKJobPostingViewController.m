//
//  MMKJobPostingViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//
#import "MMKJobPostingViewController.h"
#import "MMKBusinessMatchViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MMKJobPostingViewController () 

@property (strong, nonatomic) IBOutlet UILabel     *jobPosting;
@property (strong, nonatomic) IBOutlet UILabel     *jobDescription;
@property (strong, nonatomic) IBOutlet UILabel     *fromDate;

@property (strong, nonatomic) IBOutlet UILabel     *toDate;
@property (strong, nonatomic) IBOutlet UILabel     *hourlyWage;
@property (strong, nonatomic) IBOutlet UILabel     *businessName;
@property (strong, nonatomic) IBOutlet UILabel     *businessZipCode;
@property (strong, nonatomic) IBOutlet UILabel *businessType;


@property (strong, nonatomic) IBOutlet UILabel     *businessRequirements;
@property (strong, nonatomic) IBOutlet UIButton    *passJobButton;
@property (strong, nonatomic) IBOutlet UIButton    *applyJobButton;

@property (strong, nonatomic) IBOutlet UIImageView *jobProfileImageView;

@property (strong, nonatomic) NSArray *photos; /*this created a new class in parse*/
@property (strong, nonatomic) PFObject *photo; //*this created a new class in parse*/
@property (strong, nonatomic) NSMutableArray *activities; /*318*/

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;/*318*/
@property (nonatomic) BOOL isDislikedByCurrentUser;/*318*/

@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
//@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *jobSettingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *jobChatButton;

// count down variables

@property (strong, nonatomic) IBOutlet UILabel *daysCountdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *hoursCountdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesCountdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsCountdownLabel;


@property (strong, nonatomic) IBOutlet UILabel *perHourLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobStartsLabel;


@end

@implementation MMKJobPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xe67e22)];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xe67e22)];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.jobProfileImageView.image =nil;
    self.jobPosting.text = nil;
    self.jobDescription.text = nil;
    self.fromDate.text =nil;
    self.startTimeLabel.text =nil;
    self.toDate.text =nil;
    self.hourlyWage.text =nil;
    self.businessName.text =nil;
    self.businessZipCode.text =nil;
    self.businessRequirements.text =nil;
    self.businessType.text =nil;
    
    //self.perHourLabel.text =nil;
    //self.jobDateLabel.text =nil;
    //self.jobTimeLabel.text =nil;
    //self.jobStartsLabel.text =nil;
    //self.daysCountdownLabel.text =nil;
    
    self.applyJobButton.enabled= NO;
    self.passJobButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey notEqualTo:[PFUser currentUser]]; //326//
    [query includeKey:kMMKPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             self.photos = objects;
             
             //359
             if ([self allowPhoto] ==NO){
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




#pragma mark - IBActions

- (IBAction)passJobButtonPressed:(UIButton *)sender {
    [self checkPassJob];
}

- (IBAction)applyJobButtonPressed:(UIButton *)sender {
    [self checkApplyJob];
}

- (IBAction)jobSettingsButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"jobPostingVCtoUserSettingsVCSegue" sender:self];
}


- (IBAction)jobChatButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"jobPostingToBusinessMatchesSegue" sender:self];
    
}



#pragma mark - Helper Methods


-(void)queryForCurrentPhotoIndex {
    if ([self.photos count] >0) {
        self.photo = self.photos [self.currentPhotoIndex];
        PFFile *file = self.photo[kMMKPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                UIImage *image = [UIImage imageWithData:data];
                self.jobProfileImageView.image = image;
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
                     self.isLikedByCurrentUser        = NO;
                     self.isDislikedByCurrentUser     = NO;
                 }
                 else
                 {
                     // THIS PIECE OF SHIT BELOW IS WHAT MAKES ALL THE PICKS WITH PREVIOUS LIKES OR DISLIKES FLICKER BEFORE IT GETS TO THE FUCKING POINT..jajaja
                     
                     if (self.currentPhotoIndex + 1 <self.photos.count) {
                         self.currentPhotoIndex ++;
                         [self queryForCurrentPhotoIndex];
                     }
                     else
                     {
                         UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No more Jobs to View!" message:@"You previoulsy viewed all available Jobs - Check back later for more Jobs!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert show];
                         
                         
                         //ADDED THIS TO CLEAR OUT IF NO MORE JOBS
                         
                         self.jobProfileImageView.image =nil;
                         self.jobPosting.text = nil;
                         self.jobDescription.text = nil;
                         self.fromDate.text =nil;
                         self.startTimeLabel.text =nil;
                         self.toDate.text =nil;
                         self.hourlyWage.text =nil;
                         self.businessName.text =nil;
                         self.businessZipCode.text =nil;
                         self.businessRequirements.text =nil;
                         self.businessType.text =nil;
                         
                         self.perHourLabel.text =nil;
                         self.jobDateLabel.text =nil;
                         self.jobTimeLabel.text =nil;
                         self.daysCountdownLabel.text =nil;
                         self.jobStartsLabel.text =nil;
                         
                         self.applyJobButton.enabled= NO;
                         self.passJobButton.enabled = NO;
                          
                         
                     }
    
             }
             }
             self.passJobButton.enabled           =YES;
             self.applyJobButton.enabled          =YES;
             
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCount)  userInfo:nil repeats:YES];
             
             
         }];
    }
}


- (void)TimerCount {
    
    // hours countdown calc
    
    NSDate *currentTime = [NSDate date];
    
    NSDateFormatter *currentTimeMonth = [[NSDateFormatter alloc] init];
    [currentTimeMonth setDateFormat:@"MM"];
    NSString *resultStringMonth = [currentTimeMonth stringFromDate: currentTime];
    //NSString *resultStringMonth = [currentTimeMonth stringForObjectValue: currentTime];
    
    NSDateFormatter *currentTimeDay = [[NSDateFormatter alloc] init];
    [currentTimeDay setDateFormat:@"dd"];
    NSString *resultStringDay = [currentTimeDay stringFromDate: currentTime];
    
    NSDateFormatter *currentTimeHour = [[NSDateFormatter alloc] init];
    [currentTimeHour setDateFormat:@"hh"];
    NSString *resultStringHour = [currentTimeHour stringFromDate: currentTime];
    
    NSDateFormatter *currentTimeMin = [[NSDateFormatter alloc] init];
    [currentTimeMin setDateFormat:@"mm"];
    NSString *resultStringMin = [currentTimeMin stringFromDate: currentTime];
    
    NSDateFormatter *currentTimeSec = [[NSDateFormatter alloc] init];
    [currentTimeSec setDateFormat:@"ss"];
    NSString *resultStringSec = [currentTimeSec stringFromDate: currentTime];

    
    NSDateFormatter *jobStartMonth = [[NSDateFormatter alloc] init];
    [jobStartMonth setDateFormat:@"MM"];
    NSString *jobStartMonthVar = [jobStartMonth stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    
    NSDateFormatter *jobStartDay = [[NSDateFormatter alloc] init];
    [jobStartDay setDateFormat:@"dd"];
    NSString *jobStartDayVar = [jobStartDay stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    
    NSDateFormatter *jobStartHr = [[NSDateFormatter alloc] init];
    [jobStartHr setDateFormat:@"hh"];
    NSString *jobStartHrVar = [jobStartHr stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    
    NSDateFormatter *jobStartMin = [[NSDateFormatter alloc] init];
    [jobStartMin setDateFormat:@"mm"];
    NSString *jobStartMinVar = [jobStartMin stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    
    NSDateFormatter *jobStartSec = [[NSDateFormatter alloc] init];
    [jobStartSec setDateFormat:@"ss"];
    NSString *jobStartSecVar = [jobStartSec stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    
    
    countMonthTemp = ([jobStartMonthVar intValue] - [resultStringMonth intValue]);
    
    if (countMonthTemp == 1) {
        countMonth = 0;
        
    } else {
        countMonth = ([jobStartMonthVar intValue] - [resultStringMonth intValue]) * 30;
    }
    
    //NSLog(@"%i", countMonthTemp);
    //NSLog(@"%i", countMonth);
    
    
    
    countDaysTemp   = ([jobStartDayVar intValue] - [resultStringDay intValue]);
  
        if (countDaysTemp < 0) {
            countDays = ([jobStartDayVar intValue] -[resultStringDay intValue]) + 30;
        }
        else {
            countDays = ([jobStartDayVar intValue] - [resultStringDay intValue]) + (countMonth);
        }
    
    //NSLog(@"%i", countDaysTemp);
    //NSLog(@"%i", countDays);


    countHourTemp = ([jobStartHrVar intValue] - [resultStringHour intValue]);
    
    if (countHourTemp < 0) {
        countHour = ([jobStartHrVar intValue] - [resultStringHour intValue]) + 11;
    }
    else {
        countHour = ([jobStartHrVar intValue] - [resultStringHour intValue]) - 1;
    }

    //NSLog(@" %i minus %i equals %i" , [jobStartHrVar intValue], [resultStringHour intValue], countHourTemp);
    //NSLog(@"%i", countHour);
    
    
    countMinTemp   = ([jobStartMinVar intValue] - [resultStringMin intValue]);
    
    if (countMinTemp < 0) {
        countMin = ([jobStartMinVar intValue] -[resultStringMin intValue]) + 60;
    }
    else {
        countMin = ([jobStartMinVar intValue] - [resultStringMin intValue]);
    }
    
    
    countSecTemp   = ([jobStartSecVar intValue] - [resultStringSec intValue]);
    
    if (countSecTemp < 0) {
        countSecond = ([jobStartSecVar intValue] -[resultStringSec intValue]) + 60;
    }
    else {
        countSecond = ([jobStartSecVar intValue] - [resultStringSec intValue]);
    }
    
    _daysCountdownLabel.text    = [NSString stringWithFormat:@"%i Days", countDays];
    _hoursCountdownLabel.text   = [NSString stringWithFormat:@"%i Hours", countHour];
    _minutesCountdownLabel.text = [NSString stringWithFormat:@"%i Min", countMin];
    _secondsCountdownLabel.text = [NSString stringWithFormat:@"%i Sec", countSecond];
    
}

- (void)updateView

{
    self.jobPosting.text = self.photo[kMMKPhotoUserKey][kMMKJobPostingKey];
    self.jobDescription.text = self.photo[kMMKPhotoUserKey][kMMKBriefJobDescriptionKey];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *startDate = [formatter stringForObjectValue:self.photo[kMMKPhotoUserKey][kMMKJobStartDateKey]];
    NSString *endDate   = [formatter stringForObjectValue:self.photo[kMMKPhotoUserKey][kMMKHoursOfWorkKey]];
    
    self.toDate.text = endDate;
    self.fromDate.text = startDate;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm"];
    //[timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *startTime = [timeFormatter stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobStartDateKey]];
    //NSString *endTime = [timeFormatter stringForObjectValue:self.photo [kMMKPhotoUserKey][kMMKJobEndDateKey]];
    
    
    self.startTimeLabel.text =startTime;
    //self.endTimeLabel.text =endTime;
    
    self.hourlyWage.text      =  self.photo[kMMKPhotoUserKey][kMMKJobHourlyPayKey];
    self.businessName.text    =  self.photo[kMMKPhotoUserKey][kMMKBusinessNameKey];
    self.businessZipCode.text =  self.photo[kMMKPhotoUserKey][kMMKBusinessZipCodeKey];
    self.businessType.text =self.photo[kMMKPhotoUserKey][kMMKBusinessTypeKey];
    
    
}


- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 <self.photos.count) {
        
        self.currentPhotoIndex ++;
        if ([self allowPhoto] ==NO){ //359
            [self setupNextPhoto];
        }
        else
        {
        [self queryForCurrentPhotoIndex];
        }
    }
    else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No More Jobs to View" message:@"Check back later for more Jobs!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}




- (BOOL) allowPhoto
{
 
    //PAY PART
    
    int minWage = [[NSUserDefaults standardUserDefaults] integerForKey:kMMKWageMinKey];
    NSLog(@"hello minwage %i",minWage);
    
    PFObject *photo = self.photos[self.currentPhotoIndex];
    PFUser *user = photo[kMMKPhotoUserKey];
    
    int userPay = [user[kMMKJobHourlyPayKey] intValue];
    NSLog(@"hello userPay %i",userPay);
    

    //ENSURE THEY ARE BUSINESS


    int BusinessIndication = [user[kMMKBusinessIndicator] intValue];
    NSLog(@"Hello BUSINESS IS %i",BusinessIndication);
    
    if (BusinessIndication==1) {
        
        NSLog(@"Business Is Business");
    }
    else
    {
        NSLog(@"Business Is Human");
        
    }
    
    
    //DATE COMPARISION, TO NOT SHOW OLD JOBS
    
    
    PFObject *photoX = self.photos[self.currentPhotoIndex];
    PFUser *userX = photoX[kMMKPhotoUserKey];
    
    NSDate *todaysDate =[NSDate date];
    
    NSDateFormatter *formatterX = [[NSDateFormatter alloc] init];
    [formatterX setDateStyle:NSDateFormatterShortStyle];
    NSString *startDateX = [formatterX stringForObjectValue:userX[kMMKJobStartDateKey]];
    NSLog(@"a %@", startDateX);
    
    NSString *balle =startDateX;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:balle];

    NSLog(@"The Date from String is %@", dateFromString);
    NSLog(@"Todays Date is %@", todaysDate);
    
    NSComparisonResult result;
    result = [dateFromString compare:todaysDate];
    
    NSLog(@"The result is %ld",result);
    
    
    BOOL value = (minWage > userPay);
    
    NSLog(@"%i",value);

    if (minWage>userPay){
        return NO;
    }
    else if (result<1){
        return NO;
    }
    else if (BusinessIndication==0){
        return NO;
    }
       else
       {
           return YES;
       }
}

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

- (void)checkApplyJob
{
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
        
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities){
            [activity deleteInBackground];
            [activity delete];
        }
        [self.activities removeLastObject];
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
        
    }
}

/* 321 - checks dislikes then setsup next photo AND deletes from parse the Like/Dislike */

- (void)checkPassJob
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
                
                
                
                //[self performSegueWithIdentifier:@"jobPostingToBusinessMatchSegue" sender:nil];
            }];
        }
    }];
    
}


#pragma mark - Helper Methods

-(void) MatchedAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"This Employer wants to work with you too! Goto Chats to contact this Employer." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
