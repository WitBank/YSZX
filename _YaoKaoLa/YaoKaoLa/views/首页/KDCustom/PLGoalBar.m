//
//  PLGoalBar.m
//  yaokaola
//
//  Created by Mac on 14/12/4.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "PLGoalBar.h"

@implementation PLGoalBar
@synthesize    percentLabel;

#pragma Init & Setup
- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    //2
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    
    return self;
}


-(void)layoutSubviews {
    CGRect frame = self.frame;
    int percent = percentLayer.percent * 100;
    //百分号 6
    [percentLabel setText:[NSString stringWithFormat:@"%i%%", percent]];
    percentLabel.font = [UIFont fontWithName:nil size:20];
    
    CGRect labelFrame = percentLabel.frame;
    labelFrame.origin.x = frame.size.width / 2 - percentLabel.frame.size.width / 2;
    labelFrame.origin.y = frame.size.height / 2 - percentLabel.frame.size.height / 2 - 20;
    percentLabel.frame = labelFrame;
    
    [super layoutSubviews];
}

-(void)setup {
    
    //大方块颜色  3
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, 100, 100);
    
    self.clipsToBounds = NO;
    
    //字体大小
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [percentLabel setFont:[UIFont systemFontOfSize:20]];
    
    
    //字体颜色
    //    [percentLabel setTextColor:[UIColor greenColor]];
    [percentLabel setTextColor:[UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0]];
    //字体位置
    percentLabel.frame = CGRectMake(20, 20, 50, 30);
    [percentLabel setTextAlignment:UITextAlignmentCenter];
    
    //百分比label颜色
    
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    // 自适应
    percentLabel.adjustsFontSizeToFitWidth = YES;
    //    percentLabel.minimumFontSize = 20;
    [self addSubview:percentLabel];
    
    thumbLayer = [CALayer layer];
    thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    thumbLayer.contents = (id) thumb.CGImage;
    thumbLayer.frame = CGRectMake(self.frame.size.width / 2 - thumb.size.width/2, 0, thumb.size.width, thumb.size.height);
    thumbLayer.hidden = YES;
    
    
    
    percentLayer = [PLGoalBarPercentLayer layer];
    percentLayer.contentsScale = [UIScreen mainScreen].scale;
    percentLayer.percent = 0;
    percentLayer.frame = self.bounds;
    percentLayer.masksToBounds = NO;
    [percentLayer setNeedsDisplay];
    
    [self.layer addSublayer:percentLayer];
    [self.layer addSublayer:thumbLayer];
    
    
}


#pragma mark - Touch Events
- (void)moveThumbToPosition:(CGFloat)angle {
    CGRect rect = thumbLayer.frame;
    //       5
 //   NSLog(@"%@",NSStringFromCGRect(rect));
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    angle -= (M_PI/2);
  //  NSLog(@"%f",angle);
    
    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
   // NSLog(@"%@",NSStringFromCGRect(rect));
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    thumbLayer.frame = rect;
    
    [CATransaction commit];
}
#pragma mark - Custom Getters/Setters
- (void)setPercent:(int)percent animated:(BOOL)animated {
    //4
    CGFloat floatPercent = percent / 100.0;
    floatPercent = MIN(1, MAX(0, floatPercent));
    
    percentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
    
    [self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    
}
@end
