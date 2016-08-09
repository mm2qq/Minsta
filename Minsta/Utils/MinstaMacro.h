//
//  MinstaMacro.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <pthread.h>
#import <UIKit/UIKit.h>

#ifndef MinstaMacro_h
#define MinstaMacro_h

#pragma mark - 500px

#define FHPX_BASE_URL_STRING          @"https://api.500px.com/v1/"
#define FHPX_CONSUMER_KEY             @"V0AITekRLDJsvMWIAvrBYoILAOrOQyCPTLdiXeLG"
// FIXME: this id is just for testing
#define FHPX_TEST_USER_ID             17507891

#pragma mark - Theme

#define MS_UNCROPPED_PHOTO_RATIO      9.f / 16.f
#define MS_WIHTE_BACKGROUND_COLOR     [UIColor whiteColor]
#define MS_LIGHT_GRAY_TEXT_COLOR      [UIColor lightGrayColor]
#define MS_BAR_TINT_COLOR             [UIColor colorWithRed:.976 green:.976 blue:.976 alpha:1.f]
#define MS_FEED_BOLD_FONT             [UIFont boldSystemFontOfSize:13.f]
#define MS_FEED_REGULAR_FONT          [UIFont systemFontOfSize:13.f]
#define MS_FEED_SMALL_FONT            [UIFont systemFontOfSize:11.f]

#pragma mark - Utilities

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool {} \
	__weak __typeof__(object) weak ## _ ## object = object;
#else
#define weakify(object) autoreleasepool {} \
	__block __typeof__(object) block ## _ ## object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try {} @finally{} {} \
	__weak __typeof__(object) weak ## _ ## object = object;
#else
#define weakify(object) try {} @finally{} {} \
	__block __typeof__(object) block ## _ ## object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool {} \
	__typeof__(object) object = weak ## _ ## object;
#else
#define strongify(object) autoreleasepool {} \
	__typeof__(object) object = block ## _ ## object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try {} @finally{} \
	__typeof__(object) object = weak ## _ ## object;
#else
#define strongify(object) try {} @finally{} \
	__typeof__(object) object = block ## _ ## object;
#endif
#endif
#endif

static inline NSDateFormatter *MSCurrentDateFormatter() {
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [NSDateFormatter new];
	});

	return dateFormatter;
}

/**
 *  Return the 500px image size ID from a CGSize
 *  https://github.com/500px/api-documentation/blob/master/basics/formats_and_terms.md#image-urls-and-image-sizes
 *
 *  @param size CGSize parameter
 *
 *  @return 500px image size ID
 */
static inline NSUInteger MSImageSizeIdForStandardSize(CGSize size) {
	CGFloat scale = [UIScreen mainScreen].scale;
	CGSize newSize = (CGSize){size.width * scale, size.height * scale};
	BOOL cropped = newSize.height == newSize.width;

	if (cropped) {
		if (70.f >= newSize.width) {
			return 1;
		} else if (100.f >= newSize.width && 70.f < newSize.width) {
			return 100;
		} else if (140.f >= newSize.width && 100.f < newSize.width) {
			return 2;
		} else if (200.f >= newSize.width && 140.f < newSize.width) {
			return 200;
		} else if (280.f >= newSize.width && 200.f < newSize.width) {
			return 3;
		} else if (440.f >= newSize.width && 280.f < newSize.width) {
			return 440;
		} else {
			return 600;
		}
	} else {
		if (newSize.height < newSize.width) {
			if (300.f >= newSize.height) {
				return 20;
			} else if (450.f >= newSize.height && 300.f < newSize.width) {
				return 31;
			} else if (600.f >= newSize.height && 450.f < newSize.width) {
				return 21;
			} else {
				return 6;
			}
		} else {
			if (256.f >= newSize.width) {
				return 30;
			} else if (900.f >= newSize.width && 256.f < newSize.width) {
				return 4;
			} else if (1080.f >= newSize.width && 900.f < newSize.width) {
				return 1080;
			} else if (1170.f >= newSize.width && 1080.f < newSize.width) {
				return 5;
			} else if (1600.f >= newSize.width && 1170.f < newSize.width) {
				return 1600;
			} else {
				return 2048;
			}
		}
	}

	return 0;
}

static inline BOOL MSImageCroppedForSizeId(NSUInteger sizeId) {
	NSArray *croppedSizes = @[@1, @2, @3, @100, @200, @440, @600];

	for (NSNumber *croppedSize in croppedSizes) {
		if (croppedSize.unsignedIntegerValue == sizeId) return YES;
	}

	return NO;
}

static inline void dispatch_async_on_main_queue(void (^block)()) {
	if (pthread_main_np()) {
		block();
	} else {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}

static inline void dispatch_async_on_global_queue(void (^block)()) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

#endif /* MinstaMacro_h */
