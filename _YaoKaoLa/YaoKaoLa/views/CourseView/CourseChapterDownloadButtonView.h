//
//  CourseChapterDownloadButtonView.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/29.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseChapterDownloadButtonView : UIView

@property (nonatomic, strong) void(^leftButtonClick)(BOOL);
@property (nonatomic, strong) void(^rightButtonClick)(void);

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)buttonClicked:(UIButton *)sender;

@end
