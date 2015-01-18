 //
//  MMKBusinessLoginViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/22/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKBusinessLoginViewController.h"
#import <Parse/Parse.h> 
#import "MMKConstants.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>


@interface MMKBusinessLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *reenterPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation MMKBusinessLoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}



/*
 -(void)viewDidAppear:(BOOL) animated{
    
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

 */



- (void)viewDidLoad {
    
   
    [super viewDidLoad];

    
    
    // Do any additional setu p after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerButtonPressed:(UIButton *)sender {
    
    
    
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reenterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}



#pragma mark - Actions performed

-(void) checkFieldsComplete {
    if ([_usernameField.text isEqualToString:@""]  || [_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reenterPasswordField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oooopps!" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self checkPasswordsMatch];
    }
}

-(void) checkPasswordsMatch {
    if (![_passwordField.text isEqualToString:_reenterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"Your passwords do not match!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self registerNewBusinessUser];
        [self gotoNextPage];
    }
}

-(void) registerNewBusinessUser {
    
    PFUser *newUser = [PFUser user];
    newUser.username =_usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Registration success!");
            NSDictionary *profile = @{@"age" : @"Business", @"birthday" : @"Business",
                                      @"firstName" : @"Business", @"gender" : @"Business",  @"location" :
                                          @"Business", @"name" : @"Business"};
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                {
                    UIImage *profileImage = [UIImage
                                             imageNamed:@"now-hiring.jpg"];
                    NSLog(@"%@", profileImage);
                    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                    
                    PFFile *photoFile = [PFFile fileWithData:imageData];
                    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            PFObject *photo = [PFObject objectWithClassName:kMMKPhotoClassKey];
                            [photo setObject:newUser forKey:kMMKPhotoUserKey];
                            [photo setObject:photoFile forKey:kMMKPhotoPictureKey];
                            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                NSLog(@"photo saved successfully!");
                            }];
                            
                        }
                    }];
                }
            }];
            
        }
        else {
            NSLog(@"There was an error in registration");
        }
    }];
}

-(void) gotoNextPage {
    [self performSegueWithIdentifier:@"newRegistrationToBusinessInformationSegue" sender:self];
    

}


@end
