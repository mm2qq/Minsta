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

#define FHPX_BASE_URL_STRING     @"https://api.500px.com/v1/"
#define FHPX_CONSUMER_KEY        @"V0AITekRLDJsvMWIAvrBYoILAOrOQyCPTLdiXeLG"
// FIXME: this id is just for testing
#define FHPX_TEST_USER_ID        17507891

#pragma mark - Utilities

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} \
__weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} \
__block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} \
__weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} \
__block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} \
__typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} \
__typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} \
__typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} \
__typeof__(object) object = block##_##object;
#endif
#endif
#endif

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

static inline CGSize standardSizeForFrameSize(CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return (CGSize){size.width * scale, size.height * scale};
}

/**
 *  Return the 500px image size ID from a CGSize
 *  https://github.com/500px/api-documentation/blob/master/basics/formats_and_terms.md#image-urls-and-image-sizes
 *
 *  @param size CGSize parameter
 *
 *  @return 500px image size ID
 */
static inline NSUInteger imageSizeIdForStandardSize(CGSize size) {
    BOOL isCropped = size.height == size.width;

    if (isCropped) {
        if (70.f >= size.width) {
            return 1;
        } else if (100.f >= size.width) {
            return 100;
        } else if (140.f >= size.width) {
            return 2;
        } else if (200.f >= size.width) {
            return 200;
        } else if (280.f >= size.width) {
            return 3;
        } else if (440.f >= size.width) {
            return 440;
        } else {
            return 600;
        }
    } else {
        if (size.height < size.width) {
            if (300.f >= size.height) {
                return 20;
            } else if (450.f >= size.height) {
                return 31;
            } else if (600.f >= size.height) {
                return 21;
            } else {
                return 6;
            }
        } else {
            if (256.f >= size.width) {
                return 30;
            } else if (900.f >= size.width) {
                return 4;
            } else if (1080.f >= size.width) {
                return 1080;
            } else if (1170.f >= size.width) {
                return 5;
            } else if (1600.f >= size.width) {
                return 1600;
            } else {
                return 2048;
            }
        }
    }

    return 0;
}

#endif /* MinstaMacro_h */
