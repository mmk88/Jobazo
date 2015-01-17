//
//  MMKProfileViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKProfileViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>


@interface MMKProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *profileLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill1Label;
@property (strong, nonatomic) IBOutlet UILabel *workZipLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill2Label;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill3Label;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill4Label;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill5Label;
@property (strong, nonatomic) IBOutlet UILabel *profileSkill6Label;

@end

@implementation MMKProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    //327
    
    NSLog(@"A");
    
    PFFile *pictureFile = self.photo[kMMKPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    NSLog(@"B");
    
    PFUser *user = self.photo[kMMKPhotoUserKey];
    NSLog(@"%@",user);
    self.profileLocationLabel.text  = user[kMMKUserWorkCity];
    self.workZipLabel.text = user[kMMKUserWorkZip];
    
    self.profileSkill1Label.text = user[kMMKUserSkill1];
    self.profileSkill2Label.text = user[kMMKUserSkill2];
    self.profileSkill3Label.text = user[kMMKUserSkill3];
    self.profileSkill4Label.text = user[kMMKUserSkill4];
    self.profileSkill5Label.text = user[kMMKUserSkill5];
    self.profileSkill6Label.text = user[kMMKUserSkill6];
    
    NSLog(@"D");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
