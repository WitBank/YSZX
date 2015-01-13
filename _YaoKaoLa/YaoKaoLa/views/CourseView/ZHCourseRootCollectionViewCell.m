//
//  ZHCourseRootCollectionViewCell.m
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHCourseRootCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ZHCourseRootCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    CGFloat borderWidth = 1.0f;
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    bgView.layer.borderWidth = borderWidth;
    self.backgroundView = bgView;
    [_nameLabel setBackgroundColor:[UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f]];
}

- (void)loadDataWithModel:(ZHCourseRootSourseModel *)model
{
    [_m_imageView setImageWithURL:[NSURL URLWithString:model.courseImg]];
    [_nameLabel setText:model.courseName];
//    [_teacherLabel setText:model.teacher];
    [_timeLabel setText:model.endTime];
    NSString *teacherString = [NSString stringWithFormat:@"%@",model.teacher];
    [_teacherLabel setText:teacherString];
//    UIFont *bfont =[UIFont systemFontOfSize:11.0f];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:bfont forKey:NSFontAttributeName];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:teacherString attributes:dic];
//    [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:[UIColor colorWithRed:0 green:150.0f/255.0f blue:1 alpha:1] range:NSMakeRange(0, 3)];
//    [_teacherLabel setAttributedText:str];
}

@end
