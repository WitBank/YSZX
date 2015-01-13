//
//  ZHInformationImageHeadView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCourseRootImageModel.h"

@interface ZHInformationImageHeadView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, copy) void(^callBlock)(NSInteger); // 点击后的调用的block
@property (nonatomic, copy) void(^scrollViewCallBlock)(NSInteger); // 视图滚动后回调
@property (nonatomic, assign) UIViewAnimationOptions animationOption; // 动画选项（可选）
@property (nonatomic, assign) UIViewContentMode imageViewsContentMode; // 图片的内容模式，默认为UIViewContentModeScaleToFill

/** 如果用init创建BWMCoverView，则需要更新视图才能够正常使用 */
- (void)updateView;

/** 设置图片点击后的块回调 */
- (void)setCallBlock:(void (^)(NSInteger index))callBlock;

/** 视图滚动后的回调 */
- (void)setScrollViewCallBlock:(void (^)(NSInteger index))scrollViewCallBlock;

/** 设置自动播放 */
- (void)setAutoPlayWithDelay:(NSTimeInterval)second;

/** 停止或恢复自动播放（在设置了自动播放时才有效） */
- (void)stopAutoPlayWithBOOL:(BOOL)isStopAutoPlay;

/**
 * 设置切换时的动画选项，不设置则默认为scrollView滚动动画
 * 提供的动画类型有：
 *   UIViewAnimationOptionTransitionNone
 *   UIViewAnimationOptionTransitionFlipFromLeft
 *   UIViewAnimationOptionTransitionFlipFromRight
 *   UIViewAnimationOptionTransitionCurlUp
 *   UIViewAnimationOptionTransitionCurlDown
 *   UIViewAnimationOptionTransitionCrossDissolve
 *   UIViewAnimationOptionTransitionFlipFromTop
 *   UIViewAnimationOptionTransitionFlipFromBottom
 */
- (void)setAnimationOption:(UIViewAnimationOptions)animationOption;

- (instancetype)initWithFrame:(CGRect)frame andModelArray:(NSArray *)modelArray;

@end
