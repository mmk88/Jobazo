//
//  MMKConstants.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/4/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKConstants.h"

@implementation MMKConstants

#pragma mark - User Class

NSString *const kMMKUserTagLineKey                = @"tagLine"; //324... Need to do to add more

NSString *const kMMKUserEmployerJob1Key           = @"employerJob1";
NSString *const kMMKUserPositionJob1Key           = @"positionJob1";
NSString *const kMMKUserDuationJob1Key            = @"durationJob1";

NSString *const kMMKUserEmployerJob2Key           = @"employerJob2";
NSString *const kMMKUserPositionJob2Key           = @"positionJob2";
NSString *const kMMKUserDuationJob2Key            = @"durationJob2";

NSString *const kMMKUserSkill1                    = @"skill1";
NSString *const kMMKUserSkill2                    = @"skill2";
NSString *const kMMKUserSkill3                    = @"skill3";
NSString *const kMMKUserSkill4                    = @"skill4";
NSString *const kMMKUserSkill5                    = @"skill5";
NSString *const kMMKUserSkill6                    = @"skill6";

NSString *const kMMKUserWorkCity                  = @"workCity";
NSString *const kMMKUserWorkZip                   = @"workZip";
NSString *const kMMKUserPhoneNumber               =@"phoneNumber";
NSString *const kMMKUserEmail                     =@"email";

NSString *const kMMKUserProfileKey                = @"profile";
NSString *const kMMKUserProfileNameKey            = @"name";
NSString *const kMMKUserProfileFirstNameKey       = @"firstName";
NSString *const kMMKUserProfileLocationKey        = @"location";
NSString *const kMMKUserProfileGenderKey          = @"gender";
NSString *const kMMKUserProfileBirthdayKey        = @"birthday";
NSString *const kMMKUserProfileInterestedInKey    = @"interestedIn";
NSString *const kMMKUserProfilePictureURL         = @"pictureURL";
NSString *const kMMKUserProfileRelationshopStatusKey =@"relationshipStatus";
NSString *const kMMKUserProfileAgeKey             = @"age";

NSString *const kMMKBusinessIndicator             = @"BusinessIndicator";

#pragma mark - Photo Class

NSString *const kMMKPhotoClassKey                 = @"Photo";
NSString *const kMMKPhotoUserKey                  = @"user";
NSString *const kMMKPhotoPictureKey               = @"image";

#pragma mark - Activity Class

NSString *const kMMKActivityClassKey              = @"Activity";
NSString *const kMMKActivityTypeKey               = @"type";
NSString *const kMMKActivitiyFromUserKey          = @"fromUser";
NSString *const kMMKActivityToUserKey             = @"toUser";
NSString *const kMMKActivityPhotoKey              = @"photo";
NSString *const kMMKActivityTypeLikeKey           = @"like";
NSString *const kMMKActivityTypeDislikeKey        = @"dislike";

#pragma mark - Settings

//328

//NSString *const kMMKMenEnabledKey                 =@"men";
//NSString *const kMMKWomenEnabledKey               =@"women";
NSString *const kMMKActiveEnabledKey              =@"active";
NSString *const kMMKWageMinKey                    =@"wageMin";
NSString *const kMMKActivityTracker               =@"activityTracking";

#pragma mark - ChatRoom

NSString *const kMMKChatRoomClassKey             = @"ChatRoom";
NSString *const kMMKChatRoomUser1Key             = @"user1";
NSString *const kMMKChatRoomUser2Key             = @"user2";

#pragma mark - Chat

NSString *const kMMKChatClassKey                 = @"Chat";
NSString *const kMMKChatChatroomKey              = @"chatroom";
NSString *const kMMKChatFromUserKey              = @"fromUser";
NSString *const kMMKChatToUserKey                = @"toUser";
NSString *const kMMKChatTextKey                  = @"text";

#pragma mark - Business Information

NSString *const kMMKBusinessNameKey              = @"BusinessName";
NSString *const kMMKBusinessTypeKey              = @"BusinessType";
NSString *const kMMKBusinessWebsiteKey           = @"BusinessWebsite";
NSString *const kMMKBusinessPhoneNumberKey       = @"BusinessPhoneNumber";
NSString *const kMMKBusinessAddressLine1Key      = @"BusinessAddressLine1";
NSString *const kMMKBusinessAddressLine2Key      = @"BusinessAddressLine2";
NSString *const kMMKBusinessAddressCityKey       = @"BusinessAddressCity";
NSString *const kMMKBusinessZipCodeKey           = @"BusinessAddressZipCode";



#pragma mark - Job Posting

NSString *const kMMKJobStartDateKey              = @"JobStartDate";
NSString *const kMMKJobEndDateKey                = @"JobEndDate";
NSString *const kMMKJobPostingKey                = @"JobPosting";
NSString *const kMMKJobHourlyPayKey              = @"JobHourlyPay";
NSString *const kMMKBriefJobDescriptionKey       = @"JobDescription";
NSString *const kMMKHoursOfWorkKey               = @"HoursOfWork";

@end
