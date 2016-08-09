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

- (NSUInteger)retrieveFreshPhotosWithImageSizes:(NSArray *)imageSizes
        atPage:(NSUInteger)page
        pageSize:(NSUInteger)pageSize
        completion:(MSOperationCompletionCallback)callback {
	return [self retrieveFriendsPhotosWithUserId:0
	        imageSizes:imageSizes
	        atPage:page
	        pageSize:pageSize
	        completion:callback];
}

- (NSUInteger)retrieveFriendsPhotosWithUserId:(NSUInteger)userId
        imageSizes:(NSArray *)imageSizes
        atPage:(NSUInteger)page
        pageSize:(NSUInteger)pageSize
        completion:(MSOperationCompletionCallback)callback {
	NSParameterAssert(imageSizes);

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

	if (imageSizes.count > 0) [params addEntriesFromDictionary:@{@"image_size" : [imageSizes componentsJoinedByString:@","]}];
	if (realPage > 0) [params addEntriesFromDictionary:@{@"page" : @(realPage)}];
	if (realPageSize > 0) [params addEntriesFromDictionary:@{@"rpp" : @(realPageSize)}];

	NSURLSessionDataTask *task = [_manager GET:URLString
	                              parameters:params
	                              progress:NULL
	                              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
	                              {
	                                      !callback ? : callback(responseObject, nil);
				      }
	                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
	                              {
	                                      !callback ? : callback(nil, error);
				      }];

	return task.taskIdentifier;
}

- (NSUInteger)retrieveCommentsWithPhotoId:(NSUInteger)photoId
        atPage:(NSUInteger)page
        pageSize:(NSUInteger)pageSize
        completion:(MSOperationCompletionCallback)callback {
	NSString *pathString = [NSString stringWithFormat:@"photos/%d/comments?nested", (int)photoId];
	NSUInteger realPage = page == 0 ? 1 : page;
	NSUInteger realPageSize = pageSize > 100 ? 100 : pageSize;

	NSString *URLString = [NSURL URLWithString:pathString relativeToURL:_manager.baseURL].absoluteString;
	NSMutableDictionary *params = @{@"sort" : @"created_at",
		                        @"consumer_key" : FHPX_CONSUMER_KEY}.mutableCopy;

	if (realPage > 0) [params addEntriesFromDictionary:@{@"page" : @(realPage)}];
	if (realPageSize > 0) [params addEntriesFromDictionary:@{@"rpp" : @(realPageSize)}];

	NSURLSessionDataTask *task = [_manager GET:URLString
	                              parameters:params
	                              progress:NULL
	                              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
	                              {
	                                      !callback ? : callback(responseObject, nil);
				      }
	                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
	                              {
	                                      !callback ? : callback(nil, error);
				      }];

	return task.taskIdentifier;
}

#pragma mark - MSOperationProtocol

- (void)cancelTaskWithIdentifier:(NSUInteger)identifier {
	for (NSURLSessionDataTask *task in _manager.dataTasks) {
		if (identifier == task.taskIdentifier && NSURLSessionTaskStateCanceling > task.state) {
			[task cancel];
			return;
		}
	}
}

@end
