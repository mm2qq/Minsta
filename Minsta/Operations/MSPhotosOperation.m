//
//  MSPhotosOperation.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotosOperation.h"
#import "MinstaMacro.h"
#import <AFNetworking/AFNetworking.h>

@implementation MSPhotosOperation

+ (instancetype)sharedInstance {
    static MSPhotosOperation *operation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operation = [MSPhotosOperation new];
    });

    return operation;
}

#pragma mark - Public

- (void)retrievePhotosWithUserId:(NSUInteger)userId
                       imageSize:(CGSize)imageSize
                          atPage:(NSUInteger)page
                        pageSize:(NSUInteger)pageSize
                      completion:(MSCompletionCallback)callback {
    NSUInteger sizeId = MSImageSizeIdForStandardSize(imageSize);
    NSUInteger realPage = page == 0 ? 1 : page;
    NSUInteger realPageSize = pageSize > 100 ? 100 : pageSize;

    NSString *URLString = [NSURL URLWithString:@"photos" relativeToURL:_manager.baseURL].absoluteString;
    NSMutableDictionary *params = @{@"feature" : @"fresh_today",
                                    @"sort" : @"created_at",
                                    @"consumer_key" : FHPX_CONSUMER_KEY}.mutableCopy;

    if (userId > 0) {
        [params setValue:@"user_friends" forKey:@"feature"];
        [params addEntriesFromDictionary:@{@"user_id" : @(userId)}];
    }

    if (sizeId > 0) [params addEntriesFromDictionary:@{@"image_size" : @(sizeId)}];
    if (realPage > 0) [params addEntriesFromDictionary:@{@"page" : @(realPage)}];
    if (realPageSize > 0) [params addEntriesFromDictionary:@{@"rpp" : @(realPageSize)}];

    [_manager GET:URLString
       parameters:params
         progress:NULL
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              !callback ? : callback(responseObject, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !callback ? : callback(nil, error);
          }];
}

- (void)retrieveCommentsWithPhotoId:(NSUInteger)photoId
                             atPage:(NSUInteger)page
                           pageSize:(NSUInteger)pageSize
                         completion:(MSCompletionCallback)callback {
    NSString *pathString = [NSString stringWithFormat:@"photos/%d/comments?nested", (int)photoId];
    NSUInteger realPage = page == 0 ? 1 : page;
    NSUInteger realPageSize = pageSize > 100 ? 100 : pageSize;

    NSString *URLString = [NSURL URLWithString:pathString relativeToURL:_manager.baseURL].absoluteString;
    NSMutableDictionary *params = @{@"sort" : @"created_at",
                                    @"consumer_key" : FHPX_CONSUMER_KEY}.mutableCopy;

    if (realPage > 0) [params addEntriesFromDictionary:@{@"page" : @(realPage)}];
    if (realPageSize > 0) [params addEntriesFromDictionary:@{@"rpp" : @(realPageSize)}];

    [_manager GET:URLString
       parameters:params
         progress:NULL
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              !callback ? : callback(responseObject, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !callback ? : callback(nil, error);
          }];
}

@end
