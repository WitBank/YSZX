//
//  InformationTitleView.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum InformationTitleType{
    InformationTitleTypeWithLeft,
    InformationTitleTypeWithCenter,
    InformationTitleTypeWithRight,
}InformationTitleType;

@interface InformationTitleView : UIView

@property (nonatomic, strong) void(^titleSelected)(InformationTitleType);

@property (nonatomic, weak) UIButton *leftButton;
@property (nonatomic, weak) UIButton *centerButton;
@property (nonatomic, weak) UIButton *rightButton;


//@property (weak, nonatomic) IBOutlet UIButton *leftButton;
//@property (weak, nonatomic) IBOutlet UIButton *centerButton;
//@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//
//- (IBAction)buttonClick:(UIButton *)sender;

@end
