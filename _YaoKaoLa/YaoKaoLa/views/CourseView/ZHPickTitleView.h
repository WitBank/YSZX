//
//  ZHPickTitleView.h
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHPickTitleViewDelegate <NSObject>

- (void)selectLeftButton:(BOOL)selectLeft;

@end

@interface ZHPickTitleView : UIView

@property (nonatomic, weak) id <ZHPickTitleViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

- (IBAction)selectedTitleButton:(UIButton *)sender;

- (void)setButtonTitleWithLeft:(NSString *)leftTitle andReight:(NSString *)reightTitle;

@end
