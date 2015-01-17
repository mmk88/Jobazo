//
//  MMKBusinessMessageData.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSMessage.h"
#import "JSMessageData.h"

@interface MMKBusinessMessageData : NSObject <JSMessageData>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *sender;

@property (strong, nonatomic) NSString *text;


@end
