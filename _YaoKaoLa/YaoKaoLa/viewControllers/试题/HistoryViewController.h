//
//  HistoryViewController.h
//  yaokaola
//
//  Created by Mac on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseViewController.h"
@class HistoryViewCell;
@class HistoryModel;

@interface HistoryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    HistoryModel *_historyModel;
    NSMutableArray *_historyArray;
    
}

@end
