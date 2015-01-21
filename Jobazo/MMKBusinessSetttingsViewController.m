//
//  MMKBusinessSetttingsViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/22/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKBusinessSetttingsViewController.h"
#import <Parse/Parse.h>

@interface MMKBusinessSetttingsViewController ()

@end

@implementation MMKBusinessSetttingsViewController


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)bussinessLogoutButtonPressed:(UIButton *)sender {
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_LogOut"];
    [mixpanel flush];
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"businessLogoutToMainScreenSegue" sender:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)updateJobPostingButtonPressed:(UIButton *)sender {
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_SettingsToUpdateJobPosting"];
    [mixpanel flush];
    
    [self performSegueWithIdentifier:@"businessSettingsToUpdateBusinessJobPostingSegue" sender:nil];
}


- (IBAction)UpdateBusinessInformationButtonPressed:(UIButton *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Business_SettingsToUpdateBizInfo"];
    [mixpanel flush];
    
    
    [self performSegueWithIdentifier:@"businessSettingsToUpdateBusinessInformationSegue" sender:nil];
}


@end
