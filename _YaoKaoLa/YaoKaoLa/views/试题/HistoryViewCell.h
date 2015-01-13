//
//  HistoryViewCell.h
//  yaokaola
//
//  Created by Mac on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryModel;

@interface HistoryViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *_titleHistory;
@property (weak, nonatomic) IBOutlet UILabel *_peopleNum;

@property (weak, nonatomic) IBOutlet UILabel *_averageCorrect;
@property (weak, nonatomic) IBOutlet UILabel *_ranking;
@property(nonatomic,retain)HistoryModel *historyModel;
- (void)updateData:(HistoryModel *)data;


@end
