//
//  MSSearchViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSSearchViewController.h"
#import "MSPhotoFreshCellNode.h"
#import "MSPhotoDisplayNode.h"
#import "MSPhotoFeed.h"
#import "MSWindow.h"
#import "MinstaMacro.h"

static const CGFloat kItemMargin = 1.f;

@interface MSSearchViewController () <ASCollectionDataSource, ASCollectionDelegate, MSPhotoFreshCellDelegate>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) MSPhotoFeed *photoFeed;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation MSSearchViewController

#pragma mark - Lifecycle

- (instancetype)init {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSUInteger numOfItemsPerLine = 3;
    _itemWidth = floorf((screenWidth - kItemMargin * (numOfItemsPerLine - 1)) / numOfItemsPerLine);
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
	flowLayout.minimumLineSpacing = kItemMargin;
	flowLayout.minimumInteritemSpacing = kItemMargin;

	ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
	collectionNode.view.allowsSelection = NO;

	if (self = [super initWithNode:collectionNode]) {
		collectionNode.dataSource = self;
		collectionNode.delegate = self;
	}

	return self;
}

- (void)loadView {
	[super loadView];

	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	NSArray *imageSizes = @[@(MSImageSizeIdForStandardSize((CGSize){screenSize.width, screenSize.width * MS_UNCROPPED_PHOTO_RATIO})), @(MSImageSizeIdForStandardSize((CGSize){_itemWidth, _itemWidth}))];
	_photoFeed = [[MSPhotoFeed alloc] initWithImageSizes:imageSizes];

	// load datasource
	[self _refreshPhotos];
}

#pragma mark - Properties

- (ASCollectionNode *)collectionNode {
	return (ASCollectionNode *)self.node;
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _photoFeed.count;
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSPhoto *photo = [_photoFeed photoAtIndex:indexPath.item];
	BOOL shouldCropped = indexPath.item != 0;// first item do not crop

	return ^ASCellNode *() {
		       MSPhotoFreshCellNode *cell = [[MSPhotoFreshCellNode alloc] initWithPhoto:photo shouldCropped:shouldCropped];
		       cell.delegate = self;
		       cell.indexPath = indexPath;

		       return cell;
	};
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath {
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGSize itemSize = indexPath.item == 0
	                  ? (CGSize){screenSize.width, screenSize.width * MS_UNCROPPED_PHOTO_RATIO}
                        : (CGSize){_itemWidth, _itemWidth};
	return ASSizeRangeMake(itemSize, itemSize);
}

#pragma mark - ASCollectionDelegate

- (void)collectionView:(ASCollectionView *)collectionView willBeginBatchFetchWithContext:(ASBatchContext *)context {
	[context beginBatchFetching];
	[self _loadPhotosWithContext:context];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	self.navigationController.navigationBarHidden = NO;
}

#pragma mark - MSPhotoFreshCellDelegate

- (void)cellNode:(MSPhotoFreshCellNode *)cellNode didTappedPhotoNode:(ASNetworkImageNode *)photoNode {
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:_photoFeed.count];

	for (MSPhoto *photo in _photoFeed.photos) {
		MSPhotoDisplayItem *item = [MSPhotoDisplayItem new];
		item.imageUrl = [NSURL URLWithString:photo.images[0].url];
		[items addObject:item];
	}

	MSPhotoDisplayNode *displayNode = [[MSPhotoDisplayNode alloc] initWithDisplayItems:items];

	[displayNode presentView:photoNode.view
	 atIndex:cellNode.indexPath.item
	 completion:nil];
}

#pragma mark - Private

- (void)_refreshPhotos {
	@weakify(self)
	[_photoFeed refreshFreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
	         @strongify(self)
	         [self _insertItems: photos];
	 } pageSize : 20];
}

- (void)_loadPhotosWithContext:(ASBatchContext *)context {
	@weakify(self)
	[_photoFeed fetchFreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
	         @strongify(self)
	         [self _insertItems: photos];

	         // complete batch fetching
	         if (context) [context completeBatchFetching:YES];
	 } pageSize : 30];
}

- (void)_insertItems:(NSArray<MSPhoto *> *)photos {
	if (photos.count == 0) return;

	NSMutableArray *indexPaths = [NSMutableArray array];

	for (NSUInteger item = _photoFeed.count - photos.count; item < _photoFeed.count; item++) {
		[indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:0]];
	}

	[self.collectionNode.view insertItemsAtIndexPaths:indexPaths];
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
	BOOL shouldHide = self.navigationController.isNavigationBarHidden;
	[(MSWindow *)([UIApplication sharedApplication].keyWindow) hideStatusBarOverlay:shouldHide];

	return shouldHide;
}

@end
