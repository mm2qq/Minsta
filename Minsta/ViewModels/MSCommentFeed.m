//
//  MSCommentFeed.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSCommentFeed.h"
#import "MSHomeOperation.h"
#import "MinstaMacro.h"

@interface MSCommentFeed ()

@property (nonatomic, assign) BOOL fetchCommentsInProgress;
@property (nonatomic, assign) BOOL refreshCommentsInProgress;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalCount;                    ///< Total count of comments
@property (nonatomic, assign) NSUInteger totalPages;                    ///< Total page count of comments
@property (nonatomic, assign) NSUInteger photoId;
@property (nonatomic, copy) NSMutableArray<MSComment *> *comments;
@property (nonatomic, copy) NSMutableArray<NSNumber *> *commentIds;

@end

@implementation MSCommentFeed

#pragma mark - Lifecycle

- (instancetype)initWithPhotoId:(NSUInteger)photoId {
    if (self = [super init]) {
        _photoId = photoId;
        _comments = [NSMutableArray array];
        _commentIds = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Properties

- (NSUInteger)count {
    return _comments.count;
}

#pragma mark - Public

- (MSComment *)commentAtIndex:(NSUInteger)index {
    return 0 == _comments.count || index > _comments.count - 1 ? nil : _comments[index];
}

- (void)resetAllComments {
    _fetchCommentsInProgress = NO;
    _refreshCommentsInProgress = NO;
    _currentPage = 0;
    _totalPages = 0;
    _totalCount = 0;
    _comments = [NSMutableArray array];
    _commentIds = [NSMutableArray array];
}

- (void)fetchCommentsOnCompletion:(void (^)(NSArray<MSComment *> * _Nonnull))callback pageSize:(NSUInteger)size {
    // return while fetching
    if (_fetchCommentsInProgress) return;

    _fetchCommentsInProgress = YES;
    [self _retrieveCommentsOnCompletion:callback pageSize:size replaceData:NO];
}

- (void)refreshCommentsOnCompletion:(void (^)(NSArray<MSComment *> * _Nonnull))callback pageSize:(NSUInteger)size {
    // return while refreshing
    if (_refreshCommentsInProgress) return;

    _currentPage = 0;
    _refreshCommentsInProgress = YES;
    [self _retrieveCommentsOnCompletion:callback pageSize:size replaceData:YES];
}

#pragma mark - Private

- (void)_retrieveCommentsOnCompletion:(void (^)(NSArray<MSComment *> *))callback pageSize:(NSUInteger)size replaceData:(BOOL)replace {
    // return while data reach the bottom
    if (_totalPages > 0 && _currentPage == _totalPages) return;

    NSMutableArray *newComments = [NSMutableArray array];
    NSMutableArray *newCommentsIds = [NSMutableArray array];

    [[MSHomeOperation sharedInstance] retrieveCommentsWithPhotoId:_photoId
                                                           atPage:++_currentPage
                                                         pageSize:size
                                                       completion:^(id  _Nullable data, NSError * _Nullable error)
     {
         if (!data || error) {
             NSLog(@"%@", error.localizedDescription);
             return;
         }

         NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

         if ([response isKindOfClass:[NSDictionary class]]) {
             _currentPage = [response[@"current_page"] unsignedIntegerValue];
             _totalPages  = [response[@"total_pages"] unsignedIntegerValue];
             _totalCount  = [response[@"total_items"] unsignedIntegerValue];

             for (NSDictionary *commentDict in response[@"comments"]) {
                 MSComment *comment = [MSComment modelObjectWithDictionary:commentDict];
                 NSNumber *commentId = @(comment.commentId);

                 // avoid inserting null object
                 if (!comment) continue;

                 if (replace || ![_commentIds containsObject:commentId]) {
                     [newComments addObject:comment];
                     [newCommentsIds addObject:commentId];
                 }
             }
         }

         dispatch_async_on_main_queue(^{
             if (replace) {
                 _comments = newComments;
                 _commentIds = newCommentsIds;
             } else {
                 [_comments addObjectsFromArray:newComments];
                 [_commentIds addObjectsFromArray:newCommentsIds];
             }

             // invoke callback
             !callback ? : callback(newComments);

             // reset status value
             _fetchCommentsInProgress = NO;
             _refreshCommentsInProgress = NO;
         });
     }];
}

@end
