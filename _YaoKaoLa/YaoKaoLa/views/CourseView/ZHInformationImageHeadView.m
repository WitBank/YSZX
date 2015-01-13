//
//  ZHInformationImageHeadView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationImageHeadView.h"
#import <UIImageView+AFNetworking.h>

@implementation ZHInformationImageHeadView
{
    NSTimeInterval _second;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andModelArray:(NSArray *)modelArray
{
    _modelArray = [NSMutableArray arrayWithArray:modelArray];
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05f]];
        [self addScrollView];
    }
    return self;
}

- (void)addScrollView
{
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 , self.frame.size.width,self.frame.size.height-25*WIDTHPROPORTION)];
    [_imageScrollView setBackgroundColor:[UIColor blackColor]];
    [_imageScrollView setShowsHorizontalScrollIndicator:NO];
    [_imageScrollView setShowsVerticalScrollIndicator:NO];
    [_imageScrollView setPagingEnabled:YES];
    [_imageScrollView setBounces:NO];
    [_imageScrollView setDelegate:self];
    [self addSubview:_imageScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width- 50*WIDTHPROPORTION, self.frame.size.height-25*WIDTHPROPORTION, 30*WIDTHPROPORTION, 25*WIDTHPROPORTION)];
    _pageControl.userInteractionEnabled = YES;
    _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]];
    [self addSubview:_pageControl];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTHPROPORTION, self.frame.size.height-25*WIDTHPROPORTION, self.frame.size.width-15*WIDTHPROPORTION - 65*WIDTHPROPORTION, 25*WIDTHPROPORTION)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [self addSubview:_titleLabel];
    
    [self updateView];
}

// 更新视图
- (void)updateView
{
    _imageScrollView.contentSize = CGSizeMake((_modelArray.count+2)*_imageScrollView.frame.size.width, _imageScrollView.frame.size.height);
    _imageScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    // 清除所有滚动视图
    for (UIView *view in _imageScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i<_modelArray.count+2; i++) {
        ZHCourseRootImageModel *model = nil;
        if (i == 0) {
            model = [_modelArray lastObject];
        } else if(i == _modelArray.count+1) {
            model = [_modelArray firstObject];
        } else {
            model = [_modelArray objectAtIndex:i-1];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_imageScrollView.frame.size.width, 0, _imageScrollView.frame.size.width, _imageScrollView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i-1;
        [imageView setImageWithURL:[NSURL URLWithString:model.titleImg]];
        [_imageScrollView addSubview:imageView];
        
        if (i>0 &&i<_modelArray.count+1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
            [imageView addGestureRecognizer:tap];
        }
        //设置titleLabel和pageControl的相关内容数据
        if (_modelArray.count>0 && i == 0) {
            _titleLabel.text = model.title;
            
            _pageControl.numberOfPages = _modelArray.count;
            [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    // 先执行一次这个方法
    if (_scrollViewCallBlock != nil)
    {
        _scrollViewCallBlock(0);
    }
}

// pageControl修改事件
- (void)pageControlClicked:(UIPageControl *)pageControl
{
    [self scrollViewScrollToPageIndex:pageControl.currentPage+1];
}

// 图片轻敲手势事件
- (void)imageViewClicked:(UITapGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    if (_callBlock != nil) {
        _callBlock(index);
    }
}

// 设置自动播放
- (void)setAutoPlayWithDelay:(NSTimeInterval)second
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    _second = second;
    _timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(scrollViewAutoScrolling) userInfo:nil repeats:YES];
}

// 暂停或开启自动播放
- (void)stopAutoPlayWithBOOL:(BOOL)isStopAutoPlay
{
    if (_timer) {
        if (isStopAutoPlay) {
            [_timer invalidate];
        } else {
            _timer = [NSTimer scheduledTimerWithTimeInterval:_second target:self selector:@selector(scrollViewAutoScrolling) userInfo:nil repeats:YES];
        }
    }
}

// 自动滚动
- (void)scrollViewAutoScrolling
{
    CGPoint point;
    point = _imageScrollView.contentOffset;
    point.x += _imageScrollView.frame.size.width;
    
    [self animationScrollWithPoint:point];
}

// 滚动到指定的页面
- (void)scrollViewScrollToPageIndex:(NSInteger)page
{
    CGPoint point;
    point = CGPointMake(_imageScrollView.frame.size.width*page, 0);
    
    [self animationScrollWithPoint:point];
}

// 滚动到指点的point
- (void)animationScrollWithPoint:(CGPoint)point
{
    // 判断是否是需要动画
    if (_animationOption != 0 << 20) {
        _imageScrollView.contentOffset = point;
        [self scrollViewDidEndDecelerating:_imageScrollView];
        [UIView transitionWithView:_imageScrollView duration:0.7 options:_animationOption animations:nil completion:nil];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _imageScrollView.contentOffset = point;
        }completion:^(BOOL finished) {
            if (finished) {
                [self scrollViewDidEndDecelerating:_imageScrollView];
            }
        }];
    }
}


- (void)setScrollViewCallBlock:(void (^)(NSInteger index))scrollViewCallBlock
{
    _scrollViewCallBlock = [scrollViewCallBlock copy];
    _scrollViewCallBlock(0);
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止自动播放
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 设置伪循环滚动
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*scrollView.frame.size.width, 0);
        
    } else if(scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    
    int currentPage = scrollView.contentOffset.x/self.frame.size.width-1;
    _pageControl.currentPage = currentPage;
    
     //设置titleLabel
    if (_modelArray.count>0) {
        _titleLabel.text = ((ZHCourseRootImageModel *)_modelArray[currentPage]).title;
    }
    
    // 恢复自动播放
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_second]];
    }
    
    if(_scrollViewCallBlock != nil)
    {
        _scrollViewCallBlock(currentPage);
    }
}


@end
