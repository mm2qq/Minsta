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

static const CGFloat kFunctionNodeSizeWidth = 48.f;
static const CGFloat kSeparatorNodeLeadingMargin = 10.f;

@interface MSPhotoFeedCellNode ()

@property (nonatomic, strong) MSPhoto *photo;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASImageNode *likeNode;
@property (nonatomic, strong) ASImageNode *commentNode;
@property (nonatomic, strong) ASImageNode *sendNode;
@property (nonatomic, strong) ASDisplayNode *separatorNode;

@end

@implementation MSPhotoFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _photo = photo;

        [self _setupSubnodes];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    // set subnode preferred size
    _likeNode.preferredFrameSize = (CGSize){kFunctionNodeSizeWidth, kFunctionNodeSizeWidth};
    _commentNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _sendNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _separatorNode.preferredFrameSize = (CGSize){constrainedSize.max.width, 1.f / [UIScreen mainScreen].scale};

    // photo ratio layout
    ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:MS_HOME_PHOTO_RATIO child:_photoNode];

    // horizontal stack layout
    ASStackLayoutSpec *hStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_likeNode, _commentNode, _sendNode]];

    // inset layout
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){0.f, kSeparatorNodeLeadingMargin, 0.f, kSeparatorNodeLeadingMargin} child:_separatorNode];

    // vertical stack layout
    ASStackLayoutSpec *vStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[ratioLayout, hStackLayout, insetLayout]];

    return vStackLayout;
}

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *photoUrlString = _photo.images[0].url;

    if (photoUrlString && ![@"" isEqualToString:photoUrlString]) {
        _photoNode = [ASNetworkImageNode new];
        _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _photoNode.URL = [NSURL URLWithString:photoUrlString];

        _likeNode = [ASImageNode new];
        _likeNode.image = [UIImage imageNamed:@"like"];
        _likeNode.contentMode = UIViewContentModeCenter;
        _likeNode.backgroundColor = self.backgroundColor;

        _commentNode = [ASImageNode new];
        _commentNode.image = [UIImage imageNamed:@"comment"];
        _commentNode.contentMode = UIViewContentModeCenter;
        _commentNode.backgroundColor = self.backgroundColor;

        _sendNode = [ASImageNode new];
        _sendNode.image = [UIImage imageNamed:@"send"];
        _sendNode.contentMode = UIViewContentModeCenter;
        _sendNode.backgroundColor = self.backgroundColor;

        _separatorNode = [ASDisplayNode new];
        _separatorNode.backgroundColor = [UIColor lightGrayColor];

        [self addSubnode:_photoNode];
        [self addSubnode:_likeNode];
        [self addSubnode:_commentNode];
        [self addSubnode:_sendNode];
        [self addSubnode:_separatorNode];
    }
}

@end
