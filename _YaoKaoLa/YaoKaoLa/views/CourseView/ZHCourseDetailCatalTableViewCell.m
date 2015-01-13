//
//  ZHCourseDetailCatalTableViewCell.m
//  yaokaola
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHCourseDetailCatalTableViewCell.h"

@implementation ZHCourseDetailCatalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showLabelWithModelData:(ZHCourseChapterModel *)model andIndex:(int)index andImageSelected:(BOOL)isSelect
{
//    [_chapterNumberLabel setText:[NSString stringWithFormat:@"%d",index]];
    [_chapterTitleLable setText:model.fileName];
    [_chapterTimeLable setText:model.fileTime];
    if (isSelect == YES) {
        [_chapterImageView setImage:[UIImage imageNamed:@"ZH_CourseDetail_Chapter_select@2x"]];
    }
}

@end
