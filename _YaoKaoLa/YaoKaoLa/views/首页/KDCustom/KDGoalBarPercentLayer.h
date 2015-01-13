

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface KDGoalBarPercentLayer : CALayer

@property (nonatomic) CGFloat percent;
@property (nonatomic) UIColor *d_Color;
-(void)DrawLeft:(CGContextRef)ctx;
-(void)DrawRight:(CGContextRef)ctx ;

@end
