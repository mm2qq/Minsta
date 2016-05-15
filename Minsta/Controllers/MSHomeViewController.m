//
//  MSHomeViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSHomeOperation.h"
#import "MSFeedCellNode.h"
#import "MSPhoto.h"
#import "MinstaMacro.h"

// TODO:should not use this id
static const NSUInteger MSTestUserId = 17507891;

@interface MSHomeViewController () <ASTableDataSource, ASTableDelegate>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPages;
@property (nonatomic, assign) NSUInteger totalItems;
@property (nonatomic, copy) NSMutableArray<MSPhoto *> *photos;

@end

@implementation MSHomeViewController

#pragma mark - Lifecycle

- (instancetype)init {
    ASTableNode *tableNode = [ASTableNode new];

    if (self = [super initWithNode:tableNode]) {
        tableNode.dataSource = self;
        tableNode.delegate = self;

        _currentPage = 0;
        _totalPages = 0;
        _totalItems = 0;
        _photos = [NSMutableArray array];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _loadPhotosWithContext:nil atPage:++_currentPage];
}

#pragma mark - Getters & setters

#pragma mark - ASTableDataSource & ASTableDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == _photos.count ? 0 : 1;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSPhoto *photo = _photos[indexPath.row];

    return ^ASCellNode *() {
        MSFeedCellNode *cellNode = [[MSFeedCellNode alloc] initWithPhoto:photo];
        return cellNode;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, tableView.frame.size.width, 40.f}];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self _loadPhotosWithContext:context atPage:++_currentPage];
}

#pragma mark - Private

- (void)_loadPhotosWithContext:(ASBatchContext *)context atPage:(NSUInteger)page {
    dispatch_async_on_global_queue(^{
        CGSize screenSize   = [UIScreen mainScreen].bounds.size;

        [[MSHomeOperation sharedInstance] retrievePhotosWithUserId:MSTestUserId
                                                         imageSize:standardSizeForFrameSize((CGSize){screenSize.width, screenSize.width})
                                                            atPage:page
                                                        completion:^(id  _Nullable data, NSError * _Nullable error)
         {
             if (!data || error) {
                 NSLog(@"%@", error.localizedDescription);
                 return;
             }

             NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

             if ([response isKindOfClass:[NSDictionary class]]) {
                 _currentPage = [response[@"current_page"] unsignedIntegerValue];
                 _totalPages  = [response[@"total_pages"] unsignedIntegerValue];
                 _totalItems  = [response[@"total_items"] unsignedIntegerValue];
                 NSArray *photos = response[@"photos"];

                 for (NSDictionary *photoDict in photos) {
                     MSPhoto *photo = [MSPhoto modelObjectWithDictionary:photoDict];
                     [_photos addObject:photo];
                 }
             }
         }];

        dispatch_async_on_main_queue(^{
            ASTableNode *tableNode = (ASTableNode *)self.node;
            [tableNode.view reloadData];

            if (context) {
                [context completeBatchFetching:YES];
            }
        });
    });
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
