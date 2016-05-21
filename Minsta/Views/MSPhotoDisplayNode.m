//
//  MSPhotoDisplayNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoDisplayNode.h"

#pragma mark - MSPhotoDisplayNodeCell

@interface MSPhotoDisplayNodeCell : ASCellNode

@property (nonatomic, strong) MSPhotoDisplayItem *displayItem;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDisplayItem:(MSPhotoDisplayItem *)item NS_DESIGNATED_INITIALIZER;

@end

@implementation MSPhotoDisplayNodeCell

#pragma mark - Lifecycle

- (instancetype)initWithDisplayItem:(MSPhotoDisplayItem *)item {
    if (self = [super init]) {
        _displayItem = item;

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
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
    }

    return self;
}

#pragma mark - Public

- (void)displayNode:(ASDisplayNode *)fromNode
             toNode:(ASDisplayNode *)toNode
         completion:(MSPhotoDisplayCompletionCallback)callback {

}

- (void)dismissOnCompletion:(MSPhotoDisplayCompletionCallback)callback {
    
}

#pragma mark - ASPagerDataSource

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    return _displayItems.count;
}

- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index {
    MSPhotoDisplayItem *item = _displayItems[index];

    return ^ASCellNode *() {
        return [[MSPhotoDisplayNodeCell alloc] initWithDisplayItem:item];
    };
}

#pragma mark - Private

- (void)_setupSubnodes {
    _pagerNode = [ASPagerNode new];
    _pagerNode.dataSource = self;
    [self addSubnode:_pagerNode];
}

@end
