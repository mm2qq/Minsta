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

@property (nonatomic, strong) MSPhoto *photo;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;

@end

@implementation MSPhotoFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        _photo = photo;

        [self _setupSubnodes];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *verticalStack = [ASStackLayoutSpec verticalStackLayoutSpec];

    if (_photoNode) {
        // vertical stack
        CGFloat cellWidth = constrainedSize.max.width;
        _photoNode.preferredFrameSize = CGSizeMake(cellWidth, cellWidth);  // constrain photo frame size
        verticalStack.alignItems = ASStackLayoutAlignItemsStretch;    // stretch headerStack to fill horizontal space
        [verticalStack setChildren:@[_photoNode]];
    }

    return verticalStack;
}

#pragma mark - ASNetworkImageNodeDelegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    // layout if image node load image
    [self setNeedsLayout];
}

#pragma mark - ASTextNodeDelegate

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *photoUrlString = _photo.images[0][@"url"];

    if (_photo && ![@"" isEqualToString:photoUrlString]) {
        _photoNode = [ASNetworkImageNode new];
        _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _photoNode.URL = [NSURL URLWithString:photoUrlString];

        [self addSubnode:_photoNode];
    }
}

@end
