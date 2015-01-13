//
//  QuestionViewController.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "BaseViewController.h"

@interface QuestionViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_activityView;

}

@end
