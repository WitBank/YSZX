//
//  InformationDetailViewController.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "InformationDetailViewController.h"

#define INFORMATIONDETAILVIEWCONTROLLER @"InformationDetailViewController"

@interface InformationDetailViewController ()

@end

@implementation InformationDetailViewController
{
    UIWebView *_webView;
    InformationRootHtmlModel *_informationHtmlModel;
    UILabel *_titleLabel;
}

- (instancetype)initWithModel:(InformationRootHtmlModel *)model
{
    _informationHtmlModel = model;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0.0f,0,SCREENWIDTH,SCREENHEIGHT - _allController_y*WIDTHPROPORTION)];
    _webView.delegate=self;
    _webView.scalesPageToFit =NO;
    [self.view addSubview:_webView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [_titleLabel setText:_informationHtmlModel.categoryName];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:_titleLabel];
    
    UIButton *backButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:1.0f
                                                       andTitleColor:nil
                                                           andTarget:self
                                                              andSEL:@selector(backClick)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:[UIImage imageNamed:@"back_1@2x"]
                                                            andFrame:CGRectMake(0, 0, 19, 20)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [self showDataWithHtmlString:_informationHtmlModel.contentHtmlUrl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:INFORMATIONDETAILVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:INFORMATIONDETAILVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDataWithHtmlString:(NSString *)htmlString
{
    NSURL* url = [NSURL URLWithString:htmlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([requestString hasPrefix:@"ios-log:"]) {
        //        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        //        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
    return YES;
}

//加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *string = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [_webView stringByEvaluatingJavaScriptFromString:string];
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
