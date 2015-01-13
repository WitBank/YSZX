//
//  ViewController.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/25.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
@interface ViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
}
@end

@implementation ViewController

// 判断是否是iphone4设备
#define isPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    float wx = self.view.frame.size.width;
    float wy = self.view.frame.size.height;
    
    //开始
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((wx-140)*0.5, wy - 100, 140, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIScrollView *scollView = [[UIScrollView alloc] init];
    scollView.frame = self.view.frame;
    NSArray *imgs = nil;
    if (isPhone4) {
        imgs = @[@"start_image1.png",@"start_image2.png",@"start_image3.png"];
    }else{
        imgs = @[@"start_image1_568.png",@"start_image2_568.png",@"start_image3_568.png"];
    }
    [self.view addSubview:scollView];
    for (int i = 0; i< 3; ++i) {
        UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(wx*i, 0,wx ,wy)];
        imgv.image = [UIImage imageNamed:imgs[i]];
        [scollView addSubview:imgv];
        if (i == 2) {
            [imgv addSubview:btn];
            imgv.userInteractionEnabled = YES;
        }
    }
    scollView.delegate = self;
    scollView.bounces = NO;
    scollView.showsHorizontalScrollIndicator = NO;
    scollView.contentSize = CGSizeMake(wx*3, 0);
    scollView.pagingEnabled = YES;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5-30, self.view.frame.size.height-40, 60,10)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x2ea4fe);
    _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xaaaaaa);
    [self.view addSubview:_pageControl];
}
//跳过
- (void)btnClicked:(UIButton *)btn
{
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) showMainViewController];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
