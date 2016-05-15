//
//  MSHomeOperation.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSHomeOperation.h"
#import "MinstaMacro.h"
#import <AFNetworking/AFNetworking.h>

@implementation MSHomeOperation

+ (instancetype)sharedInstance {
    static MSHomeOperation *operation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operation = [MSHomeOperation new];
    });

    return operation;
}

- (void)retrievePhotosWithUserId:(NSUInteger)userId
                       imageSize:(CGSize)size
                          atPage:(NSUInteger)page
                      completion:(MSCompletionCallback)callback {
    NSString *URLString = [NSURL URLWithString:@"photos" relativeToURL:_manager.baseURL].absoluteString;
    NSDictionary *params = @{@"feature" : @"user_friends",
                             @"user_id" : @(userId),
                             @"image_size" : @(imageSizeIdForStandardSize(size)),
                             @"page" : page == 0 ? @1 : @(page),
                             @"consumer_key" : FHPX_CONSUMER_KEY};

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
