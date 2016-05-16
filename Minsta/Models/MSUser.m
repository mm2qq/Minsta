//
//  MSUser.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSUser.h"

@implementation MSUser

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _userId = [[self objectOrNilForKey:@"id" fromDictionary:dict] unsignedIntegerValue];
        _userName = [self objectOrNilForKey:@"username" fromDictionary:dict];
        _firstName = [self objectOrNilForKey:@"firstname" fromDictionary:dict];
        _lastName = [self objectOrNilForKey:@"lastname" fromDictionary:dict];
        _fullName = [self objectOrNilForKey:@"fullname" fromDictionary:dict];
        _gender = [[self objectOrNilForKey:@"sex" fromDictionary:dict] unsignedIntegerValue];
        _city = [self objectOrNilForKey:@"city" fromDictionary:dict];
        _state = [self objectOrNilForKey:@"state" fromDictionary:dict];
        _country = [self objectOrNilForKey:@"country" fromDictionary:dict];
        _registrationDate = [self objectOrNilForKey:@"registration_date" fromDictionary:dict];
        _about = [self objectOrNilForKey:@"about" fromDictionary:dict];
        _domain = [self objectOrNilForKey:@"domain" fromDictionary:dict];
        _locale = [self objectOrNilForKey:@"locale" fromDictionary:dict];
        _upgradeStatus = [[self objectOrNilForKey:@"upgrade_status" fromDictionary:dict] unsignedIntegerValue];
        _showNude = [[self objectOrNilForKey:@"show_nude" fromDictionary:dict] boolValue];
        _userPicUrl = [self objectOrNilForKey:@"userpic_url" fromDictionary:dict];
        _storeOn = [[self objectOrNilForKey:@"store_on" fromDictionary:dict] boolValue];
        _contacts = [self objectOrNilForKey:@"contacts" fromDictionary:dict];
        _equipment = [self objectOrNilForKey:@"equipment" fromDictionary:dict];
        _photosCount = [[self objectOrNilForKey:@"photos_count" fromDictionary:dict] unsignedIntegerValue];
        _galleriesCount = [[self objectOrNilForKey:@"galleries_count" fromDictionary:dict] unsignedIntegerValue];
        _affection = [[self objectOrNilForKey:@"affection" fromDictionary:dict] unsignedIntegerValue];
        _friendsCount = [[self objectOrNilForKey:@"friends_count" fromDictionary:dict] unsignedIntegerValue];
        _followersCount = [[self objectOrNilForKey:@"followers_count" fromDictionary:dict] unsignedIntegerValue];
        _admin = [[self objectOrNilForKey:@"admin" fromDictionary:dict] boolValue];
        _avatars = [self objectOrNilForKey:@"avatars" fromDictionary:dict];
        _email = [self objectOrNilForKey:@"email" fromDictionary:dict];
        _uploadLimit = [[self objectOrNilForKey:@"upload_limit" fromDictionary:dict] unsignedIntegerValue];
        _uploadLimitExpiry = [self objectOrNilForKey:@"upload_limit_expiry" fromDictionary:dict];
        _upgradeExpiryDate = [self objectOrNilForKey:@"upgrade_expiry_date" fromDictionary:dict];
        _auth = [self objectOrNilForKey:@"auth" fromDictionary:dict];
        _following = [[self objectOrNilForKey:@"following" fromDictionary:dict] boolValue];
    }

    return self;
}

@end
