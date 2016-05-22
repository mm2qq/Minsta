//
//  MSPhotoDisplayNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoDisplayNode.h"
#import "UIGestureRecognizer+MinstaAdd.h"
#import "MinstaMacro.h"

#pragma mark - MSPhotoDisplayItem

@implementation MSPhotoDisplayItem

@end

#pragma mark - MSPhotoDisplayNodeCell

@interface MSPhotoDisplayCellNode : ASCellNode

@property (nonatomic, strong) MSPhotoDisplayItem *displayItem;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;

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
    return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.f child:_photoNode];
}

#pragma mark - Private

- (void)_setupSubnodes {
    _photoNode = [ASNetworkImageNode new];
    _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    _photoNode.defaultImage = _displayItem.defaultImage;
    _photoNode.URL = _displayItem.imageUrl;

    [self addSubnode:_photoNode];
}

- (void)_addActions {
    // TODO:add action for node
}

@end

#pragma mark - MSPhotoDisplayNode

@interface MSPhotoDisplayNode () <ASPagerDataSource>

@property (nonatomic, copy) NSArray<MSPhotoDisplayItem *> *displayItems;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) ASPagerNode *pagerNode;

@end

@implementation MSPhotoDisplayNode

#pragma mark - Lifecycle

- (instancetype)initWithDisplayItems:(NSArray<MSPhotoDisplayItem *> *)items {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        _displayItems = items;

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
}

- (void)dealloc {
    [self _removeActions];
}

#pragma mark - ASPagerDataSource

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    return _displayItems.count;
}

- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index {
    MSPhotoDisplayItem *item = _displayItems[index];

    return ^ASCellNode *() {
        return [[MSPhotoDisplayCellNode alloc] initWithDisplayItem:item];
    };
}

#pragma mark - Actions

- (void)pagerDidTapped {

}

#pragma mark - Public

- (void)presentOnView:(UIView *)parentView fromView:(UIView *)fromView {

}

#pragma mark - Private

- (void)_setupSubnodes {
    _pagerNode = [ASPagerNode new];
    _pagerNode.dataSource = self;

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
