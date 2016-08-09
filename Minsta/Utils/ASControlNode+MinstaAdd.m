//
//  ASControlNode+MinstaAdd.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "ASControlNode+MinstaAdd.h"
#import <objc/runtime.h>

static const int block_key;

@interface _MSASControlNodeBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) ASControlNodeEvent events;

- (id)initWithBlock:(void (^)(id sender))block events:(ASControlNodeEvent)events;
- (void)invoke:(id)sender;

@end

@implementation _MSASControlNodeBlockTarget

- (id)initWithBlock:(void (^)(id sender))block events:(ASControlNodeEvent)events {
	self = [super init];
	if (self) {
		_block = [block copy];
		_events = events;
	}
	return self;
}

- (void)invoke:(id)sender {
	if (_block) _block(sender);
}

@end

@implementation ASControlNode (MinstaAdd)

- (void)removeAllTargets {
	[[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
	         [self removeTarget:object action:NULL forControlEvents:ASControlNodeEventAllEvents];
	 }];
	[[self _MS_allASControlNodeBlockTargets] removeAllObjects];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEvents {
	if (!target || !action || !controlEvents) return;
	NSSet *targets = [self allTargets];
	for (id currentTarget in targets) {
		NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
		for (NSString *currentAction in actions) {
			[self removeTarget:currentTarget action:NSSelectorFromString(currentAction)
			 forControlEvents:controlEvents];
		}
	}
	[self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addBlockForControlEvents:(ASControlNodeEvent)controlEvents
        block:(void (^)(id sender))block {
	if (!controlEvents) return;
	_MSASControlNodeBlockTarget *target = [[_MSASControlNodeBlockTarget alloc]
	                                       initWithBlock:block events:controlEvents];
	[self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
	NSMutableArray *targets = [self _MS_allASControlNodeBlockTargets];
	[targets addObject:target];
}

- (void)setBlockForControlEvents:(ASControlNodeEvent)controlEvents
        block:(void (^)(id sender))block {
	[self removeAllBlocksForControlEvents:ASControlNodeEventAllEvents];
	[self addBlockForControlEvents:controlEvents block:block];
}

- (void)removeAllBlocksForControlEvents:(ASControlNodeEvent)controlEvents {
	if (!controlEvents) return;

	NSMutableArray *targets = [self _MS_allASControlNodeBlockTargets];
	NSMutableArray *removes = [NSMutableArray array];
	for (_MSASControlNodeBlockTarget *target in targets) {
		if (target.events & controlEvents) {
			ASControlNodeEvent newEvent = target.events & (~controlEvents);
			if (newEvent) {
				[self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
				target.events = newEvent;
				[self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
			} else {
				[self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
				[removes addObject:target];
			}
		}
	}
	[targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_MS_allASControlNodeBlockTargets {
	NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
	if (!targets) {
		targets = [NSMutableArray array];
		objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return targets;
}

@end
