//
//  ZHCourseDetailTabbarView.m
//  yaokaola
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHCourseDetailTabbarView.h"

@implementation ZHCourseDetailTabbarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectButtonWithTag:)]) {
        switch (sender.tag) {
            case 101:
//                [_leftLine setHidden:NO];
//                [_centerLine setHidden:YES];
//                [_rightLine setHidden:YES];
                [_leftButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            case 102:
//                [_leftLine setHidden:YES];
//                [_centerLine setHidden:NO];
//                [_rightLine setHidden:YES];
                [_centerButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            case 103:
//                [_leftLine setHidden:YES];
//                [_centerLine setHidden:YES];
//                [_rightLine setHidden:NO];
                [_rightButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [_delegate selectButtonWithTag:sender.tag];
    }
}

- (void)setButtonSelectedWithTag:(int)tag
{
    switch (tag) {
        case 0:
            [_leftButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
            [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 1:
            [_centerButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
            [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 2:
            [_rightButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
            [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
