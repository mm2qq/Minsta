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

typedef void (^MSPhotoFeedCompletionCallback)(NSArray<MSPhoto *> *photos);

@interface MSPhotoFeed : NSObject

@property (nonatomic, copy, readonly) NSMutableArray<MSPhoto *> *photos;
@property (nonatomic, assign, readonly) NSUInteger count;       ///< The count of photos in current page

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImageSizes:(NSArray *)sizes NS_DESIGNATED_INITIALIZER;

- (nullable MSPhoto *)photoAtIndex:(NSUInteger)index;
- (void)resetAllPhotos;
- (void)cancelFetch;

/**
 *  Fetch user's friends' photos
 *
 *  @param callback Callback handler
 *  @param size     Page size
 */
- (void)fetchFriendsPhotosOnCompletion:(nullable MSPhotoFeedCompletionCallback)callback pageSize:(NSUInteger)size;

/**
 *  Refresh user's friends' photos
 *
 *  @param callback Callback handler
 *  @param size     Page size
 */
- (void)refreshFriendsPhotosOnCompletion:(nullable MSPhotoFeedCompletionCallback)callback pageSize:(NSUInteger)size;

/**
 *  Fetch today's fresh photos
 *
 *  @param callback Callback handler
 *  @param size     Page size
 */
- (void)fetchFreshPhotosOnCompletion:(nullable MSPhotoFeedCompletionCallback)callback pageSize:(NSUInteger)size;

/**
 *  Refresh today's fresh photos
 *
 *  @param callback Callback handler
 *  @param size     Page size
 */
- (void)refreshFreshPhotosOnCompletion:(nullable MSPhotoFeedCompletionCallback)callback pageSize:(NSUInteger)size;

@end

NS_ASSUME_NONNULL_END
