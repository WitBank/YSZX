//
//  CourseChapterDownloadButtonView.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/29.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "CourseChapterDownloadButtonView.h"

@implementation CourseChapterDownloadButtonView
{
    BOOL _leftButtonType;
    BOOL _rightButtonType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonClicked:(UIButton *)sender {
    if (sender.tag == 3001) {
        if (_leftButtonType == NO) {
            [_leftButton setTitle:@"全部暂停" forState:UIControlStateNormal];
            _leftButtonType = YES;
        }else{
            [_leftButton setTitle:@"全部下载" forState:UIControlStateNormal];
            _leftButtonType = NO;
        }
        if (_leftButtonClick) {
            _leftButtonClick(_leftButtonType);
        }
    }else{
        if (_rightButtonClick) {
            _rightButtonClick();
        }
    }
}
@end
