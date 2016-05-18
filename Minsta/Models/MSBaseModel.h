//
//  MSBaseModel.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSModelProtocol <NSObject>

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface MSBaseModel : NSObject

- (nullable id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
