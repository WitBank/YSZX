//
//  CourseChapterDownloadTableView.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseChapterDownloadCell.h"
#import "HTTPDownload.h"

@interface CourseChapterDownloadTableView : UIView<UITableViewDelegate,UITableViewDataSource,HTTPDownloadDelegate>

@property (nonatomic, strong) NSMutableArray *downLoadingArray;     //数据源
@property (nonatomic, strong) NSMutableArray *leftSelectedArray;    //左边按钮选择状态的数组
@property (nonatomic, strong) NSMutableArray *rightSelectedArray;   //右边按钮选择状态的数组
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) void(^playVedio)(NSString *);
@property (nonatomic, strong) void (^changeDownloadType)(BOOL,NSInteger);
@property (nonatomic, strong) void (^buttonViewSelected)(BOOL,BOOL);

+(CourseChapterDownloadTableView *) shareDownloadController;
- (void)addTableView;
- (void)addDownloadWithModel:(ZHCourseChapterModel *)model;
- (void)updataTableView;

@end
