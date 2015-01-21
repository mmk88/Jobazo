//
//  MMKEditBusinessPostingViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/26/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKEditBusinessPostingViewController.h"
#import "MMKConstants.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>


@interface MMKEditBusinessPostingViewController ()


@property (strong, nonatomic) IBOutlet UIDatePicker *startDate;
@property (strong, nonatomic) IBOutlet UITextField *jobPosting;
@property (strong, nonatomic) IBOutlet UITextField *hourlyPay;
@property (strong, nonatomic) IBOutlet UITextField *briefJobDescription;
@property (strong, nonatomic) IBOutlet UITextField *hoursOfWork;

//The ImageView object is not the ViewController, but leave it in as it pulls up relevant data for storage
@property (strong, nonatomic) IBOutlet UIImageView *imageViews;

//This is for the end date Picker, All you need to do is add a picker & un// all lines with "endDate"
//@property (strong, nonatomic) IBOutlet UIDatePicker *endDate;

@end

@implementation MMKEditBusinessPostingViewController

- (void)viewDidLoad {

    [super viewDidLoad];

     PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
     [query whereKey:kMMKPhotoUserKey equalTo:[PFUser currentUser]];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if ([objects count] > 0){
     PFObject *photo =objects[0];
     PFFile *pictureFile = photo[kMMKPhotoPictureKey];
     [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
     self.imageViews.image = [UIImage imageWithData:data];
     
     }];
     }
     }];

    
    NSDate *now = [NSDate date];
    //[_startDate setDate:now animated:YES];
    
    PFUser *user =[PFUser currentUser];
    NSDate *posting = user[kMMKJobStartDateKey];
   // [_startDate setDate:posting animated:YES];
    
    if (posting ==nil) {
        [_startDate setDate:now animated:YES];
    }
    else{
        [_startDate setDate:posting animated:YES];
    }
    
    //This is for ENDDATE PICKER
    //NSDate *tommorrow = [NSDate dateWithTimeInterval:86400 sinceDate:now];
    //[_endDate setDate:tommorrow animated:YES];
    
    self.jobPosting.text = [[PFUser currentUser] objectForKey:kMMKJobPostingKey];
    self.hourlyPay.text = [[PFUser currentUser] objectForKey:kMMKJobHourlyPayKey];
    self.briefJobDescription.text = [[PFUser currentUser] objectForKey:kMMKBriefJobDescriptionKey];
    self.hoursOfWork.text = [[PFUser currentUser] objectForKey:kMMKHoursOfWorkKey];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_jobPosting isFirstResponder]  && [touch view] != _jobPosting) {
        [_jobPosting resignFirstResponder];
    }
    else
    {
        if ([_hourlyPay isFirstResponder] && [touch view] != _hourlyPay) {
            [_hourlyPay resignFirstResponder];
        }
        else
        {
            if ([_hoursOfWork isFirstResponder] && [touch view] !=_hoursOfWork) {
                [_hoursOfWork resignFirstResponder];
        }
        else
        {
            if ([_briefJobDescription isFirstResponder] && [touch view] != _briefJobDescription) {
                [_briefJobDescription resignFirstResponder];
            }
                        }
            [super touchesBegan:touches withEvent:event];
            }
        }
}


#pragma mark - IB Actions


- (IBAction)updatePostingButtonPressed:(UIButton *)sender {
    
    [[PFUser currentUser] setObject:self.startDate.date     forKey:kMMKJobStartDateKey];
    
    //This is for ENDDATE PICKER
    //[[PFUser currentUser] setObject:self.endDate.date forKey:kMMKJobEndDateKey];
    
    [[PFUser currentUser] setObject:self.jobPosting.text forKey:kMMKJobPostingKey];
    [[PFUser currentUser] setObject:self.hourlyPay.text forKey:kMMKJobHourlyPayKey];
    [[PFUser currentUser] setObject:self.briefJobDescription.text forKey:kMMKBriefJobDescriptionKey];
    [[PFUser currentUser] setObject:self.hoursOfWork.text forKey:kMMKHoursOfWorkKey];
    
    [[PFUser currentUser] saveInBackground];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_JobPosting_Updated"];
    [mixpanel flush];
    

    [self checkFieldsComplete];
    
}

- (IBAction)nextBarButtonPressed:(UIBarButtonItem *)sender {
    
    [[PFUser currentUser] setObject:self.startDate.date     forKey:kMMKJobStartDateKey];
    
    //This is for ENDDATE PICKER
    //[[PFUser currentUser] setObject:self.endDate.date forKey:kMMKJobEndDateKey];
    
    [[PFUser currentUser] setObject:self.jobPosting.text forKey:kMMKJobPostingKey];
    [[PFUser currentUser] setObject:self.hourlyPay.text forKey:kMMKJobHourlyPayKey];
    [[PFUser currentUser] setObject:self.briefJobDescription.text forKey:kMMKBriefJobDescriptionKey];
    [[PFUser currentUser] setObject:self.hoursOfWork.text forKey:kMMKHoursOfWorkKey];
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_JobPosting_NotUpdated"];
    [mixpanel flush];
    
    [[PFUser currentUser] saveInBackground];
    
    [self checkFieldsComplete];
}

-(void) checkFieldsComplete {
    if ([_jobPosting.text isEqualToString:@""]  || [_hourlyPay.text isEqualToString:@""] || [_briefJobDescription.text isEqualToString:@""] || [_hoursOfWork.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oooopps!" message:@"You need to complete all fields.           Enter 0 if N/A" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Business_JobPosting_Error"];
        [mixpanel flush];
        
        [alert show];
    }
    else
    {
       [self performSegueWithIdentifier:@"jobPostingToMatchesSegue" sender:self];
    }
}


@end
