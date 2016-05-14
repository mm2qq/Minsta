//
//  MSBaseOperation.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSBaseOperation.h"
#import "MinstaMacro.h"
#import <AFNetworking/AFNetworking.h>

@implementation MSBaseOperation

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:FHPX_BASE_URL_STRING]];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }

    return self;
}

@end
