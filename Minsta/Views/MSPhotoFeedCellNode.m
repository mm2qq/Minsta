//
//  MSPhotoFeedCellNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoFeedCellNode.h"
#import "MSPhoto.h"
#import "MSUser.h"

@interface MSPhotoFeedCellNode () <ASNetworkImageNodeDelegate, ASTextNodeDelegate>

@end

@implementation MSPhotoFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {

    }

    return self;
}

//- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
//
//}

#pragma mark - ASNetworkImageNodeDelegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    // layout if image node load image
    [self setNeedsLayout];
}

#pragma mark - ASTextNodeDelegate

#pragma mark - Private

@end
