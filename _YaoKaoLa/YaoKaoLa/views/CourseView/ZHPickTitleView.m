//
//  ZHPickTitleView.m
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHPickTitleView.h"

@implementation ZHPickTitleView
{
    NSInteger _lastButtonTag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setButtonTitleWithLeft:(NSString *)leftTitle andReight:(NSString *)reightTitle
{
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [_rightButton setTitle:reightTitle forState:UIControlStateNormal];
}

- (IBAction)selectedTitleButton:(UIButton *)sender {
    if (_lastButtonTag != sender.tag && _delegate && [_delegate respondsToSelector:@selector(selectLeftButton:)]){
        if (sender.tag == 101) {
            [_leftLine setHidden:NO];
            [_rightLine setHidden:YES];
            [_delegate selectLeftButton:YES];
        }else if (sender.tag == 102){
            [_leftLine setHidden:YES];
            [_rightLine setHidden:NO];
            [_delegate selectLeftButton:NO];
        }
        _lastButtonTag = sender.tag;
    }
}
@end
