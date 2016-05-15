//
//  MSFeedCellNode.h
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class MSPhoto;

@interface MSFeedCellNode : ASCellNode

- (instancetype)initWithPhoto:(MSPhoto *)photo;

@end
