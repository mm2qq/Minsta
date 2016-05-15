//
//  MSUser.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MSUserGender) {
    MSUserGenderUnspecified,
    MSUserGenderMale,
    MSUserGenderFemale,
};

@interface MSUser : NSObject

@property (nonatomic, assign, readonly) NSUInteger userId;
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, assign, readonly) MSUserGender gender;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, copy, readonly) NSString *registrationDate;
@property (nonatomic, copy, readonly) NSString *about;
@property (nonatomic, copy, readonly) NSString *domain;
@property (nonatomic, copy, readonly) NSString *locale;
@property (nonatomic, assign, readonly) NSUInteger upgradeStatus;
@property (nonatomic, assign, readonly) BOOL showNude;
@property (nonatomic, copy, readonly) NSString *userPicUrl;
@property (nonatomic, assign, readonly) BOOL storeOn;
@property (nonatomic, copy, readonly) NSDictionary *contacts;
@property (nonatomic, copy, readonly) NSDictionary *equipment;
@property (nonatomic, assign, readonly) NSUInteger photosCount;
@property (nonatomic, assign, readonly) NSUInteger galleriesCount;
@property (nonatomic, assign, readonly) NSUInteger affection;
@property (nonatomic, assign, readonly) NSUInteger friendsCount;
@property (nonatomic, assign, readonly) NSUInteger followersCount;
@property (nonatomic, assign, readonly) BOOL admin;
@property (nonatomic, copy, readonly) NSDictionary *avatars;

// authenticated property

@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, assign, readonly) NSUInteger uploadLimit;
@property (nonatomic, copy, readonly) NSString *uploadLimitExpiry;
@property (nonatomic, copy, readonly) NSString *upgradeExpiryDate;
@property (nonatomic, copy, readonly) NSDictionary *auth;
@property (nonatomic, assign, readonly) BOOL following;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
