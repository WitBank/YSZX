//
//  ZHInformationTableViewCell.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import "ZHCoreDataManage.h"
@implementation ZHInformationTableViewCell
{
    NSString *_newsId;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithModel:(InformationRootHtmlModel *)model andFont:(CGFloat)fontSize
{
    if (model.titleImg != nil && ![model.titleImg isEqualToString:@""]) {
        [_headImageView setImageWithURL:[NSURL URLWithString:model.titleImg]];
    }
    _newsId = model.newsId;
    [_titleLabel setText:model.title];
    [_timeLabel setText:model.pubDate];
    
}

@end
