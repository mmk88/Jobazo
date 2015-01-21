//
//  MMKEditBusinessInformationViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/27/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKEditBusinessInformationViewController.h"
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

@interface MMKEditBusinessInformationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *businessNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *businessTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *businessWebsiteTextField;
@property (strong, nonatomic) IBOutlet UITextField *businessPhoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *businessAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *businessAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *businessAddressCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *businessAddressZipCodeTextField;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

@end

@implementation MMKEditBusinessInformationViewController

- (void)viewDidLoad {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_BusinessInfoUpdate_PageOpened"];
    [mixpanel flush];
    
    
    [super viewDidLoad];
    
/*
    PFQuery *query = [PFQuery queryWithClassName:kMMKPhotoClassKey];
    [query whereKey:kMMKPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0){
            PFObject *photo =objects[0];
            PFFile *pictureFile = photo[kMMKPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.businessPictureImageView.image = [UIImage imageWithData:data];
                
            }];
        }
    }];
*/
     

    
    self.businessNameTextField.text           =    [[PFUser currentUser] objectForKey:kMMKBusinessNameKey];
    self.businessTypeTextField.text           =    [[PFUser currentUser] objectForKey:kMMKBusinessTypeKey];
    self.businessWebsiteTextField.text        =    [[PFUser currentUser] objectForKey:kMMKBusinessWebsiteKey];
    self.businessPhoneNumberTextField.text    =    [[PFUser currentUser] objectForKey:kMMKBusinessPhoneNumberKey];
    self.businessAddressLine1TextField.text   =    [[PFUser currentUser] objectForKey:kMMKBusinessAddressLine1Key];
    self.businessAddressLine2TextField.text   =    [[PFUser currentUser] objectForKey:kMMKBusinessAddressLine2Key];
    self.businessAddressCityTextField.text    =    [[PFUser currentUser] objectForKey:kMMKBusinessAddressCityKey];
    self.businessAddressZipCodeTextField.text =    [[PFUser currentUser] objectForKey:kMMKBusinessZipCodeKey];

    //THESE BELOW LINES GET RID OF THE keyboard
    
    self.businessNameTextField.delegate =self;
    self.businessTypeTextField.delegate =self;
    self.businessWebsiteTextField.delegate =self;
    self.businessPhoneNumberTextField.delegate=self;
    self.businessAddressLine1TextField.delegate=self;
    self.businessAddressLine2TextField.delegate=self;
    self.businessAddressCityTextField.delegate=self;
    self.businessAddressZipCodeTextField.delegate=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_businessNameTextField isFirstResponder]  && [touch view] != _businessNameTextField) {
        [_businessNameTextField resignFirstResponder];
    }
    else
    {
    if ([_businessAddressLine2TextField isFirstResponder] && [touch view] != _businessAddressLine2TextField) {
        [_businessAddressLine2TextField resignFirstResponder];
    }
    else
    {
    if ([_businessAddressCityTextField isFirstResponder] && [touch view] != _businessAddressCityTextField) {
        [_businessAddressCityTextField resignFirstResponder];
    }
    else
    {
    if ([_businessAddressZipCodeTextField isFirstResponder] && [touch view] != _businessAddressZipCodeTextField) {
        [_businessAddressZipCodeTextField resignFirstResponder];
    }
    }
        [super touchesBegan:touches withEvent:event];
    }
}
}

- (IBAction)nextbarButtonItemPressed:(id)sender {
    [[PFUser currentUser] setObject:self.businessNameTextField.text            forKey:kMMKBusinessNameKey];
    [[PFUser currentUser] setObject:self.businessTypeTextField.text            forKey:kMMKBusinessTypeKey];
    [[PFUser currentUser] setObject:self.businessWebsiteTextField.text         forKey:kMMKBusinessWebsiteKey];
    [[PFUser currentUser] setObject:self.businessPhoneNumberTextField.text     forKey:kMMKBusinessPhoneNumberKey];
    [[PFUser currentUser] setObject:self.businessAddressLine1TextField.text    forKey:kMMKBusinessAddressLine1Key];
    [[PFUser currentUser] setObject:self.businessAddressLine2TextField.text    forKey:kMMKBusinessAddressLine2Key];
    [[PFUser currentUser] setObject:self.businessAddressCityTextField.text     forKey:kMMKBusinessAddressCityKey];
    [[PFUser currentUser] setObject:self.businessAddressZipCodeTextField.text  forKey:kMMKBusinessZipCodeKey];
    
    [[PFUser currentUser] setObject:@1                                         forKey:kMMKBusinessIndicator];
    
    [[PFUser currentUser] saveInBackground];
    
    
    NSDictionary *profile = @{@"age" :@"-9999999", @"birthday" : @"Business",
                              @"firstName" : self.businessNameTextField.text, @"gender" : @"Business",  @"location" :
                                  @"Business", @"name" :self.businessNameTextField.text};
    
    [[PFUser currentUser] setObject:profile forKey:@"profile"];
    
    [self checkFieldsComplete];
    
}


-(void) checkFieldsComplete {
    if ([_businessNameTextField.text isEqualToString:@""]  || [_businessTypeTextField.text isEqualToString:@""] || [_businessWebsiteTextField.text isEqualToString:@""] || [_businessPhoneNumberTextField.text isEqualToString:@""] || [_businessAddressLine1TextField.text isEqualToString:@""] || [_businessAddressLine2TextField.text isEqualToString:@""] || [_businessAddressCityTextField.text isEqualToString:@""] || [_businessAddressZipCodeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oooopps!" message:@"You need to complete all fields.    Enter 0 if N/A" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Business_BusinessInfoUpdate_Error"];
        [mixpanel flush];
        
        
        [alert show];
    }
    else
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Business_BusinessInfoUpdate_Success"];
        [mixpanel flush];
        
        [self performSegueWithIdentifier:@"businessInformationToJobPostingUpdateSegue" sender:self];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}







//GETS RID OF THE KEYBOARD
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
