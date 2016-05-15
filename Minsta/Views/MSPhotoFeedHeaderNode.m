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

@interface MSPhotoFeedHeaderNode ()

@property (nonatomic, strong) MSUser *user;
@property (nonatomic, copy) NSString *photoUrlString;           ///< This property for function button use

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *userNameNode;

@end

@implementation MSPhotoFeedHeaderNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _user = photo.user;
        _photoUrlString = photo ? photo.images[0][@"url"] : @"";

        [self _setupSubnodes];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _avatarNode.preferredFrameSize = CGSizeMake(30.f, 30.f);
    _userNameNode.spacingBefore    = 10.f;
    UIEdgeInsets avatarInsets      = UIEdgeInsetsMake(10.f, 0.f, 10.f, 10.f);
    ASInsetLayoutSpec *avatarInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:avatarInsets child:_avatarNode];

    ASStackLayoutSpec *headerStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    headerStack.alignItems         = ASStackLayoutAlignItemsCenter; // center items vertically in horizontal stack
    headerStack.justifyContent     = ASStackLayoutJustifyContentStart; // justify content to the left side of the header stack
    [headerStack setChildren:@[avatarInset, _userNameNode]];

    // header inset stack
    UIEdgeInsets insets                = UIEdgeInsetsMake(0, 10.f, 0, 10.f);
    ASInsetLayoutSpec *headerWithInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:headerStack];

    return headerWithInset;
}

#pragma mark - Private

- (void)_setupSubnodes {
    if (![@"" isEqualToString:_user.userPicUrl]) {
        _avatarNode = [ASNetworkImageNode new];
        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _avatarNode.URL = [NSURL URLWithString:_user.userPicUrl];
        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
            // make a CGRect with the image's size
            CGRect circleRect = (CGRect){CGPointZero, (CGSize){30.f, 30.f}};

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

        _userNameNode = [ASTextNode new];
        _userNameNode.attributedString = [[NSAttributedString alloc] initWithString:_user.userName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        _userNameNode.flexShrink = YES; //if name and username don't fit to cell width, allow username shrink
        _userNameNode.truncationMode = NSLineBreakByTruncatingTail;
        _userNameNode.maximumNumberOfLines = 1;

        [self addSubnode:_avatarNode];
        [self addSubnode:_userNameNode];
    }
}

@end
