//
//  RegisteredBusinessLoginViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/22/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "RegisteredBusinessLoginViewController.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h> 
#import "MMKConstants.h"
#import "AppDelegate.h"

@interface RegisteredBusinessLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *alreadyRegisteredUsernameField;

@property (strong, nonatomic) IBOutlet UITextField *alreadyRegisteredBusinessPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *alreadyRegisteredBusinessLoginButton;

@property (strong, nonatomic) IBOutlet UIButton *StartNewRegistrationButton;

@end

@implementation RegisteredBusinessLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)alreadyRegisteredBusinessLoginButtonPressed:(UIButton *)sender {
    
    [PFUser logInWithUsernameInBackground:_alreadyRegisteredUsernameField.text password:_alreadyRegisteredBusinessPasswordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"User Login!");
            [self performSegueWithIdentifier:@"existingMemberToEditJobPostingSegue" sender:self];
        }
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"Your Password and/or Username is not recognized" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
            [alert show];
        }
     }];
}

- (IBAction)startNewRegistrationButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"toNewRegistrationSegue" sender:self];
}



@end
