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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bussinessLogoutButtonPressed:(UIButton *)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"businessLogoutToMainScreenSegue" sender:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)updateJobPostingButtonPressed:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"businessSettingsToUpdateBusinessJobPostingSegue" sender:nil];
}


- (IBAction)UpdateBusinessInformationButtonPressed:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"businessSettingsToUpdateBusinessInformationSegue" sender:nil];
}


@end
