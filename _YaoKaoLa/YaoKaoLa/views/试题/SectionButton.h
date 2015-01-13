//
//  SectionButton.h
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionModel;

@interface SectionButton : UIButton
{

    
}

@property (nonatomic,assign)BOOL isOn;
//关闭打开
- (void)openSection;
- (void)closeSecton;
- (void)updateData:(SectionModel *)data;

@end
