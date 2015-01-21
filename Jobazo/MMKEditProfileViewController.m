//
//  MMKEditProfileViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/5/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKEditProfileViewController.h"
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


@interface MMKEditProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextField *taglineTextView;

@property (strong, nonatomic) IBOutlet UITextField *employerJob1;
@property (strong, nonatomic) IBOutlet UITextField *positionJob1;
@property (strong, nonatomic) IBOutlet UITextField *durationJob1;

@property (strong, nonatomic) IBOutlet UITextField *employerJob2;
@property (strong, nonatomic) IBOutlet UITextField *positionJob2;
@property (strong, nonatomic) IBOutlet UITextField *durationJob2;

@property (strong, nonatomic) IBOutlet UITextField *skill1;
@property (strong, nonatomic) IBOutlet UITextField *skill2;
@property (strong, nonatomic) IBOutlet UITextField *skill3;
//@property (strong, nonatomic) IBOutlet UITextField *skill4;
//@property (strong, nonatomic) IBOutlet UITextField *skill5;
//@property (strong, nonatomic) IBOutlet UITextField *skill6;

@property (strong, nonatomic) IBOutlet UITextField *workCity;
@property (strong, nonatomic) IBOutlet UITextField *workZipcode;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *email;




@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UIButton *saveBarButtonItem;


@property (strong, nonatomic) IBOutlet UIButton *backBarButtonItem;



@end

@implementation MMKEditProfileViewController






- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    // ALL THESE LINES HELP THE keyboard go away when i press return; also the BOOL textfield should return is a part of this and then <UITExtField Delegate> in the.h file
    
    
    self.taglineTextView.delegate =self;
    self.employerJob1.delegate    =self;
    self.positionJob1.delegate    =self;
    self.durationJob2.delegate    =self;
    
    self.employerJob2.delegate    =self;
    self.positionJob2.delegate    =self;
    self.durationJob2.delegate    =self;
    
    self.skill1.delegate          =self;
    self.skill2.delegate          =self;
    self.skill3.delegate          =self;
    //self.skill4.delegate          =self;
    //self.skill5.delegate          =self;
    //self.skill6.delegate          =self;
    
    self.workCity.delegate        =self;
    self.workZipcode.delegate     =self;
    self.phoneNumber.delegate     =self;
    self.email.delegate           =self;
    
    //331
    
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0){
            PFObject *photo =objects[0];
            PFFile *pictureFile = photo[kMMKPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
                
            }];
        }
    }];
    
    ///// IMPORTANT!!!! /////
    
    self.taglineTextView.text = [[PFUser currentUser] objectForKey:kMMKUserTagLineKey];
    
    self.employerJob1.text =    [[PFUser currentUser] objectForKey:kMMKUserEmployerJob1Key];
    self.positionJob1.text =    [[PFUser currentUser] objectForKey:kMMKUserPositionJob1Key];
    self.durationJob1.text =    [[PFUser currentUser] objectForKey:kMMKUserDuationJob1Key];
    
    self.employerJob2.text =    [[PFUser currentUser] objectForKey:kMMKUserEmployerJob2Key];
    self.positionJob2.text =    [[PFUser currentUser] objectForKey:kMMKUserPositionJob2Key];
    self.durationJob2.text =    [[PFUser currentUser] objectForKey:kMMKUserDuationJob2Key];
    
    self.skill1.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill1];
    self.skill2.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill2];
    self.skill3.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill3];
    //self.skill4.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill4];
    //self.skill5.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill5];
    //self.skill6.text =          [[PFUser currentUser] objectForKey:kMMKUserSkill6];
    
    self.workCity.text =        [[PFUser currentUser] objectForKey:kMMKUserWorkCity];
    self.workZipcode.text =     [[PFUser currentUser] objectForKey:kMMKUserWorkZip];
    self.phoneNumber.text =     [[PFUser currentUser] objectForKey:kMMKUserPhoneNumber];
    self.email.text =           [[PFUser currentUser] objectForKey:kMMKUserEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -IBActions

- (IBAction)saveBarButtonItemPressed:(UIButton *)sender {

//331
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Employee_UpdatedInformation"];
    [mixpanel flush];
    

    [[PFUser currentUser] setObject:self.taglineTextView.text forKey:kMMKUserTagLineKey];
    
    [[PFUser currentUser] setObject:self.employerJob1.text    forKey:kMMKUserEmployerJob1Key];
    [[PFUser currentUser] setObject:self.positionJob1.text    forKey:kMMKUserPositionJob1Key];
    [[PFUser currentUser] setObject:self.durationJob1.text    forKey:kMMKUserDuationJob1Key];
   
    [[PFUser currentUser] setObject:self.employerJob2.text    forKey:kMMKUserEmployerJob2Key];
    [[PFUser currentUser] setObject:self.positionJob2.text    forKey:kMMKUserPositionJob2Key];
    [[PFUser currentUser] setObject:self.durationJob2.text    forKey:kMMKUserDuationJob2Key];
    
    [[PFUser currentUser] setObject:self.skill1.text          forKey:kMMKUserSkill1];
    [[PFUser currentUser] setObject:self.skill2.text          forKey:kMMKUserSkill2];
    [[PFUser currentUser] setObject:self.skill3.text          forKey:kMMKUserSkill3];
    //[[PFUser currentUser] setObject:self.skill4.text          forKey:kMMKUserSkill4];
    //[[PFUser currentUser] setObject:self.skill5.text          forKey:kMMKUserSkill5];
    //[[PFUser currentUser] setObject:self.skill6.text          forKey:kMMKUserSkill6];
    
    [[PFUser currentUser] setObject:self.workCity.text        forKey:kMMKUserWorkCity];
    [[PFUser currentUser] setObject:self.workZipcode.text     forKey:kMMKUserWorkZip];
    [[PFUser currentUser] setObject:self.phoneNumber.text     forKey:kMMKUserPhoneNumber];
    [[PFUser currentUser] setObject:self.email.text           forKey:kMMKUserEmail];

    //This is used for comparisions in AllowPhoto to ensure not business
    [[PFUser currentUser] setObject:@0                        forKey:kMMKBusinessIndicator];
   

    
    [self checkFieldsComplete];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)backButtonPressed:(UIButton *)sender {
   
}


-(void) checkFieldsComplete {
    if ([_taglineTextView.text isEqualToString:@""]  || [_employerJob1.text isEqualToString:@""] || [_positionJob1.text isEqualToString:@""] || [_durationJob1.text isEqualToString:@""] || [_employerJob2.text isEqualToString:@""] || [_positionJob2.text isEqualToString:@""] || [_durationJob2.text isEqualToString:@""] || [_skill1.text isEqualToString:@""] || [_skill2.text isEqualToString:@""] || [_skill3.text isEqualToString:@""] || [_workCity.text isEqualToString:@""] || [_workZipcode.text isEqualToString:@""] || [_phoneNumber.text isEqualToString:@""] || [_email.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oooopps!" message:@"You need to complete all fields.           Enter 0 if N/A" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [[PFUser currentUser] saveInBackground];
        [self performSegueWithIdentifier:@"EditEmployeeProfileToJobPostingSegue" sender:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
