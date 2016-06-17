//
//  ZBJBPerformanceLabel.m
//  ZBJBuyer
//
//  Created by mdd jjj on 16/6/16.
//  Copyright © 2016年 Chongqing ZhuBaJie Network Co. Ltd. All rights reserved.
//

#import "ZBJBPerformanceLabel.h"
#import "ZBJBWeakProxy.h"
#import <mach/mach.h>

#define kSize CGSizeMake(110, 60)

static float cpuUsage() {
	kern_return_t kr;
	task_info_data_t tinfo;
	mach_msg_type_number_t task_info_count;

	task_info_count = TASK_INFO_MAX;
	kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}

	task_basic_info_t basic_info;
	thread_array_t thread_list;
	mach_msg_type_number_t thread_count;

	thread_info_data_t thinfo;
	mach_msg_type_number_t thread_info_count;

	thread_basic_info_t basic_info_th;
	uint32_t stat_thread = 0; // Mach threads

	basic_info = (task_basic_info_t)tinfo;

	// get threads in the task
	kr = task_threads(mach_task_self(), &thread_list, &thread_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}
	if (thread_count > 0)
		stat_thread += thread_count;

	long tot_sec = 0;
	long tot_usec = 0;
	float tot_cpu = 0;
	int j;

	for (j = 0; j < thread_count; j++) {
		thread_info_count = THREAD_INFO_MAX;
		kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
		                 (thread_info_t)thinfo, &thread_info_count);
		if (kr != KERN_SUCCESS) {
			return -1;
		}

		basic_info_th = (thread_basic_info_t)thinfo;

		if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
			tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
			tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
		}
	} // for each thread

	kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
	assert(kr == KERN_SUCCESS);

	return tot_cpu;
}

static NSDictionary *memoryUsage() {
	// used memory
	struct mach_task_basic_info info;
	mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
	kern_return_t kerr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
	mach_vm_size_t mem_used = (kerr == KERN_SUCCESS) ? info.resident_size >> 10 >> 10 : 0;

	// free memory
	mach_port_t host_port = mach_host_self();
	mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	vm_size_t pagesize;
	vm_statistics_data_t vm_stat;

	host_page_size(host_port, &pagesize);
	(void)host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
	vm_size_t mem_free = vm_stat.free_count * pagesize >> 10 >> 10;

	return @{ @"usedMemory" : @(mem_used),
			  @"freeMemory" : @(mem_free),
			  @"totalMemory" : @(mem_used + mem_free) };
}

@implementation ZBJBPerformanceLabel {
	CADisplayLink *_link;
	NSUInteger _count;
	NSTimeInterval _lastTime;
	UIFont *_font;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (frame.size.width == 0 && frame.size.height == 0) {
		frame.size = kSize;
	}

	self = [super initWithFrame:frame];

	self.layer.cornerRadius = 5;
	self.clipsToBounds = YES;
	self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 3;
	self.userInteractionEnabled = NO;
	self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];

	_font = [UIFont fontWithName:@"Menlo" size:14];

	ZBJBWeakProxy *weakProxy = [ZBJBWeakProxy proxyWithTarget:self];
	_link = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(tick:)];
	[_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

	return self;
}

- (void)dealloc {
	[_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return kSize;
}

- (void)tick:(CADisplayLink *)link {
    // calculate fps
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }

    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;

    if (delta < 1) return;

    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;

    // populate text
	float cpu = cpuUsage();
	NSDictionary *memDic = memoryUsage();
	NSString *text = [NSString stringWithFormat:@"FPS: %d\nCPU: %.1f%%\nMEM: %@MB", (int)round(fps), cpu, memDic[@"usedMemory"]];

	NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName : _font, NSForegroundColorAttributeName : [UIColor whiteColor] }];
	NSArray *subStrings = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	[subStrings enumerateObjectsUsingBlock: ^(NSString *_Nonnull subString, NSUInteger idx, BOOL *_Nonnull stop) {
	    if (idx % 2 != 0) {
	        CGFloat progress;

	        switch (idx) {
				case 1:
					progress = fps / 60.0;
					break;
				case 3:
					progress = 1 - cpu / 100.0;
					break;
				case 5:
					progress = [memDic[@"freeMemory"] unsignedIntValue] / (1.0 * [memDic[@"totalMemory"] unsignedIntValue]);
					break;
				default:
					break;
			}

	        UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
	        NSRange range = [text rangeOfString:subString];
	        [attrText addAttributes:@{ NSForegroundColorAttributeName : color } range:range];
		}
	}];

	self.attributedText = attrText;
}

@end
