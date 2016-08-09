//
//  NSString+MinstaAdd.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "NSString+MinstaAdd.h"
#import "MinstaMacro.h"

@implementation NSString (MinstaAdd)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
	CGSize result;
	if (!font) font = [UIFont systemFontOfSize:12];
	if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
		NSMutableDictionary *attr = [NSMutableDictionary new];
		attr[NSFontAttributeName] = font;
		if (lineBreakMode != NSLineBreakByWordWrapping) {
			NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
			paragraphStyle.lineBreakMode = lineBreakMode;
			attr[NSParagraphStyleAttributeName] = paragraphStyle;
		}
		CGRect rect = [self boundingRectWithSize:size
		               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
		               attributes:attr context:nil];
		result = rect.size;
	} else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
	}
	return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
	CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
	return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
	CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
	return size.height;
}

+ (NSString *)elapsedTimeStringSinceDate:(NSString *)dateString {
	if (!dateString) return nil;

	NSDate *postDate = [self dateTimeForRFC3339DateTimeString:dateString];

	if (!postDate) return nil;

	NSDate *currentDate  = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];

	NSUInteger seconds = [calendar components:NSCalendarUnitSecond fromDate:postDate toDate:currentDate options:0].second;
	NSUInteger minutes = [calendar components:NSCalendarUnitMinute fromDate:postDate toDate:currentDate options:0].minute;
	NSUInteger hours   = [calendar components:NSCalendarUnitHour fromDate:postDate toDate:currentDate options:0].hour;
	NSUInteger days    = [calendar components:NSCalendarUnitDay fromDate:postDate toDate:currentDate options:0].day;

	NSString *elapsedTime;

	if (days > 28) {// if date earlier than 4 weeks ago, return locale date formatted string directly
		NSDateFormatter *dateFormatter = MSCurrentDateFormatter();
		dateFormatter.locale = [NSLocale currentLocale];
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		elapsedTime = [dateFormatter stringFromDate:postDate];
	} else if (days > 7) {
		NSUInteger week = ceil(days / 7.0);
		elapsedTime = [NSString stringWithFormat:NSLocalizedString(week > 1 ? @"%d WEEKS AGO" : @"%d WEEK AGO", nil), week];
	} else if (days > 0) {
		NSUInteger day = days;
		elapsedTime = [NSString stringWithFormat:NSLocalizedString(day > 1 ? @"%d DAYS AGO" : @"%d DAY AGO", nil), day];
	} else if (hours > 0) {
		NSUInteger hour = hours;
		elapsedTime = [NSString stringWithFormat:NSLocalizedString(hour > 1 ? @"%d HOURS AGO" : @"%d HOUR AGO", nil), hour];
	} else if (minutes > 0) {
		NSUInteger minute = minutes;
		elapsedTime = [NSString stringWithFormat:NSLocalizedString(minute > 1 ? @"%d MINUTES AGO" : @"%d MINUTE AGO", nil), minute];
	} else if (seconds > 0) {
		NSUInteger second = seconds;
		elapsedTime = [NSString stringWithFormat:NSLocalizedString(second > 1 ? @"%d SECONDS AGO" : @"%d SECOND AGO", nil), second];
	} else if (seconds == 0) {
		elapsedTime = NSLocalizedString(@"JUST NOW", nil);
	} else {
		elapsedTime = nil;
	}

	return elapsedTime;
}

#pragma mark - Private

// Returns a user-visible date time string that corresponds to the
// specified RFC 3339 date time string. Note that this does not handle
// all possible RFC 3339 date time strings, just one of the most common
// styles.
+ (NSDate *)dateTimeForRFC3339DateTimeString:(NSString *)dateString {
	NSDateFormatter *dateFormatter = MSCurrentDateFormatter();
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
	dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'";
	// FIXME:there should exsit timezone problem
	dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

	return [dateFormatter dateFromString:dateString];
}

@end
