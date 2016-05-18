//
//  MSComment.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MSUser;

@interface MSComment : MSBaseModel <MSModelProtocol>

@property (nonatomic, assign, readonly) NSUInteger commentId;
@property (nonatomic, assign, readonly) NSUInteger userId;
@property (nonatomic, assign, readonly) NSUInteger toWhomUserId;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, copy, readonly) NSString *createdAt;
@property (nonatomic, assign, readonly) NSUInteger parentId;
@property (nonatomic, strong, readonly) MSUser *user;
@property (nonatomic, copy, readonly) NSArray<MSComment *> *replies;

@end

NS_ASSUME_NONNULL_END
