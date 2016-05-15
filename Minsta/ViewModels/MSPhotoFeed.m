//
//  MSPhotoFeed.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoFeed.h"
#import "MSHomeOperation.h"
#import "MinstaMacro.h"

@interface MSPhotoFeed ()

@property (nonatomic, assign) BOOL fetchPhotosInProgress;
@property (nonatomic, assign) BOOL refreshPhotosInProgress;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalCount;                    ///< Total count of photos
@property (nonatomic, assign) NSUInteger totalPages;                    ///< Total page count of photos
@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, copy) NSMutableArray<MSPhoto *> *photos;
@property (nonatomic, copy) NSMutableArray<NSNumber *> *photoIds;

@end

@implementation MSPhotoFeed

#pragma mark - Lifecycle

- (instancetype)initWithFrameSize:(CGSize)size {
    if (self = [super init]) {
        _frameSize = size;
        _photos = [NSMutableArray array];
        _photoIds = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Properties

- (NSUInteger)count {
    return _photos.count;
}

#pragma mark - Public

- (MSPhoto *)photoAtIndex:(NSUInteger)index {
    return 0 == _photos.count || index > _photos.count - 1 ? nil : _photos[index];
}

- (void)resetAllPhotos {
    _fetchPhotosInProgress = NO;
    _refreshPhotosInProgress = NO;
    _currentPage = 0;
    _totalPages = 0;
    _totalCount = 0;
    _photos = [NSMutableArray array];
    _photoIds = [NSMutableArray array];
}

- (void)fetchPhotosOnCompletion:(void (^)(NSArray<MSPhoto *> * _Nonnull))callback pageSize:(NSUInteger)size {
    // return while fetching
    if (_fetchPhotosInProgress) return;

    _fetchPhotosInProgress = YES;
    [self _retrievePhotosOnCompletion:callback pageSize:size replaceData:NO];
}

- (void)refreshPhotosOnCompletion:(void (^)(NSArray<MSPhoto *> * _Nonnull))callback pageSize:(NSUInteger)size {
    // return while refreshing
    if (_refreshPhotosInProgress) return;

    _currentPage = 0;
    _refreshPhotosInProgress = YES;
    [self _retrievePhotosOnCompletion:callback pageSize:size replaceData:YES];
}

#pragma mark - Private

- (void)_retrievePhotosOnCompletion:(void (^)(NSArray<MSPhoto *> *))callback pageSize:(NSUInteger)size replaceData:(BOOL)replace {
    // return while data reach the bottom
    if (_totalPages > 0 && _currentPage == _totalPages) return;

    NSMutableArray *newPhotos = [NSMutableArray array];
    NSMutableArray *newPhotoIds = [NSMutableArray array];

    [[MSHomeOperation sharedInstance] retrievePhotosWithUserId:FHPX_TEST_USER_ID
                                                     imageSize:MSStandardSizeForFrameSize(_frameSize)
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

             for (NSDictionary *photoDict in response[@"photos"]) {
                 MSPhoto *photo = [MSPhoto modelObjectWithDictionary:photoDict];
                 NSNumber *photoId = @(photo.photoId);

                 // avoid inserting null object
                 if (!photo) continue;

                 if (replace || ![_photoIds containsObject:photoId]) {
                     [newPhotos addObject:photo];
                     [newPhotoIds addObject:photoId];
                 }
             }
         }

         dispatch_async_on_main_queue(^{
             if (replace) {
                 _photos = newPhotos;
                 _photoIds = newPhotoIds;
             } else {
                 [_photos addObjectsFromArray:newPhotos];
                 [_photoIds addObjectsFromArray:newPhotoIds];
             }

             // invoke callback
             !callback ? : callback(newPhotos);

             // reset status value
             _fetchPhotosInProgress = NO;
             _refreshPhotosInProgress = NO;
         });
     }];
}

@end
