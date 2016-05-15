//
//  MSHomeOperation.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSBaseOperation.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSHomeOperation : MSBaseOperation

+ (instancetype)sharedInstance;

/**
 *  Retrieve user friends' photo feeds
 *
 *  @param userId    User identifier
 *  @param imageSize Image size
 *  @param page      Page numbering is 1-based
 *  @param pageSize  Page size, can not be over 100, default 20
 *  @param callback  Call handler
 */
- (void)retrievePhotosWithUserId:(NSUInteger)userId
                       imageSize:(CGSize)imageSize
                          atPage:(NSUInteger)page
                        pageSize:(NSUInteger)pageSize
                      completion:(nullable MSCompletionCallback)callback;

@end

NS_ASSUME_NONNULL_END
