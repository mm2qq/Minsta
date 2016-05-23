//
//  MSPhotoDisplayNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoDisplayNode.h"
#import "MSWindow.h"
#import "UIGestureRecognizer+MinstaAdd.h"
#import "MinstaMacro.h"

#pragma mark - MSPhotoDisplayItem

@implementation MSPhotoDisplayItem

@end

#pragma mark - MSPhotoDisplayNodeCell

@interface MSPhotoDisplayCellNode : ASCellNode

@property (nonatomic, strong) MSPhotoDisplayItem *displayItem;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;

@property (nonatomic, strong) ASScrollNode *scrollNode;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDisplayItem:(MSPhotoDisplayItem *)item NS_DESIGNATED_INITIALIZER;

@end

@implementation MSPhotoDisplayCellNode

#pragma mark - Lifecycle

- (instancetype)initWithDisplayItem:(MSPhotoDisplayItem *)item {
    if (self = [super init]) {
        _displayItem = item;

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _scrollNode.sizeRange = ASRelativeSizeRangeMakeWithExactCGSize(constrainedSize.max);
    return [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[_scrollNode]];
}

#pragma mark - Private

- (void)_setupSubnodes {
    _photoNode = [ASNetworkImageNode new];
    _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    _photoNode.defaultImage = _displayItem.defaultImage;
    _photoNode.URL = _displayItem.imageUrl;

    _scrollNode = [ASScrollNode new];
    @weakify(self)
    _scrollNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        @strongify(self)
        return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.f child:self.photoNode]];
    };

    [_scrollNode addSubnode:_photoNode];
    [self addSubnode:_scrollNode];
}

- (void)_addActions {
    // TODO:add action for node
}

@end

#pragma mark - MSPhotoDisplayNode

@interface MSPhotoDisplayNode () <ASPagerDataSource>

@property (nonatomic, copy) NSArray<MSPhotoDisplayItem *> *displayItems;

@property (nonatomic, strong) ASPagerNode *pagerNode;

@end

@implementation MSPhotoDisplayNode

#pragma mark - Lifecycle

- (instancetype)initWithDisplayItems:(NSArray<MSPhotoDisplayItem *> *)items {
    if (self = [super init]) {
        _displayItems = items;

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
}

- (void)dealloc {
    [self _removeActions];
}

- (void)layout {
    _pagerNode.frame = self.frame;
    [super layout];
}

#pragma mark - ASPagerDataSource

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    return _displayItems.count;
}

- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index {
    MSPhotoDisplayItem *item = _displayItems[index];

    return ^ASCellNode *() {
        MSPhotoDisplayCellNode *cell = [[MSPhotoDisplayCellNode alloc] initWithDisplayItem:item];
        cell.hidden = index == 0;// hide first cell
        return cell;
    };
}

#pragma mark - Actions

- (void)pagerDidTapped {
    [(MSWindow *)([UIApplication sharedApplication].keyWindow) hideStatusBarOverlay:NO];
    [self.view removeFromSuperview];
}

#pragma mark - Public

- (void)presentView:(UIView *)fromView
            atIndex:(NSUInteger)index
         completion:(MSPhotoDisplayCompletionCallback)callback {
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    self.frame = parentView.frame;
    [parentView addSubnode:self];

    [UIView animateWithDuration:.25f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _pagerNode.alpha = 1.f;
                         [(MSWindow *)([UIApplication sharedApplication].keyWindow) hideStatusBarOverlay:YES];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // scroll to specific page
                             [_pagerNode scrollToPageAtIndex:index animated:NO];
                             // revert first cell to visible
                             MSPhotoDisplayCellNode *cell = (MSPhotoDisplayCellNode *)[_pagerNode.view nodeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                             cell.hidden = NO;
                         }
                     }];
}

#pragma mark - Private

- (void)_setupSubnodes {
    _pagerNode = [ASPagerNode new];
    _pagerNode.alpha = 0.f;
    _pagerNode.dataSource = self;
    _pagerNode.backgroundColor = [UIColor blackColor];

    [self addSubnode:_pagerNode];
}

- (void)_addActions {
    @weakify(self)
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithActionBlock:^(id  _Nonnull sender)
                                     {
                                         @strongify(self)
                                         [self pagerDidTapped];
                                     }]];
}

- (void)_removeActions {
    [self.view.gestureRecognizers makeObjectsPerformSelector:@selector(removeAllActionBlocks)];
}

@end
