//
//  InformationDetailViewController.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "BaseViewController.h"
#import "InformationRootHtmlModel.h"

@interface InformationDetailViewController : BaseViewController<UIWebViewDelegate>

- (instancetype)initWithModel:(InformationRootHtmlModel *)model;

@end
