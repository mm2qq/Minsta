//
//  MSPhoto.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhoto.h"
#import "MSUser.h"

@implementation MSImage

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];

	if (self && [dict isKindOfClass:[NSDictionary class]]) {
		_sizeId = [[self objectOrNilForKey:@"size" fromDictionary:dict] unsignedIntegerValue];
		_format = [self objectOrNilForKey:@"format" fromDictionary:dict];
		_httpsUrl = [self objectOrNilForKey:@"https_url" fromDictionary:dict];
		_url = [self objectOrNilForKey:@"url" fromDictionary:dict];
	}

	return self;
}

@end

@implementation MSPhoto

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];

	if (self && [dict isKindOfClass:[NSDictionary class]]) {
		_photoId = [[self objectOrNilForKey:@"id" fromDictionary:dict] unsignedIntegerValue];
		_photoName = [self objectOrNilForKey:@"name" fromDictionary:dict];
		_photoDescription = [self objectOrNilForKey:@"description" fromDictionary:dict];
		_camera = [self objectOrNilForKey:@"camera" fromDictionary:dict];
		_lens = [self objectOrNilForKey:@"lens" fromDictionary:dict];
		_focalLength = [self objectOrNilForKey:@"focal_length" fromDictionary:dict];
		_iso = [self objectOrNilForKey:@"iso" fromDictionary:dict];
		_shutterSpeed = [self objectOrNilForKey:@"shutter_speed" fromDictionary:dict];
		_aperture = [self objectOrNilForKey:@"aperture" fromDictionary:dict];
		_timeViewed = [[self objectOrNilForKey:@"time_viewed" fromDictionary:dict] unsignedIntegerValue];
		_rating = [[self objectOrNilForKey:@"rating" fromDictionary:dict] floatValue];
		_status = [[self objectOrNilForKey:@"status" fromDictionary:dict] unsignedIntegerValue];
		_createdAt = [self objectOrNilForKey:@"created_at" fromDictionary:dict];
		_category = [[self objectOrNilForKey:@"category" fromDictionary:dict] unsignedIntegerValue];
		_location = [self objectOrNilForKey:@"location" fromDictionary:dict];
		_privacy = [[self objectOrNilForKey:@"privacy" fromDictionary:dict] boolValue];
		_latitude = [[self objectOrNilForKey:@"latitude" fromDictionary:dict] floatValue];
		_longitude = [[self objectOrNilForKey:@"longitude" fromDictionary:dict] floatValue];
		_takenAt = [self objectOrNilForKey:@"taken_at" fromDictionary:dict];
		_forSale = [[self objectOrNilForKey:@"for_sale" fromDictionary:dict] boolValue];
		_width = [[self objectOrNilForKey:@"width" fromDictionary:dict] unsignedIntegerValue];
		_height = [[self objectOrNilForKey:@"height" fromDictionary:dict] unsignedIntegerValue];
		_votesCount = [[self objectOrNilForKey:@"votes_count" fromDictionary:dict] unsignedIntegerValue];
		_commentsCount = [[self objectOrNilForKey:@"comments_count" fromDictionary:dict] unsignedIntegerValue];
		_nsfw = [[self objectOrNilForKey:@"nsfw" fromDictionary:dict] boolValue];
		_salesCount = [[self objectOrNilForKey:@"sales_count" fromDictionary:dict] unsignedIntegerValue];
		_hightestRating = [[self objectOrNilForKey:@"hightest_rating" fromDictionary:dict] floatValue];
		_hightestRatingDate = [self objectOrNilForKey:@"hightest_rating_date" fromDictionary:dict];
		_licenseType = [[self objectOrNilForKey:@"license_type" fromDictionary:dict] unsignedIntegerValue];
		_user = [MSUser modelObjectWithDictionary:[self objectOrNilForKey:@"user" fromDictionary:dict]];
		_storeDownload = [[self objectOrNilForKey:@"store_download" fromDictionary:dict] boolValue];
		_storePrint = [[self objectOrNilForKey:@"store_print" fromDictionary:dict] boolValue];
		_editorsChoice = [[self objectOrNilForKey:@"editors_choice" fromDictionary:dict] boolValue];
		_feature = [self objectOrNilForKey:@"feature" fromDictionary:dict];
		_galleriesCount = [[self objectOrNilForKey:@"galleries_count" fromDictionary:dict] unsignedIntegerValue];
		_voted = [[self objectOrNilForKey:@"voted" fromDictionary:dict] boolValue];
		_purchased = [[self objectOrNilForKey:@"purchased" fromDictionary:dict] boolValue];
		NSArray *images = [self objectOrNilForKey:@"images" fromDictionary:dict];
		NSMutableArray *newImages = [NSMutableArray arrayWithCapacity:images.count];

		for (NSDictionary *imageDict in images) {
			MSImage *image = [MSImage modelObjectWithDictionary:imageDict];
			if (!image) continue;
			[newImages addObject:image];
		}

		_images = newImages;
	}

	return self;
}

@end
