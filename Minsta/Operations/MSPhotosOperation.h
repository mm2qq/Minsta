//
//  MSPhotosOperation.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSBaseOperation.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSPhotosOperation : MSBaseOperation <MSOperationProtocol>

+ (instancetype)sharedInstance;

/**
 *  Retrieve fresh photos in today
 *
 *  @param imageSize Image size array
 *  @param page      Page numbering is 1-based
 *  @param pageSize  Page size, can not be over 100, default 20
 *  @param callback  Callback handler
 *
 *  @return Current task identifier
 */
- (NSUInteger)retrieveFreshPhotosWithImageSizes:(NSArray *)imageSizes
                                         atPage:(NSUInteger)page
                                       pageSize:(NSUInteger)pageSize
                                     completion:(nullable MSOperationCompletionCallback)callback;

/**
 *  Retrieve user friends' latest photos
 *
 *  @param userId    User identifier
 *  @param imageSize Image size array
 *  @param page      Page numbering is 1-based
 *  @param pageSize  Page size, can not be over 100, default 20
 *  @param callback  Callback handler
 *
 *  @return Current task identifier
 */
- (NSUInteger)retrieveFriendsPhotosWithUserId:(NSUInteger)userId
                                   imageSizes:(NSArray *)imageSizes
                                       atPage:(NSUInteger)page
                                     pageSize:(NSUInteger)pageSize
                                   completion:(nullable MSOperationCompletionCallback)callback;

/**
 *  Retrieve photo's latest comments
 *
 *  @param photoId  Photo identifier
 *  @param page     Page numbering is 1-based
 *  @param pageSize Page size, can not be over 100, default 20
 *  @param callback Callback handler
 *
 *  @return Current task identifier
 */
- (NSUInteger)retrieveCommentsWithPhotoId:(NSUInteger)photoId
                                   atPage:(NSUInteger)page
                                 pageSize:(NSUInteger)pageSize
                               completion:(nullable MSOperationCompletionCallback)callback;

@end

NS_ASSUME_NONNULL_END
