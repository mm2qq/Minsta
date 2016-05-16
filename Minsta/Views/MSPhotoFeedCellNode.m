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
#import "MinstaMacro.h"

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
    ASRatioLayoutSpec *ratioLayout = nil;

    if (_photoNode) {
        ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:MS_HOME_PHOTO_RATIO child:_photoNode];
    }

    return ratioLayout;
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
