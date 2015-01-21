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

    self.activeSwitch.on =  [[NSUserDefaults standardUserDefaults] boolForKey:kMMKActiveEnabledKey];
    
    [self.wageSlider   addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
   
    [self.activeSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.wageLabel.text = [NSString stringWithFormat:@"%i", (int)self.wageSlider.value];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Employee_LoggedOut"];
    [mixpanel flush];
    
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"UserLogoutSegue" sender:self];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)editProfileButtonPressed:(UIButton *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Employee_EditProfileFromSettings"];
    [mixpanel flush];
    
    [self performSegueWithIdentifier:@"settingsToEditSegue" sender:self];
}


- (IBAction)activeStatus:(UISwitch *)sender {
    
    if(sender.on)
    {
     
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Employee_TurnedOnFind"];
        [mixpanel flush];
        
        PFUser *user = [PFUser currentUser];
        [user setObject:@1 forKey:kMMKActivityTracker];
        [[PFUser currentUser] saveInBackground];
        
    }
    else
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Employee_TurnedOFFFind"];
        [mixpanel flush];
        
        PFUser *user = [PFUser currentUser];
        [user setObject:@0 forKey:kMMKActivityTracker];
        [[PFUser currentUser] saveInBackground];
    }
    
}

- (IBAction)findFriendsButtonPressed:(UIButton *)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Employee_FindFriends"];
    [mixpanel flush];
    
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
    
    else if (sender == self.activeSwitch){
        [[NSUserDefaults standardUserDefaults] setBool:self.activeSwitch.isOn forKey:kMMKActiveEnabledKey];
        
    }

    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Employee_ChangedWage"];
    [mixpanel flush];
}
@end
