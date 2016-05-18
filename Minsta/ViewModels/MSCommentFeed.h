//
//  MSCommentFeed.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSCommentFeed : NSObject

@property (nonatomic, assign, readonly) NSUInteger totalCount;  ///< Total count of comments
@property (nonatomic, assign, readonly) NSUInteger count;       ///< The count of comments in current page

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPhotoId:(NSUInteger)photoId NS_DESIGNATED_INITIALIZER;

- (nullable MSComment *)commentAtIndex:(NSUInteger)index;
- (void)resetAllComments;
- (void)fetchCommentsOnCompletion:(nullable void (^)(NSArray<MSComment *> *))callback pageSize:(NSUInteger)size;
- (void)refreshCommentsOnCompletion:(nullable void (^)(NSArray<MSComment *> *))callback pageSize:(NSUInteger)size;

@end

NS_ASSUME_NONNULL_END
