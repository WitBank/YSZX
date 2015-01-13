//
//  SectionCell.h
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionModel;

@interface SectionCell : UITableViewCell
{
    UIImageView *_leftImg;
    
    UILabel *_questionsName; //章节名称
    UILabel *_questionsSortId; //章节ID
    UILabel *_questionNum;//已经回答
    UILabel *_totalNum;//总题个数
    UILabel *_CorrectNum; //正确个数
    
    UILabel *avgnum;     //正确率
    
    int percent;
    
}
- (void)updateData:(SectionModel *)data;

@end
