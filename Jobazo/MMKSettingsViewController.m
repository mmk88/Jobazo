//
//  MMKSettingsViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKSettingsViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h> 


@interface MMKSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISlider *wageSlider;
@property (strong, nonatomic) IBOutlet UILabel *wageLabel;
@property (strong, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UILabel  *ageLabel;
@property (strong, nonatomic) IBOutlet UIButton *updateAvailability;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
//@property (strong, nonatomic) IBOutlet UISwitch *mensSwitch;
//@property (strong, nonatomic) IBOutlet UISwitch *womensSwitch;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityNoLabel;
@property (strong, nonatomic) IBOutlet UIButton *findFriendsButton;


@end

@implementation MMKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //329
    
    self.wageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kMMKWageMinKey];
    //self.mensSwitch.on   =  [[NSUserDefaults standardUserDefaults] boolForKey:kMMKMenEnabledKey];
    //self.womensSwitch.on =  [[NSUserDefaults standardUserDefaults] boolForKey:kMMKWomenEnabledKey];
    self.activeSwitch.on =  [[NSUserDefaults standardUserDefaults] boolForKey:kMMKActiveEnabledKey];
    
    [self.wageSlider   addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.mensSwitch   addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.womensSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.activeSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.wageLabel.text = [NSString stringWithFormat:@"%i", (int)self.wageSlider.value];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"UserLogoutSegue" sender:self];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)editProfileButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settingsToEditSegue" sender:self];
}


- (IBAction)activeStatus:(UISwitch *)sender {
    
    if(sender.on)
    {
     
        PFUser *user = [PFUser currentUser];
        [user setObject:@1 forKey:kMMKActivityTracker];
        [[PFUser currentUser] saveInBackground];
        
    }
    else
    {
        PFUser *user = [PFUser currentUser];
        [user setObject:@0 forKey:kMMKActivityTracker];
        [[PFUser currentUser] saveInBackground];
    }
    
}

- (IBAction)findFriendsButtonPressed:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"SettingsToFindFriendsSegue" sender:self];
}


#pragma mark - Helper

//330

-(void)valueChanged:(id)sender
{
    if(sender ==self.wageSlider){
        [[NSUserDefaults standardUserDefaults] setInteger:self.wageSlider.value forKey:kMMKWageMinKey];
        self.wageLabel.text = [NSString stringWithFormat:@"%i",(int)self.wageSlider.value];
    }
    
    //else if (sender ==self.mensSwitch){
    //    [[NSUserDefaults standardUserDefaults] setBool:self.mensSwitch.isOn forKey:kMMKMenEnabledKey];
        
    //}
    //else if (sender == self.womensSwitch){
    //    [[NSUserDefaults standardUserDefaults] setBool:self.womensSwitch.isOn forKey:kMMKWomenEnabledKey];
    //}
    
    else if (sender == self.activeSwitch){
        [[NSUserDefaults standardUserDefaults] setBool:self.activeSwitch.isOn forKey:kMMKActiveEnabledKey];
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
