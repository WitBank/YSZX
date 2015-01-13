//
//  HistoryViewCell.m
//  yaokaola
//
//  Created by Mac on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "HistoryViewCell.h"
#import "HistoryModel.h"

@implementation HistoryViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, self.frame.size.width, 70);
    
    
    
}

- (void)updateData:(HistoryModel *)data
{
   
    self.frame = CGRectMake(0, 0, self.frame.size.width, 70);
    __titleHistory.text = [NSString stringWithFormat:@"%@",data.questionsName];
    __peopleNum.text = [NSString stringWithFormat:@"%@",data.peopleCount];
    __averageCorrect.text = [NSString stringWithFormat:@"%@",data.avgnum];
    __ranking.text = [NSString stringWithFormat:@"%@",data.peoplenum];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
