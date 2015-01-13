//
//  ZHCourseDetailCatalTableViewCell.h
//  yaokaola
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCourseChapterModel.h"

@interface ZHCourseDetailCatalTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *chapterNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chapterImageView;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *chapterTimeLable;

- (void)showLabelWithModelData:(ZHCourseChapterModel *)model andIndex:(int)index andImageSelected:(BOOL)isSelect;

@end
