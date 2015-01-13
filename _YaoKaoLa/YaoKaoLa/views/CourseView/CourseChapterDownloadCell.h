//
//  CourseChapterDownloadCell.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "ZHCourseChapterModel.h"

typedef enum RightButtonType{
    RightButtonTypeWithNormal,
    RightButtonTypeWithDownload,
    RightButtonTypeWithPlay,
}RightButtonType;

@class CourseChapterDownloadCell;

//@protocol CourseChapterDownloadCellDelegate <NSObject>
//
//- (void)canceledDownload:(CourseChapterDownloadCell *)tableCell;
//- (void)resumeDownload:(CourseChapterDownloadCell *)tableCell;
//
//@end

@interface CourseChapterDownloadCell : UITableViewCell

@property(strong,nonatomic)AFHTTPRequestOperation *downloadMusicOP;   //下载音乐，断点续传;

//@property (nonatomic, assign) id <CourseChapterDownloadCellDelegate>delegate;
@property (nonatomic, strong) ZHCourseChapterModel *model;
@property (nonatomic, assign) int number;
@property (nonatomic, strong) void (^selectLeft)(BOOL);
@property (nonatomic, strong) void (^selectDownload)(RightButtonType);
@property (nonatomic, assign) RightButtonType rightButtonType;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
- (IBAction)chapterDownloadClicked:(UIButton *)sender;

- (void)showLabelDataWithModel:(ZHCourseChapterModel *)model andIsDownLoad:(BOOL)isDownLoad;

- (void)setDownloadButtonType:(RightButtonType)type;

@end


