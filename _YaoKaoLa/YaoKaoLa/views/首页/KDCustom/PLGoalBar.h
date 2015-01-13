//
//  PLGoalBar.h
//  yaokaola
//
//  Created by Mac on 14/12/4.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PLGoalBarPercentLayer.h"
@interface PLGoalBar : UIView
{
    UIImage * thumb;
    
    PLGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
    
}

@property (nonatomic, strong) UILabel *percentLabel;

- (void)setPercent:(int)percent animated:(BOOL)animated;


@end
