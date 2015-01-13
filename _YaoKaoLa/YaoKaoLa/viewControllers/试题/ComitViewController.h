//
//  ComitViewController.h
//  yaokaola
//
//  Created by pro on 14/12/2.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseViewController.h"

@interface ComitViewController : BaseViewController
@property (nonatomic,assign)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *examId;
@property (nonatomic,copy)NSString *questionstype;//章节0，练一练1
@property (nonatomic,copy) NSString* times;
@end
