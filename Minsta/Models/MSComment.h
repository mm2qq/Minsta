//
//  MSComment.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSUser;

NS_ASSUME_NONNULL_BEGIN

@interface MSComment : NSObject

@property (nonatomic, assign, readonly) NSUInteger commentId;
@property (nonatomic, assign, readonly) NSUInteger userId;
@property (nonatomic, assign, readonly) NSUInteger toWhomUserId;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, copy, readonly) NSString *createdAt;
@property (nonatomic, assign, readonly) NSUInteger parentId;
@property (nonatomic, strong, readonly) MSUser *user;
@property (nonatomic, copy, readonly) NSMutableArray<MSComment *> *replies;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
