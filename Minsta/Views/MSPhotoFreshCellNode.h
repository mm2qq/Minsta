//
//  MSPhotoFreshCellNode.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSPhoto;
@protocol MSPhotoFreshCellDelegate;

@interface MSPhotoFreshCellNode : ASCellNode

@property (nonatomic, weak) id<MSPhotoFreshCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPhoto:(MSPhoto *)photo shouldCropped:(BOOL)cropped NS_DESIGNATED_INITIALIZER;

@end

@protocol MSPhotoFreshCellDelegate <NSObject>

@optional

- (void)cellNode:(MSPhotoFreshCellNode *)cellNode didTappedPhotoNode:(ASNetworkImageNode *)photoNode;

@end

NS_ASSUME_NONNULL_END
