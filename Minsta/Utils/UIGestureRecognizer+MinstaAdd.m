//
//  UIGestureRecognizer+MinstaAdd.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "UIGestureRecognizer+MinstaAdd.h"
#import <objc/runtime.h>

static const int block_key;

@interface _MSUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _MSUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block {
	self = [super init];
	if (self) {
		_block = [block copy];
	}
	return self;
}

- (void)invoke:(id)sender {
	if (_block) _block(sender);
}

@end

@implementation UIGestureRecognizer (MinstaAdd)

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
	self = [self init];
	[self addActionBlock:block];
	return self;
}

- (void)addActionBlock:(void (^)(id sender))block {
	_MSUIGestureRecognizerBlockTarget *target = [[_MSUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
	[self addTarget:target action:@selector(invoke:)];
	NSMutableArray *targets = [self _MS_allUIGestureRecognizerBlockTargets];
	[targets addObject:target];
}

- (void)removeAllActionBlocks {
	NSMutableArray *targets = [self _MS_allUIGestureRecognizerBlockTargets];
	[targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
	         [self removeTarget:target action:@selector(invoke:)];
	 }];
	[targets removeAllObjects];
}

- (NSMutableArray *)_MS_allUIGestureRecognizerBlockTargets {
	NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
	if (!targets) {
		targets = [NSMutableArray array];
		objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return targets;
}

@end
