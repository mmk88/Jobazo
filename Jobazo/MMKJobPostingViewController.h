//
//  MMKJobPostingViewController.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <UIKit/UIKit.h>

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
