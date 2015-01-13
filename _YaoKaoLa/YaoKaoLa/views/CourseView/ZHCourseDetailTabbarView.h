//
//  ZHCourseDetailTabbarView.h
//  yaokaola
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHCourseDetailTabbarViewDelegate <NSObject>

- (void)selectButtonWithTag:(NSInteger)tag;

@end

@interface ZHCourseDetailTabbarView : UIView

@property (nonatomic, weak) id <ZHCourseDetailTabbarViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//@property (weak, nonatomic) IBOutlet UIView *leftLine;
//@property (weak, nonatomic) IBOutlet UIView *centerLine;
//@property (weak, nonatomic) IBOutlet UIView *rightLine;

- (IBAction)buttonClicked:(UIButton *)sender;

- (void)setButtonSelectedWithTag:(int)tag;


@end
