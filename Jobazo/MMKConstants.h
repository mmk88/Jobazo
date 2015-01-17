//
//  MMKConstants.h
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMKConstants : NSObject

#pragma mark - User Class

extern NSString *const kMMKUserTagLineKey; //324 ... this needs to be used to add more stuff for the user//

extern NSString *const kMMKUserEmployerJob1Key;
extern NSString *const kMMKUserPositionJob1Key;
extern NSString *const kMMKUserDuationJob1Key;

extern NSString *const kMMKUserEmployerJob2Key;
extern NSString *const kMMKUserPositionJob2Key;
extern NSString *const kMMKUserDuationJob2Key;

extern NSString *const kMMKUserSkill1;
extern NSString *const kMMKUserSkill2;
extern NSString *const kMMKUserSkill3;
extern NSString *const kMMKUserSkill4;
extern NSString *const kMMKUserSkill5;
extern NSString *const kMMKUserSkill6;

extern NSString *const kMMKUserProfileKey;
extern NSString *const kMMKUserProfileNameKey;
extern NSString *const kMMKUserProfileFirstNameKey;
extern NSString *const kMMKUserProfileLocationKey;
extern NSString *const kMMKUserProfileGenderKey;
extern NSString *const kMMKUserProfileBirthdayKey;
extern NSString *const kMMKUserProfileInterestedInKey;
extern NSString *const kMMKUserProfilePictureURL;
extern NSString *const kMMKUserProfileRelationshopStatusKey;
extern NSString *const kMMKUserProfileAgeKey;

extern NSString *const kMMKUserWorkCity;
extern NSString *const kMMKUserWorkZip;
extern NSString *const kMMKUserPhoneNumber;
extern NSString *const kMMKUserEmail;

extern NSString *const kMMKBusinessIndicator;

#pragma mark - Photo Class

extern NSString *const kMMKPhotoClassKey;
extern NSString *const kMMKPhotoUserKey;
extern NSString *const kMMKPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const kMMKActivityClassKey;
extern NSString *const kMMKActivityTypeKey;
extern NSString *const kMMKActivitiyFromUserKey;
extern NSString *const kMMKActivityToUserKey;
extern NSString *const kMMKActivityPhotoKey;
extern NSString *const kMMKActivityTypeLikeKey;
extern NSString *const kMMKActivityTypeDislikeKey;

#pragma mark - Settings

//328

//extern NSString *const kMMKMenEnabledKey;
//extern NSString *const kMMKWomenEnabledKey;
extern NSString *const kMMKActiveEnabledKey;
extern NSString *const kMMKWageMinKey;
extern NSString *const kMMKActivityTracker;

#pragma mark - ChatRoom

extern NSString *const kMMKChatRoomClassKey;
extern NSString *const kMMKChatRoomUser1Key;
extern NSString *const kMMKChatRoomUser2Key;

#pragma mark - Chat

extern NSString *const kMMKChatClassKey;
extern NSString *const kMMKChatChatroomKey;
extern NSString *const kMMKChatFromUserKey;
extern NSString *const kMMKChatToUserKey;
extern NSString *const kMMKChatTextKey;

#pragma mark - Business Information

extern NSString *const kMMKBusinessNameKey;
extern NSString *const kMMKBusinessTypeKey;
extern NSString *const kMMKBusinessWebsiteKey;
extern NSString *const kMMKBusinessPhoneNumberKey;
extern NSString *const kMMKBusinessAddressLine1Key;
extern NSString *const kMMKBusinessAddressLine2Key;
extern NSString *const kMMKBusinessAddressCityKey;
extern NSString *const kMMKBusinessZipCodeKey;

#pragma mark - Job Posting

extern NSString *const kMMKJobStartDateKey;
extern NSString *const kMMKJobEndDateKey;
extern NSString *const kMMKJobPostingKey;
extern NSString *const kMMKJobHourlyPayKey;
extern NSString *const kMMKBriefJobDescriptionKey;
extern NSString *const kMMKHoursOfWorkKey;

@end
