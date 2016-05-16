//
//  MSComment.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSComment.h"
#import "MSUser.h"

@implementation MSComment

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _commentId = [[self objectOrNilForKey:@"id" fromDictionary:dict] unsignedIntegerValue];
        _userId = [[self objectOrNilForKey:@"user_id" fromDictionary:dict] unsignedIntegerValue];
        _toWhomUserId = [[self objectOrNilForKey:@"to_whom_user_id" fromDictionary:dict] unsignedIntegerValue];
        _body = [self objectOrNilForKey:@"body" fromDictionary:dict];
        _createdAt = [self objectOrNilForKey:@"created_at" fromDictionary:dict];
        _parentId = [[self objectOrNilForKey:@"parent_id" fromDictionary:dict] unsignedIntegerValue];
        _user = [MSUser modelObjectWithDictionary:[self objectOrNilForKey:@"user" fromDictionary:dict]];
        NSArray *replies = [self objectOrNilForKey:@"replies" fromDictionary:dict];
        NSMutableArray *newReplies = [NSMutableArray arrayWithCapacity:replies.count];

        for (NSDictionary *replyDict in replies) {
            MSComment *comment = [MSComment modelObjectWithDictionary:replyDict];
            if (!comment) continue;
            [newReplies addObject:comment];
        }

        _replies = newReplies;
    }

    return self;
}

@end
