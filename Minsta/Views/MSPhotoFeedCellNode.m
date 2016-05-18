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
#import "MSCommentFeed.h"
#import "MinstaMacro.h"
#import "NSString+MinstaAdd.h"
#import "ASControlNode+MinstaAdd.h"

static const CGFloat kFunctionNodeSizeWidth = 48.f;
static const CGFloat kSeparatorNodeLeadingMargin = 15.f;
static const CGFloat kSymbolNodeSizeWidth = 12.f;
static const NSUInteger kPhotoFeedCommentPageSize = 2;
static const NSUInteger kPhotoFeedCommentMaxLines = 3;

static NSAttributedString * formatCommentString(NSString *string) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : MS_FEED_REGULAR_FONT}];
    NSRange range = NSMakeRange(0, [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location);
    // set user name to bold
    [attributedString setAttributes:@{NSFontAttributeName : MS_FEED_BOLD_FONT} range:range];
    return attributedString;
}

@interface MSPhotoFeedCellNode ()

@property (nonatomic, strong) MSPhoto *photo;
@property (nonatomic, strong) MSCommentFeed *commentFeed;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASImageNode *likeNode;
@property (nonatomic, strong) ASImageNode *commentNode;
@property (nonatomic, strong) ASImageNode *sendNode;
@property (nonatomic, strong) ASDisplayNode *separatorNode;
@property (nonatomic, strong) ASImageNode *likeMeNode;
@property (nonatomic, strong) ASTextNode *votesNode;
@property (nonatomic, strong) ASTextNode *descriptionNode;
@property (nonatomic, strong) ASTextNode *commentHintNode;
@property (nonatomic, copy) NSArray<ASTextNode *> *commentTextNodes;

@end

@implementation MSPhotoFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        self.backgroundColor = MS_WIHTE_BACKGROUND_COLOR;

        _photo = photo;
        if (_photo.commentsCount > 0) {
            _commentFeed = [[MSCommentFeed alloc] initWithPhotoId:_photo.photoId];
        }

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    CGFloat votesNodeWidth = [_votesNode.attributedText.string widthForFont:MS_FEED_BOLD_FONT];
    CGFloat votesNodeHeight = [_votesNode.attributedText.string heightForFont:MS_FEED_BOLD_FONT width:votesNodeWidth];

    // set subnode preferred size
    _likeNode.preferredFrameSize = (CGSize){kFunctionNodeSizeWidth, kFunctionNodeSizeWidth};
    _commentNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _sendNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _separatorNode.preferredFrameSize = (CGSize){constrainedSize.max.width, 1.f / [UIScreen mainScreen].scale};
    _likeMeNode.preferredFrameSize = (CGSize){kSymbolNodeSizeWidth, kSymbolNodeSizeWidth};
    _votesNode.preferredFrameSize = (CGSize){votesNodeWidth, votesNodeHeight};

    // photo ratio layout
    ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:MS_HOME_PHOTO_RATIO child:_photoNode];

    // function node horizontal stack layout
    ASStackLayoutSpec *fhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_likeNode, _commentNode, _sendNode]];

    // separator inset layout
    ASInsetLayoutSpec *sInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){0.f, kSeparatorNodeLeadingMargin, 0.f, kSeparatorNodeLeadingMargin} child:_separatorNode];

    // votes node horizontal stack layout
    ASStackLayoutSpec *vhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:kSeparatorNodeLeadingMargin / 3.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_likeMeNode, _votesNode]];

    // complex nodes vertical stack layout
    NSMutableArray *commentNodes = @[vhStackLayout].mutableCopy;

    if (_descriptionNode) [commentNodes addObject:_descriptionNode];

    if (_commentHintNode) [commentNodes addObject:_commentHintNode];

    if (_commentTextNodes && _commentTextNodes.count > 0) {
        [commentNodes addObjectsFromArray:_commentTextNodes];
    }

    ASStackLayoutSpec *dvStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:kSeparatorNodeLeadingMargin / 2.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:commentNodes];

    // complex nodes inset layout
    ASInsetLayoutSpec *vInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin, kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin} child:dvStackLayout];

    // main vertical stack layout
    ASStackLayoutSpec *vStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[ratioLayout, fhStackLayout, sInsetLayout, vInsetLayout]];

    return vStackLayout;
}

- (void)dealloc {
    [self _removeActions];
}

- (void)fetchData {
    [super fetchData];

    if (_photo.commentsCount > 0) {
        @weakify(self)
        [_commentFeed refreshCommentsOnCompletion:^(NSArray<MSComment *> * _Nonnull comments) {
            @strongify(self)
            [self _addCommentNodes:comments];
        } pageSize:kPhotoFeedCommentPageSize];
    }
}

#pragma mark - Actions

- (void)photoNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"photo" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)likeNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"like" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)commentNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"comment" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)sendNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"send" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)votesNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"votes" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *photoUrlString = _photo.images[0].url;
    NSString *votesString = [NSString stringWithFormat:NSLocalizedString(@"%d likes", nil), _photo.votesCount];
    NSString *descriptionString = _photo.photoDescription && ![@"" isEqualToString:_photo.photoDescription] ? [NSString stringWithFormat:@"%@ %@", _photo.user.userName, _photo.photoDescription] : nil;
    NSString *commentHintString = _photo.commentsCount > 2 ? [NSString stringWithFormat:NSLocalizedString(@"View all %d comments", nil), _photo.commentsCount] : nil;

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
    _separatorNode.backgroundColor = MS_LIGHT_GRAY_TEXT_COLOR;
    _separatorNode.layerBacked = YES;

    _likeMeNode = [ASImageNode new];
    _likeMeNode.image = [UIImage imageNamed:@"likemetaheart"];
    _likeMeNode.contentMode = UIViewContentModeCenter;
    _likeMeNode.backgroundColor = self.backgroundColor;
    _likeMeNode.layerBacked = YES;

    _votesNode = [ASTextNode new];
    _votesNode.backgroundColor = self.backgroundColor;
    _votesNode.attributedString = [[ASMutableAttributedStringBuilder alloc] initWithString:votesString attributes:@{NSFontAttributeName : MS_FEED_BOLD_FONT}];
    _votesNode.flexShrink = YES;
    _votesNode.truncationMode = NSLineBreakByTruncatingTail;
    _votesNode.maximumNumberOfLines = 1;

    [self addSubnode:_photoNode];
    [self addSubnode:_likeNode];
    [self addSubnode:_commentNode];
    [self addSubnode:_sendNode];
    [self addSubnode:_separatorNode];
    [self addSubnode:_likeMeNode];
    [self addSubnode:_votesNode];

    if (descriptionString) {
        _descriptionNode = [ASTextNode new];
        _descriptionNode.backgroundColor = self.backgroundColor;
        _descriptionNode.attributedString = formatCommentString(descriptionString);
        _descriptionNode.flexShrink = YES;
        _descriptionNode.truncationMode = NSLineBreakByTruncatingTail;
        _descriptionNode.maximumNumberOfLines = kPhotoFeedCommentMaxLines;
        [self addSubnode:_descriptionNode];
    }

    if (commentHintString) {
        _commentHintNode = [ASTextNode new];
        _commentHintNode.backgroundColor = self.backgroundColor;
        _commentHintNode.attributedString = [[ASMutableAttributedStringBuilder alloc] initWithString:commentHintString attributes:@{NSFontAttributeName : MS_FEED_REGULAR_FONT, NSForegroundColorAttributeName : MS_LIGHT_GRAY_TEXT_COLOR}];
        _commentHintNode.flexShrink = YES;
        _commentHintNode.truncationMode = NSLineBreakByTruncatingTail;
        _commentHintNode.maximumNumberOfLines = 1;
        [self addSubnode:_commentHintNode];
    }
}

- (void)_addCommentNodes:(NSArray<MSComment *> *)comments {
    if (!comments || 0 == comments.count) return;

    // remove previous nodes
    [self _removeCommentNodes];

    NSMutableArray *newCommentTextNodes = [NSMutableArray arrayWithCapacity:comments.count];

    for (MSComment *comment in comments) {
        NSString *commentString = [NSString stringWithFormat:@"%@ %@", comment.user.userName, comment.body];
        ASTextNode *commentTextNode = [ASTextNode new];
        commentTextNode.backgroundColor = self.backgroundColor;
        commentTextNode.attributedString = formatCommentString(commentString);
        commentTextNode.flexShrink = YES;
        commentTextNode.truncationMode = NSLineBreakByTruncatingTail;
        commentTextNode.maximumNumberOfLines = kPhotoFeedCommentMaxLines;

        [newCommentTextNodes addObject:commentTextNode];
        [self addSubnode:commentTextNode];
    }

    _commentTextNodes = newCommentTextNodes;

    // reload comment needs layout
    [self setNeedsLayout];
}

- (void)_removeCommentNodes {
    if (_commentTextNodes && _commentTextNodes.count > 0) {
        for (ASTextNode *commentTextNode in _commentTextNodes) {
            [commentTextNode removeFromSupernode];
        }
    }

    _commentTextNodes = @[];
}

- (void)_addActions {
    @weakify(self)
    [_photoNode setBlockForControlEvents:ASControlNodeEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self photoNodeDidTapped];
    }];

    [_likeNode setBlockForControlEvents:ASControlNodeEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self likeNodeDidTapped];
    }];

    [_commentNode setBlockForControlEvents:ASControlNodeEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self commentNodeDidTapped];
    }];

    [_sendNode setBlockForControlEvents:ASControlNodeEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self sendNodeDidTapped];
    }];

    [_votesNode setBlockForControlEvents:ASControlNodeEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self votesNodeDidTapped];
    }];
}

- (void)_removeActions {
    [_photoNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
    [_likeNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
    [_commentNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
    [_sendNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
    [_votesNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
}

@end
