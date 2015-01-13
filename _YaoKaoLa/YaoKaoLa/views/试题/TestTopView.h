//
//  TestTopView.h
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestModel.h"
@interface TestTopView : UIView
- (void)updateDataWith:(TestModel *)data;
- (void)faildUpdata;
@end
