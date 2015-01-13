//
//  MenuViewController.h
//  yaokaola
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@class HomeView;
@class HomeModel;
@interface MenuViewController : BaseViewController
{
    HomeView *_homeView;
    HomeModel *_homeModel;
}

@end
