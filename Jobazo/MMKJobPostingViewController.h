//
//  MMKJobPostingViewController.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mixpanel.h>
#define MIXPANEL_TOKEN @"4c051590a5a3568ec9227f64a282d274"

int countMonth;
int countDays;
int countHour;
int countMin;
int countSecond;

int countMonthTemp;
int countDaysTemp;
int countHourTemp;
int countMinTemp;
int countSecTemp;


@interface MMKJobPostingViewController : UIViewController {

NSTimer *timer;

}

- (void)TimerCount;

@end
