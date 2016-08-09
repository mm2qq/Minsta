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
@property (nonatomic, strong) ASImageNode *likeControlNode;
@property (nonatomic, strong) ASImageNode *commentControlNode;
@property (nonatomic, strong) ASImageNode *sendControlNode;
@property (nonatomic, strong) ASDisplayNode *separatorNode;
@property (nonatomic, strong) ASImageNode *likeMeNode;
@property (nonatomic, strong) ASTextNode *votesTextNode;
@property (nonatomic, strong) ASTextNode *descriptionNode;
@property (nonatomic, strong) ASTextNode *commentHintNode;
@property (nonatomic, copy) NSArray<ASTextNode *> *commentTextNodes;
@property (nonatomic, strong) ASTextNode *timeTextNode;

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

- (void)dealloc {
	[self _removeActions];
}

#pragma mark - Override

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
	// set subnode preferred size
	_likeControlNode.preferredFrameSize = (CGSize){kFunctionNodeSizeWidth, kFunctionNodeSizeWidth};
	_commentControlNode.preferredFrameSize = _likeControlNode.preferredFrameSize;
	_sendControlNode.preferredFrameSize = _likeControlNode.preferredFrameSize;
	_separatorNode.preferredFrameSize = (CGSize){constrainedSize.max.width, 1.f / [UIScreen mainScreen].scale};

	// photo ratio layout
	ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.f child:_photoNode];

	// function node horizontal stack layout
	ASStackLayoutSpec *fhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_likeControlNode, _commentControlNode, _sendControlNode]];

	// separator inset layout
	ASInsetLayoutSpec *sInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){0.f, kSeparatorNodeLeadingMargin, 0.f, kSeparatorNodeLeadingMargin} child:_separatorNode];

	// votes node horizontal stack layout
	ASStackLayoutSpec *vhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:kSeparatorNodeLeadingMargin / 3.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_likeMeNode, _votesTextNode]];

	// complex nodes vertical stack layout
	NSMutableArray *commentNodes = @[vhStackLayout].mutableCopy;

	if (_descriptionNode) [commentNodes addObject:_descriptionNode];

	if (_commentHintNode) [commentNodes addObject:_commentHintNode];

	if (_commentTextNodes && _commentTextNodes.count > 0) {
		[commentNodes addObjectsFromArray:_commentTextNodes];
	}

	if (_timeTextNode) [commentNodes addObject:_timeTextNode];

	ASStackLayoutSpec *dvStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:kSeparatorNodeLeadingMargin / 2.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:commentNodes];

	// complex nodes inset layout
	ASInsetLayoutSpec *vInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin, kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin} child:dvStackLayout];

	// main vertical stack layout
	ASStackLayoutSpec *vStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[ratioLayout, fhStackLayout, sInsetLayout, vInsetLayout]];

	return vStackLayout;
}

- (void)fetchData {
	[super fetchData];

	if (_photo.commentsCount > 0) {
		@weakify(self)
		[_commentFeed refreshCommentsOnCompletion:^(NSArray<MSComment *> * _Nonnull comments) {
		         @strongify(self)
		         [self _addCommentNodes: comments];
		 } pageSize: kPhotoFeedCommentPageSize];
	}

	// refresh time text node by the way
	NSString *timeString = [NSString elapsedTimeStringSinceDate:_photo.createdAt];

	if (timeString) {
		self.timeTextNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:timeString attributes:@{NSFontAttributeName : MS_FEED_SMALL_FONT, NSForegroundColorAttributeName : MS_LIGHT_GRAY_TEXT_COLOR}];
		[self setNeedsLayout];
	}
}

- (void)clearFetchedData {
	[super clearFetchedData];
	[_commentFeed cancelFetch];
}

#pragma mark - Properties

- (ASTextNode *)commentHintNode {
	if (!_commentHintNode) {
		_commentHintNode = [ASTextNode new];
		_commentHintNode.backgroundColor = self.backgroundColor;
		_commentHintNode.flexShrink = YES;
		_commentHintNode.truncationMode = NSLineBreakByTruncatingTail;
		_commentHintNode.maximumNumberOfLines = 1;
	}

	return _commentHintNode;
}

- (ASTextNode *)timeTextNode {
	if (!_timeTextNode) {
		_timeTextNode = [ASTextNode new];
		_timeTextNode.backgroundColor = self.backgroundColor;
		_timeTextNode.flexShrink = YES;
		_timeTextNode.layerBacked = YES;
		_timeTextNode.truncationMode = NSLineBreakByTruncatingTail;
		_timeTextNode.maximumNumberOfLines = 1;
	}

	return _timeTextNode;
}

#pragma mark - Actions

- (void)photoNodeDidTapped:(id)sender {
	if ([_delegate respondsToSelector:@selector(cellNode:didTappedPhotoNode:)]) {
		[_delegate cellNode:self didTappedPhotoNode:sender];
	}
}

- (void)likeControlNodeDidTapped {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"like photo" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)commentControlNodeDidTapped {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"comment photo" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)sendControlNodeDidTapped {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"send photo" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)votesTextNodeDidTapped {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"show votes" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)commentHintNodeDidTapped {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"show comments" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)commentTextNodeDidTapped:(id)sender {
	// TODO:this alert just for test
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"reply %@", ((ASTextNode *)sender).attributedText.string] preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

- (void)_setupSubnodes {
	NSString *photoUrlString = _photo.images[0].url;
	NSString *votesString = [NSString stringWithFormat:NSLocalizedString(@"%d likes", nil), _photo.votesCount];
	NSString *descriptionString = _photo.photoName && ![@"" isEqualToString:_photo.photoName]
	                              ?[NSString stringWithFormat:@"%@ %@", _photo.user.userName, _photo.photoDescription
	                                && ![@"" isEqualToString:_photo.photoDescription]
	                                ? _photo.photoDescription : _photo.photoName] : nil;
	NSString *commentHintString = _photo.commentsCount > 2
	                              ?[NSString stringWithFormat:NSLocalizedString(@"View all %d comments", nil), _photo.commentsCount] : nil;
	NSString *timeString = [NSString elapsedTimeStringSinceDate:_photo.createdAt];

	_photoNode = [ASNetworkImageNode new];
	_photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
	_photoNode.URL = [NSURL URLWithString:photoUrlString];

	_likeControlNode = [ASImageNode new];
	_likeControlNode.image = [UIImage imageNamed:@"like"];
	_likeControlNode.contentMode = UIViewContentModeCenter;
	_likeControlNode.backgroundColor = self.backgroundColor;

	_commentControlNode = [ASImageNode new];
	_commentControlNode.image = [UIImage imageNamed:@"comment"];
	_commentControlNode.contentMode = UIViewContentModeCenter;
	_commentControlNode.backgroundColor = self.backgroundColor;

	_sendControlNode = [ASImageNode new];
	_sendControlNode.image = [UIImage imageNamed:@"send"];
	_sendControlNode.contentMode = UIViewContentModeCenter;
	_sendControlNode.backgroundColor = self.backgroundColor;

	_separatorNode = [ASDisplayNode new];
	_separatorNode.backgroundColor = MS_LIGHT_GRAY_TEXT_COLOR;
	_separatorNode.layerBacked = YES;

	_likeMeNode = [ASImageNode new];
	_likeMeNode.image = [UIImage imageNamed:@"likemetaheart"];
	_likeMeNode.backgroundColor = self.backgroundColor;
	_likeMeNode.layerBacked = YES;

	_votesTextNode = [ASTextNode new];
	_votesTextNode.backgroundColor = self.backgroundColor;
	_votesTextNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:votesString attributes:@{NSFontAttributeName : MS_FEED_BOLD_FONT}];
	_votesTextNode.flexShrink = YES;
	_votesTextNode.truncationMode = NSLineBreakByTruncatingTail;
	_votesTextNode.maximumNumberOfLines = 1;

	[self addSubnode:_photoNode];
	[self addSubnode:_likeControlNode];
	[self addSubnode:_commentControlNode];
	[self addSubnode:_sendControlNode];
	[self addSubnode:_separatorNode];
	[self addSubnode:_likeMeNode];
	[self addSubnode:_votesTextNode];

	if (descriptionString) {
		_descriptionNode = [ASTextNode new];
		_descriptionNode.backgroundColor = self.backgroundColor;
		_descriptionNode.attributedText = formatCommentString(descriptionString);
		_descriptionNode.flexShrink = YES;
		_descriptionNode.truncationMode = NSLineBreakByTruncatingTail;
		_descriptionNode.maximumNumberOfLines = kPhotoFeedCommentMaxLines;
		[self addSubnode:_descriptionNode];
	}

	if (commentHintString) {
		self.commentHintNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:commentHintString attributes:@{NSFontAttributeName : MS_FEED_REGULAR_FONT, NSForegroundColorAttributeName : MS_LIGHT_GRAY_TEXT_COLOR}];
		[self addSubnode:_commentHintNode];
	}

	if (timeString) {
		self.timeTextNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:timeString attributes:@{NSFontAttributeName : MS_FEED_SMALL_FONT, NSForegroundColorAttributeName : MS_LIGHT_GRAY_TEXT_COLOR}];
		[self addSubnode:_timeTextNode];
	}
}

- (void)_addCommentNodes:(NSArray<MSComment *> *)comments {
	if (!comments || 0 == comments.count) return;

	// remove previous nodes
	[self _removeCommentNodes];

	NSMutableArray *newCommentTextNodes = [NSMutableArray arrayWithCapacity:comments.count];

	[comments enumerateObjectsWithOptions:NSEnumerationReverse// always set latest comment to bottom
	 usingBlock:^(MSComment * _Nonnull comment, NSUInteger idx, BOOL * _Nonnull stop)
	 {
	         NSString *commentString = [NSString stringWithFormat:@"%@ %@",
	                                    comment.user.userName,
	                                    comment.body];
	         ASTextNode *commentTextNode = [ASTextNode new];
	         commentTextNode.backgroundColor = self.backgroundColor;
	         commentTextNode.attributedText = formatCommentString(commentString);
	         commentTextNode.flexShrink = YES;
	         commentTextNode.truncationMode = NSLineBreakByTruncatingTail;
	         commentTextNode.maximumNumberOfLines = kPhotoFeedCommentMaxLines;
	         @weakify(self)
	         [commentTextNode setBlockForControlEvents: ASControlNodeEventTouchUpInside
block:^(id _Nonnull sender)
	          {
	                  @strongify(self)
	                  [self commentTextNodeDidTapped: sender];
		  }];

	         [newCommentTextNodes addObject:commentTextNode];
	         [self addSubnode:commentTextNode];
	 }];

	_commentTextNodes = newCommentTextNodes;

	// refresh comment hint node by the way
	NSString *commentHintString = _commentFeed.totalCount > 2
	                              ?[NSString stringWithFormat:NSLocalizedString(@"View all %d comments", nil), _commentFeed.totalCount] : nil;

	if (commentHintString) {
		self.commentHintNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:commentHintString attributes:@{NSFontAttributeName : MS_FEED_REGULAR_FONT, NSForegroundColorAttributeName : MS_LIGHT_GRAY_TEXT_COLOR}];
	}

	// reload comment needs layout
	[self setNeedsLayout];
}

- (void)_removeCommentNodes {
	if (_commentTextNodes && _commentTextNodes.count > 0) {
		for (ASTextNode *commentTextNode in _commentTextNodes) {
			[commentTextNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
			[commentTextNode removeFromSupernode];
		}
	}

	_commentTextNodes = @[];
}

- (void)_addActions {
	@weakify(self)
	[_photoNode setBlockForControlEvents: ASControlNodeEventTouchUpInside
block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self photoNodeDidTapped: sender];
	 }];

	[_likeControlNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self likeControlNodeDidTapped];
	 }];

	[_commentControlNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self commentControlNodeDidTapped];
	 }];

	[_sendControlNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self sendControlNodeDidTapped];
	 }];

	[_votesTextNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self votesTextNodeDidTapped];
	 }];

	[_descriptionNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self commentTextNodeDidTapped: sender];
	 }];

	[_commentHintNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
	 block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self commentHintNodeDidTapped];
	 }];
}

- (void)_removeActions {
	[_photoNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_likeControlNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_commentControlNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_sendControlNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_votesTextNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_descriptionNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
	[_commentHintNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
}

@end
