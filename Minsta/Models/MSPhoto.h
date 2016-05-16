//
//  MSPhoto.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSUser;

@interface MSImage : MSModel <MSModelProtocol>

@property (nonatomic, assign, readonly) NSUInteger sizeId;
@property (nonatomic, copy, readonly) NSString *format;
@property (nonatomic, copy, readonly) NSString *httpsUrl;
@property (nonatomic, copy, readonly) NSString *url;

@end

@interface MSPhoto : MSModel <MSModelProtocol>

@property (nonatomic, assign, readonly) NSUInteger photoId;
@property (nonatomic, copy, readonly) NSString *photoName;
@property (nonatomic, copy, readonly) NSString *photoDescription;
@property (nonatomic, copy, readonly) NSString *camera;
@property (nonatomic, copy, readonly) NSString *lens;
@property (nonatomic, copy, readonly) NSString *focalLength;
@property (nonatomic, copy, readonly) NSString *iso;
@property (nonatomic, copy, readonly) NSString *shutterSpeed;
@property (nonatomic, copy, readonly) NSString *aperture;
@property (nonatomic, assign, readonly) NSUInteger timeViewed;
@property (nonatomic, assign, readonly) CGFloat rating;
@property (nonatomic, assign, readonly) NSUInteger status;
@property (nonatomic, copy, readonly) NSString *createdAt;
@property (nonatomic, assign, readonly) NSUInteger category;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, assign, readonly) BOOL privacy;
@property (nonatomic, assign, readonly) CGFloat latitude;
@property (nonatomic, assign, readonly) CGFloat longitude;
@property (nonatomic, copy, readonly) NSString *takenAt;
@property (nonatomic, assign, readonly) BOOL forSale;
@property (nonatomic, assign, readonly) NSUInteger width;
@property (nonatomic, assign, readonly) NSUInteger height;
@property (nonatomic, assign, readonly) NSUInteger votesCount;
@property (nonatomic, assign, readonly) NSUInteger commentsCount;
@property (nonatomic, assign, readonly) BOOL nsfw;
@property (nonatomic, assign, readonly) NSUInteger salesCount;
@property (nonatomic, assign, readonly) CGFloat hightestRating;
@property (nonatomic, copy, readonly) NSString *hightestRatingDate;
@property (nonatomic, assign, readonly) NSUInteger licenseType;
@property (nonatomic, copy, readonly) NSMutableArray<MSImage *> *images;
@property (nonatomic, strong, readonly) MSUser *user;
@property (nonatomic, copy, readonly) NSArray *comments;
@property (nonatomic, assign, readonly) BOOL storeDownload;
@property (nonatomic, assign, readonly) BOOL storePrint;
@property (nonatomic, assign, readonly) BOOL editorsChoice;
@property (nonatomic, copy, readonly) NSString *feature;
@property (nonatomic, assign, readonly) NSUInteger galleriesCount;

// authenticated property

@property (nonatomic, assign, readonly) BOOL voted;
@property (nonatomic, assign, readonly) BOOL purchased;

@end

NS_ASSUME_NONNULL_END
