//
//  ZHCoureseChapterOperCell.h
//  yaokaola
//
//  Created by HuXin on 14/12/25.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ChapterOperButtonClick
{
    ChapterOperButtonClickWithNone,
    ChapterOperButtonClickWithPlay,             //点击播放按钮
    ChapterOperButtonClickWithDownload,         //点击下载按钮
    ChapterOperButtonClickWithPractice,         //点击练习按钮
    ChapterOperButtonClickWithCollection,       //点击收藏按钮
}ChapterOperButtonClick;

@interface ZHCoureseChapterOperCell : UITableViewCell

@property (nonatomic, strong) void (^operButtonClick)(ChapterOperButtonClick);

@property (weak, nonatomic) IBOutlet UIButton *operPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *operDownloadButton;
@property (weak, nonatomic) IBOutlet UIButton *operPracticeButton;
@property (weak, nonatomic) IBOutlet UIButton *operCollectionButton;
- (IBAction)buttonClicked:(UIButton *)sender;

@end
