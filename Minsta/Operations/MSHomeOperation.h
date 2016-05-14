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
 *  Retrieve user friends' photos
 *
 *  @param userId   User identifier
 *  @param size     Photo size
 *  @param page     Page numbering is 1-based
 *  @param callback Completion handler
 */
- (void)retrievePhotosWithUserId:(NSUInteger)userId
                       imageSize:(CGSize)size
                          atPage:(NSUInteger)page
                      completion:(nullable MSCompletionCallback)callback;

@end

NS_ASSUME_NONNULL_END
