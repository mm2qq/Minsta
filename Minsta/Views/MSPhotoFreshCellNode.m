//
//  MSPhotoFreshCellNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoFreshCellNode.h"
#import "MSPhoto.h"
#import "MinstaMacro.h"
#import "ASControlNode+MinstaAdd.h"

@interface MSPhotoFreshCellNode ()

@property (nonatomic, assign) BOOL cropped;
@property (nonatomic, strong) MSPhoto *photo;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;

@end

@implementation MSPhotoFreshCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo shouldCropped:(BOOL)cropped {
	if (self = [super init]) {
		self.backgroundColor = MS_WIHTE_BACKGROUND_COLOR;

		_cropped = cropped;
		_photo = photo;

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
	CGFloat photoRatio = _cropped ? 1.f : MS_UNCROPPED_PHOTO_RATIO;
	return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:photoRatio child:_photoNode];
}

#pragma mark - Actions

- (void)photoNodeDidTapped:(id)sender {
	if ([_delegate respondsToSelector:@selector(cellNode:didTappedPhotoNode:)]) {
		[_delegate cellNode:self didTappedPhotoNode:sender];
	}
}

#pragma mark - Private

- (void)_setupSubnodes {
	MSImage *fImage = _photo.images[0];
	MSImage *lImage = _photo.images[1];
	NSString *photoUrlString;

	// if requires a cropped image
	if (_cropped) {
		photoUrlString = MSImageCroppedForSizeId(fImage.sizeId) ? fImage.url : lImage.url;
	} else {
		photoUrlString = MSImageCroppedForSizeId(fImage.sizeId) ? lImage.url : fImage.url;
	}

	_photoNode = [ASNetworkImageNode new];
	_photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
	_photoNode.URL = [NSURL URLWithString:photoUrlString];

	[self addSubnode:_photoNode];
}

- (void)_addActions {
	@weakify(self)
	[_photoNode setBlockForControlEvents: ASControlNodeEventTouchUpInside
block:^(id _Nonnull sender)
	 {
	         @strongify(self)
	         [self photoNodeDidTapped: sender];
	 }];
}

- (void)_removeActions {
	[_photoNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
}

@end
