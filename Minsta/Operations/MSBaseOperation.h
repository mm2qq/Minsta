//
//  MSBaseOperation.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

typedef void (^MSCompletionCallback)(id _Nullable data, NSError * _Nullable error);

@protocol MSOperationProtocol <NSObject>

- (void)cancelTaskWithIdentifier:(NSUInteger)identifier;

@end

@interface MSBaseOperation : NSObject
{
@protected
    AFHTTPSessionManager *_manager;
}
@end
