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
#import "MinstaMacro.h"
#import "NSString+MinstaAdd.h"
#import "UIGestureRecognizer+MinstaAdd.h"
#import "ASControlNode+MinstaAdd.h"
#import "UIImage+MinstaAdd.h"

static const CGFloat kAvatarLeadingMargin = 12.f;
static const CGFloat kAvatarSizeWidth = 36.f;

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
        self.backgroundColor = MS_WIHTE_BACKGROUND_COLOR;

        _user = photo.user;
        _photoUrlString = photo.images[0].url ? photo.images[0].url : @"";

        [self _setupSubnodes];
        [self _addActions];
    }

    return self;
}

- (void)dealloc {
    [self _removeActions];
}

- (void)layout {
    _avatarNode.frame = (CGRect){kAvatarLeadingMargin, (CGRectGetHeight(self.frame) - kAvatarSizeWidth) / 2.f, kAvatarSizeWidth, kAvatarSizeWidth};

    CGFloat userNameNodeWidth = [_user.userName widthForFont:MS_FEED_BOLD_FONT];
    CGFloat userNameNodeHeight = [_user.userName heightForFont:MS_FEED_BOLD_FONT width:userNameNodeWidth];
    _userNameNode.frame = (CGRect){kAvatarLeadingMargin + CGRectGetMaxX(_avatarNode.frame), (CGRectGetHeight(self.frame) - userNameNodeHeight) / 2.f, userNameNodeWidth, userNameNodeHeight};

    _moreNode.frame = (CGRect){CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), (CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)) / 2.f, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)};

    [super layout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // ASDisplayNode had become the delegate of UIGestureRecognizer, there's no need set delegate by self
    return !CGRectContainsPoint(_moreNode.frame, [gestureRecognizer locationInView:self.view]);
}

#pragma mark - Actions

- (void)headerNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"show %@", _user.userName] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)moreNodeDidTapped {
    // TODO:this alert just for test
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:_photoUrlString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *userPicUrlString = _user.userPicUrl;
    NSString *userName = _user.userName;

    if (userPicUrlString && ![@"" isEqualToString:userPicUrlString]) {
        _avatarNode = [ASNetworkImageNode new];
        _avatarNode.backgroundColor = self.backgroundColor;
        // set default image to avoid user's avatar can not access
        _avatarNode.defaultImage = [UIImage imageWithColor:self.backgroundColor size:(CGSize){kAvatarSizeWidth, kAvatarSizeWidth}];
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
            [MS_LIGHT_GRAY_TEXT_COLOR set];
            [circle stroke];

            // get an image from the image context
            UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();

            // end the image context since we're not in a drawRect:
            UIGraphicsEndImageContext();

            return roundedImage;
        };
        _avatarNode.layerBacked = YES;

        [self addSubnode:_avatarNode];
    }

    if (userName && ![@"" isEqualToString:userName]) {
        _userNameNode = [ASTextNode new];
        _userNameNode.backgroundColor = self.backgroundColor;
        _userNameNode.attributedText = [[ASMutableAttributedStringBuilder alloc] initWithString:userName attributes:@{NSFontAttributeName : MS_FEED_BOLD_FONT}];
        _userNameNode.flexShrink = YES; //if name and username don't fit to cell width, allow username shrink
        _userNameNode.truncationMode = NSLineBreakByTruncatingTail;
        _userNameNode.maximumNumberOfLines = 1;
        _userNameNode.layerBacked = YES;

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

- (void)_addActions {
    @weakify(self)
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithActionBlock:^(id  _Nonnull sender)
                                     {
                                         @strongify(self)
                                         [self headerNodeDidTapped];
                                     }]];

    [_moreNode setBlockForControlEvents:ASControlNodeEventTouchUpInside
                                  block:^(id  _Nonnull sender)
     {
         @strongify(self)
         [self moreNodeDidTapped];
     }];
}

- (void)_removeActions {
    [self.view.gestureRecognizers makeObjectsPerformSelector:@selector(removeAllActionBlocks)];
    [_moreNode removeAllBlocksForControlEvents:ASControlNodeEventTouchUpInside];
}

@end
