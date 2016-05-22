//
//  MSPhotoFeedCellNode.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSPhoto;
@protocol MSPhotoFeedCellDelegate;

@interface MSPhotoFeedCellNode : ASCellNode

@property (nonatomic, weak) id<MSPhotoFeedCellDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPhoto:(MSPhoto *)photo NS_DESIGNATED_INITIALIZER;

@end

@protocol MSPhotoFeedCellDelegate <NSObject>

@optional

- (void)cellNode:(MSPhotoFeedCellNode *)cellNode didTappedPhotoNode:(ASNetworkImageNode *)photoNode;

@end

NS_ASSUME_NONNULL_END
