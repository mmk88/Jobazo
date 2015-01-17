//
//  MMKMessageData.h
//  Jobazo
//
//  Created by Kai Aichholz on 11/23/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSMessageData.h"



@interface MMKMessageData : NSObject <JSMessageData>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *sender;

@property (strong, nonatomic) NSString *text;

@end
