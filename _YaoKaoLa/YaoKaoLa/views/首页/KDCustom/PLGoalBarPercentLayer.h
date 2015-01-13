//
//  PLGoalBarPercentLayer.h
//  yaokaola
//
//  Created by Mac on 14/12/4.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PLGoalBarPercentLayer : CALayer
@property (nonatomic) CGFloat percent;
-(void)DrawLeft:(CGContextRef)ctx;
-(void)DrawRight:(CGContextRef)ctx ;

@end
