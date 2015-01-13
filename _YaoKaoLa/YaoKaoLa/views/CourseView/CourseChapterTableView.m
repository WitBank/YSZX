//
//  CourseChapterTableView.m
//  yaokaola
//
//  Created by HuXin on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "CourseChapterTableView.h"
#import "ZHCourseDetailCatalTableViewCell.h"
#import "ZHCoureseChapterOperCell.h"


@implementation CourseChapterTableView
{
    
    BOOL _isSelected;
    int _lastSelectIndex;
    int _buty;
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
    self = [super initWithFrame:frame];
    if(self){
        _buty = 0;
        [self addTableView];
    }
    return self;
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setPullDelegate:self];
    [_tableView setCanPullDown:YES];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
}

#pragma mark - ZHCourseDetailTabbarViewDelegate
- (void)selectButtonWithTag:(NSInteger)tag
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSelected == YES) {
        return [_courseChapterArray count] + 1;
    }
    return [_courseChapterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    ZHCourseDetailCatalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (_isSelected == YES && indexPath.row > _lastSelectIndex) {
        if (indexPath.row - _lastSelectIndex == 1) {
            ZHCoureseChapterOperCell *operCell = [[[NSBundle mainBundle] loadNibNamed:@"ZHCoureseChapterOperCell" owner:self options:nil] lastObject];
            [operCell setOperButtonClick:^(ChapterOperButtonClick click) {
                switch (click) {
                        //播放
                    case ChapterOperButtonClickWithPlay:
                        if (_playVideo) {
                            _playVideo(_lastSelectIndex);
                        }
                        break;
                    case ChapterOperButtonClickWithDownload:
                        if (_downloadVideo) {
                            _downloadVideo(_lastSelectIndex);
                        }
                        break;
                    case ChapterOperButtonClickWithPractice:
                        if (_downloadVideo) {
                            _downloadVideo(_lastSelectIndex);
                        }
                        break;
                    case ChapterOperButtonClickWithCollection:
                        if (_downloadVideo) {
                            _downloadVideo(_lastSelectIndex);
                        }
                        break;
                        
                    default:
                        break;
                }
            }];
            return operCell;
        }
        _buty = -1;
    }
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHCourseDetailCatalTableViewCell" owner:self options:nil] lastObject];
    }
    int nowIndex = 0;
    BOOL seleet = NO;
    if (indexPath.row <= _lastSelectIndex) {
        nowIndex = (int)indexPath.row;
        if (indexPath.row == _lastSelectIndex && _isSelected == YES) {
            seleet = YES;
        }
    }else{
        nowIndex = (int)indexPath.row+_buty;
    }
    ZHCourseChapterModel *model = [_courseChapterArray objectAtIndex:nowIndex];
    [cell showLabelWithModelData:model andIndex:(int)indexPath.row + _buty andImageSelected:seleet];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    _buty = 0;
    if (_isSelected == YES) {
        if (indexPath.row == _lastSelectIndex) {
            _isSelected = NO;
            _lastSelectIndex = 0;
        }else if (indexPath.row == _lastSelectIndex+1){
            return;
        }else{
            if (indexPath.row > _lastSelectIndex) {
                _lastSelectIndex = (int)indexPath.row - 1;
            }else{
                _lastSelectIndex = (int)indexPath.row;
            }
        }
    }else{
        _lastSelectIndex = (int)indexPath.row;
        _isSelected = YES;
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSelected == YES && indexPath.row == (_lastSelectIndex + 1)) {
        return 60;
    }
    return 44.0f*WIDTHPROPORTION;
}

#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    
    if (state == PullDownLoadState) {
        if (_refreshData) {
            _refreshData();
        }
    }else {
        
    }
}

- (void)PullDownLoadEnd {
    [_tableView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd {
    [_tableView stopLoadWithState:PullUpLoadState];
}

@end
