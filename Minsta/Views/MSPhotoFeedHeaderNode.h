//
//  MSPhotoFeedHeaderNode.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSPhoto;

@interface MSPhotoFeedHeaderNode : ASDisplayNode

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame photo:(MSPhoto *)photo NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
