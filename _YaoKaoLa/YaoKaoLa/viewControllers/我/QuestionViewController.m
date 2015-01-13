//
//  QuestionViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "QuestionViewController.h"

#define QUESTIONVIEWCONTROLLER @"QuestionViewController"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"常见问题"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
    UIButton *backButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:1.0f
                                                       andTitleColor:nil
                                                           andTarget:self
                                                              andSEL:@selector(backClick)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:[UIImage imageNamed:@"back_1@2x"]
                                                            andFrame:CGRectMake(0, 0, 28, 30)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;

    
    //创建web视图
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate =self;

    //自适应屏幕尺寸
//    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    //webView加载网络URL
    //构建URL
        NSURL *url = [NSURL URLWithString:@"http://ssyw.51yaoshi.com/ssyw/yklcjwt/index.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载网址
        [_webView loadRequest:request];
    


//    //创建风火轮
//    _activityView = [[UIActivityIndicatorView alloc]
//                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    
//    _activityView.frame = CGRectMake(0, 0, 24, 24);
//    //开始转动
//    //    [_activityView startAnimating];
//    
//    UIBarButtonItem *actItem = [[UIBarButtonItem alloc] initWithCustomView:_activityView];
//    self.navigationItem.rightBarButtonItem = actItem;
}
#pragma mark -UIWebViewDelegate
////webView开始加载
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [_activityView startAnimating];
//}
//
////webView加载完成
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [_activityView stopAnimating];
//}
//
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:QUESTIONVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:QUESTIONVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
