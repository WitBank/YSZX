#import "KDGoalBarPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)
//圆环大小
#define innerRadius    42           //62.5
#define outerRadius    50      //70.5

@implementation KDGoalBarPercentLayer
@synthesize percent;
@synthesize d_Color;

-(void)drawInContext:(CGContextRef)ctx {
    
    //7
    [self DrawRight:ctx];
    [self DrawLeft:ctx];
    
}
-(void)DrawRight:(CGContextRef)ctx {
    
    //8
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = -toRadians(360 * percent);

    //进度颜色  红
    
    if (d_Color == nil) {
        CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0].CGColor);
    }else{
        CGContextSetFillColorWithColor(ctx,d_Color.CGColor);
    }
    
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

-(void)DrawLeft:(CGContextRef)ctx {
    //9
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = toRadians(360 * (1-percent));

    
    //进度颜色 239, 239, 239灰
    if (d_Color == nil) {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0].CGColor);
    }else{
        CGContextSetFillColorWithColor(ctx, d_Color.CGColor);
    }
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

- (void)setD_Color:(UIColor *)color
{
    d_Color = color;
    [self needsDisplay];
}

@end
