//
//  MSPhotoFeed.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSPhotoFeed : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;       ///< The count of photos in current page

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrameSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

- (nullable MSPhoto *)photoAtIndex:(NSUInteger)index;
- (void)resetAllPhotos;
- (void)fetchPhotosOnCompletion:(nullable void (^)(NSArray<MSPhoto *> *))callback pageSize:(NSUInteger)size;
- (void)refreshPhotosOnCompletion:(nullable void (^)(NSArray<MSPhoto *> *))callback pageSize:(NSUInteger)size;

@end

NS_ASSUME_NONNULL_END
