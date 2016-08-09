//
//  MSPhotoDisplayNode.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MSPhotoDisplayCompletionCallback)();

@interface MSPhotoDisplayItem : NSObject
@property (nullable, nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSURL *imageUrl;
@end

@interface MSPhotoDisplayNode : ASDisplayNode

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDisplayItems:(NSArray<MSPhotoDisplayItem *> *)items NS_DESIGNATED_INITIALIZER;

- (void)presentView:(UIView *)fromView
        atIndex:(NSUInteger)index
        completion:(nullable MSPhotoDisplayCompletionCallback)callback;

@end

NS_ASSUME_NONNULL_END
