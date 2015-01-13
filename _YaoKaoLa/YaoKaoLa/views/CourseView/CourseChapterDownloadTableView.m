//
//  CourseChapterDownloadTableView.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "CourseChapterDownloadTableView.h"
#import "ZHCoreDataManage.h"
#import "CourseChapterDownloadButtonView.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@implementation CourseChapterDownloadTableView
{
    
}

static CourseChapterDownloadTableView *sharedInstance = nil;

+(CourseChapterDownloadTableView *) shareDownloadController
{
    @synchronized(self) {
        if(!sharedInstance){
            int view_y;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                view_y = 64;
            }else {
                view_y = 44;
            }
            sharedInstance = [[CourseChapterDownloadTableView alloc] initWithFrame:CGRectMake(640*WIDTHPROPORTION, 0, SCREENWIDTH, SCREENHEIGHT - (view_y + 130)*WIDTHPROPORTION)];
        }
    }
    return sharedInstance;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _downLoadingArray = [[NSMutableArray alloc] init];
        _leftSelectedArray = [[NSMutableArray alloc] init];
        _rightSelectedArray = [[NSMutableArray alloc] init];
//        [self addTableView];
    }
    return self;
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40*WIDTHPROPORTION) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    
    CourseChapterDownloadButtonView *buttonView = [[[NSBundle mainBundle] loadNibNamed:@"CourseChapterDownloadButtonView" owner:self options:nil] lastObject];
    [buttonView setFrame:CGRectMake(0, self.frame.size.height - 40*WIDTHPROPORTION, self.frame.size.width, 40*WIDTHPROPORTION)];
    [self addSubview:buttonView];
    [buttonView setLeftButtonClick:^(BOOL leftButtonSelect) {
        if (_buttonViewSelected) {
            _buttonViewSelected(YES,leftButtonSelect);
        }
    }];
    [buttonView setRightButtonClick:^{
//        for (int i = 0; i < [_leftSelectedArray count]; i++) {
//            if ([[_leftSelectedArray objectAtIndex:i] boolValue] == YES) {
//                [_leftSelectedArray removeObjectAtIndex:i];
//                [_downLoadingArray removeObjectAtIndex:i];
//                [_rightSelectedArray removeObjectAtIndex:i];
//                i--;
//            }
//        }
        if (_buttonViewSelected) {
            _buttonViewSelected(NO,NO);
        }
        
    }];
    
}

-(void)updataTableView
{
    int prevCount = (int)[_downLoadingArray count]-1;
    NSMutableArray *newPath = [[NSMutableArray alloc] init];
    [self.tableView beginUpdates];
    [newPath addObject:[NSIndexPath indexPathForRow:prevCount inSection:0]];
    [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_downLoadingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseChapterDownloadCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseChapterDownloadCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZHCourseChapterModel *model = [_downLoadingArray objectAtIndex:indexPath.row];
    [cell showLabelDataWithModel:model andIsDownLoad:[[_rightSelectedArray objectAtIndex:indexPath.row] boolValue]];
    __block NSInteger row = indexPath.row;
    __block NSString *fileId = model.fileId;
    [cell setSelectLeft:^(BOOL leftSelect) {
        [_leftSelectedArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:leftSelect]];
    }];
    NSIndexPath *m_indexPath = indexPath;
    [cell setSelectDownload:^(RightButtonType rightType) {
        if (rightType == RightButtonTypeWithNormal) {
            [_rightSelectedArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:NO]];
            if (_changeDownloadType) {
                _changeDownloadType(NO,m_indexPath.row);
            }
        }else if (rightType == RightButtonTypeWithDownload){
            [_rightSelectedArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:YES]];
            if (_changeDownloadType) {
                _changeDownloadType(YES,m_indexPath.row);
            }
        }else{
            if (_playVedio) {
                _playVedio(fileId);
            }
        }
        
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


- (void)pauseAll
{
}

- (void)reloadTableViewData
{
    [_tableView reloadData];
}




@end
