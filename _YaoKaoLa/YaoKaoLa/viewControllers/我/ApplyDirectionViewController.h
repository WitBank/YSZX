//
//  ApplyDirectionViewController.h
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyDirectionViewController : BaseViewController
@property (nonatomic,assign) int type;  //1 中药学，0西药学
@property (nonatomic,copy) NSString *mobType;
@property (nonatomic,assign) int from;  //1,注册过来的
@property (nonatomic,copy) NSString *phoneNum;
@end
