//
//  ZHCoureseChapterOperCell.m
//  yaokaola
//
//  Created by HuXin on 14/12/25.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHCoureseChapterOperCell.h"

@implementation ZHCoureseChapterOperCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if (_operButtonClick) {
        ChapterOperButtonClick click;
        switch (sender.tag) {
            case 1001:
                click = ChapterOperButtonClickWithPlay;
                break;
            case 1002:
                click = ChapterOperButtonClickWithDownload;
                break;
            case 1003:
                click = ChapterOperButtonClickWithPractice;
                break;
            case 1004:
                click = ChapterOperButtonClickWithCollection;
                break;
            default:
                break;
        }
        _operButtonClick(click);
    }
}
@end
