//
//  MSCommentFeedCellNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSCommentFeedCellNode.h"
#import "MSPhoto.h"
#import "MSCommentFeed.h"
#import "MinstaMacro.h"
#import "NSString+MinstaAdd.h"

static const CGFloat kVotesNodeLeadingMargin = 10.f;
#define kVotesCountFont [UIFont boldSystemFontOfSize:13.f]

@interface MSCommentFeedCellNode ()

@property (nonatomic, assign) NSUInteger photoId;
@property (nonatomic, assign) NSUInteger votesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, strong) MSCommentFeed *commentFeed;
@property (nonatomic, copy) NSArray<MSComment *> *comments;

@property (nonatomic, strong) ASTextNode *votesNode;

@end

@implementation MSCommentFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        [self _setupDataSource:photo];
        [self _setupSubnodes];
    }

    return self;
}

- (void)fetchData {
//    if (_commentsCount > 0) {
//        @weakify(self)
//        [_commentFeed refreshCommentsOnCompletion:^(NSArray<MSComment *> * _Nonnull comments) {
//            @strongify(self)
//            self.comments = comments;
//        } pageSize:3];
//    }

    [super fetchData];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    // inset layout
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){kVotesNodeLeadingMargin, kVotesNodeLeadingMargin, kVotesNodeLeadingMargin, 0.f} child:_votesNode];

    return insetLayout;
}

#pragma mark - Private

- (void)_setupDataSource:(MSPhoto *)photo {
    _photoId = photo.photoId;
    _votesCount = photo.votesCount;
//    _commentsCount = photo.commentsCount;
//    _commentFeed = [[MSCommentFeed alloc] initWithPhotoId:_photoId];
}

- (void)_setupSubnodes {
    NSString *votesString = [NSString stringWithFormat:NSLocalizedString(@"%d likes", nil), _votesCount];
    CGFloat votesNodeWidth = [votesString widthForFont:kVotesCountFont];
    CGFloat votesNodeHeight = [votesString heightForFont:kVotesCountFont width:votesNodeWidth];

    _votesNode = [ASTextNode new];
    _votesNode.backgroundColor = self.backgroundColor;
    _votesNode.attributedString = [[NSAttributedString alloc] initWithString:votesString attributes:@{NSFontAttributeName : kVotesCountFont}];
    _votesNode.flexShrink = YES;
    _votesNode.truncationMode = NSLineBreakByTruncatingTail;
    _votesNode.preferredFrameSize = (CGSize){votesNodeWidth, votesNodeHeight};
    _votesNode.maximumNumberOfLines = 1;

    [self addSubnode:_votesNode];
}

@end
