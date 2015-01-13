//
//  InformationTitleView.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "InformationTitleView.h"
#import "ZHCustomControl.h"

@implementation InformationTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftButton = [ZHCustomControl _customUIButtonWithTitle:@"考点直击"
                                                        andFont:15.0f
                                                  andTitleColor:TITLECOLOR_BLUE
                                                      andTarget:self
                                                         andSEL:@selector(buttonClick:)
                                                andControlEvent:UIControlEventTouchUpInside
                                                     andBGImage:nil
                                                       andFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height)];
        [_leftButton setTag:401];
        [self addSubview:_leftButton];
        _centerButton = [ZHCustomControl _customUIButtonWithTitle:@"报考须知"
                                                          andFont:15.0f
                                                    andTitleColor:[UIColor blackColor]
                                                        andTarget:self
                                                           andSEL:@selector(buttonClick:)
                                                  andControlEvent:UIControlEventTouchUpInside
                                                       andBGImage:nil
                                                         andFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height)];
        [_centerButton setTag:402];
        [self addSubview:_centerButton];
        _rightButton = [ZHCustomControl _customUIButtonWithTitle:@"最新动态"
                                                         andFont:15.0f
                                                   andTitleColor:[UIColor blackColor]
                                                       andTarget:self
                                                          andSEL:@selector(buttonClick:)
                                                 andControlEvent:UIControlEventTouchUpInside
                                                      andBGImage:nil
                                                        andFrame:CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, self.frame.size.height)];
        [_rightButton setTag:403];
        [self addSubview:_rightButton];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (_titleSelected) {
        InformationTitleType type;
        switch (button.tag) {
            case 401:
                [_leftButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                type = InformationTitleTypeWithLeft;
                break;
            case 402:
                [_centerButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                type = InformationTitleTypeWithCenter;
                break;
            case 403:
                [_rightButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                type = InformationTitleTypeWithRight;
                break;
            default:
                break;
        }
        _titleSelected(type);
    }
}
//- (IBAction)buttonClick:(UIButton *)sender {
//    if (_titleSelected) {
//        InformationTitleType type;
//        switch (sender.tag) {
//            case 401:
//                [_leftButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
//                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                type = InformationTitleTypeWithLeft;
//                break;
//            case 402:
//                [_centerButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
//                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                type = InformationTitleTypeWithCenter;
//                break;
//            case 403:
//                [_rightButton setTitleColor:TITLECOLOR_BLUE forState:UIControlStateNormal];
//                [_centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                type = InformationTitleTypeWithRight;
//                break;
//            default:
//                break;
//        }
//        _titleSelected(type);
//    }
//
//}
@end
