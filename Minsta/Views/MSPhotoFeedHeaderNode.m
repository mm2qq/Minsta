//
//  MSPhotoFeedHeaderNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoFeedHeaderNode.h"
#import "MSPhoto.h"
#import "MSUser.h"
#import "NSString+MinstaAdd.h"

static const CGFloat kAvatarLeadingMargin = 8.f;
static const CGFloat kAvatarSizeWidth = 36.f;
#define kUserNameFont [UIFont boldSystemFontOfSize:13.f]

@interface MSPhotoFeedHeaderNode ()

@property (nonatomic, strong) MSUser *user;
@property (nonatomic, copy) NSString *photoUrlString;           ///< This property for function button use

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *userNameNode;
@property (nonatomic, strong) ASImageNode *moreNode;

@end

@implementation MSPhotoFeedHeaderNode

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame photo:(MSPhoto *)photo {
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];

        _user = photo.user;
        _photoUrlString = photo.images[0].url ? photo.images[0].url : @"";

        [self _setupSubnodes];
    }

    return self;
}

- (void)layout {
    _avatarNode.frame = (CGRect){kAvatarLeadingMargin, (CGRectGetHeight(self.frame) - kAvatarSizeWidth) / 2.f, kAvatarSizeWidth, kAvatarSizeWidth};

    CGFloat userNameNodeWidth = [_user.userName widthForFont:kUserNameFont];
    CGFloat userNameNodeHeight = [_user.userName heightForFont:kUserNameFont width:userNameNodeWidth];
    _userNameNode.frame = (CGRect){kAvatarLeadingMargin + CGRectGetMaxX(_avatarNode.frame), (CGRectGetHeight(self.frame) - userNameNodeHeight) / 2.f, userNameNodeWidth, userNameNodeHeight};

    _moreNode.frame = (CGRect){CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), (CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)) / 2.f, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)};

    [super layout];
}

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *userPicUrlString = _user.userPicUrl;
    NSString *userName = _user.userName;

    if (userPicUrlString && ![@"" isEqualToString:userPicUrlString]) {
        _avatarNode = [ASNetworkImageNode new];
        _avatarNode.backgroundColor = self.backgroundColor;
        _avatarNode.URL = [NSURL URLWithString:userPicUrlString];
        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
            // make a CGRect with the image's size
            CGRect circleRect = (CGRect){CGPointZero, kAvatarSizeWidth, kAvatarSizeWidth};

            // begin the image context since we're not in a drawRect:
            UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);

            // create a UIBezierPath circle
            UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];

            // clip to the circle
            [circle addClip];

            // draw the image in the circleRect *AFTER* the context is clipped
            [image drawInRect:circleRect];

            // create a border (for white background pictures)
            circle.lineWidth = 1;
            [[UIColor darkGrayColor] set];
            [circle stroke];

            // get an image from the image context
            UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();

            // end the image context since we're not in a drawRect:
            UIGraphicsEndImageContext();

            return roundedImage;
        };

        [self addSubnode:_avatarNode];
    }

    if (userName && ![@"" isEqualToString:userName]) {
        _userNameNode = [ASTextNode new];
        _userNameNode.backgroundColor = self.backgroundColor;
        _userNameNode.attributedString = [[NSAttributedString alloc] initWithString:userName attributes:@{NSFontAttributeName : kUserNameFont}];
        _userNameNode.flexShrink = YES; //if name and username don't fit to cell width, allow username shrink
        _userNameNode.truncationMode = NSLineBreakByTruncatingTail;
        _userNameNode.maximumNumberOfLines = 1;
        
        [self addSubnode:_userNameNode];
    }

    if (![@"" isEqualToString:_photoUrlString]) {
        _moreNode = [ASImageNode new];
        _moreNode.image = [UIImage imageNamed:@"more"];
        _moreNode.contentMode = UIViewContentModeCenter;
        _moreNode.backgroundColor = self.backgroundColor;

        [self addSubnode:_moreNode];
    }
}

@end
