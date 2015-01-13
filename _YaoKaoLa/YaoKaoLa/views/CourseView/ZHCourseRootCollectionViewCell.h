//
//  ZHCourseRootCollectionViewCell.h
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCourseRootSourseModel.h"

@interface ZHCourseRootCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;  //显示图片的imageView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        //显示课程名称的Label
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;     //显示讲师名称的Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        //显示课时的Label

- (void)loadDataWithModel:(ZHCourseRootSourseModel *)model;

@end
