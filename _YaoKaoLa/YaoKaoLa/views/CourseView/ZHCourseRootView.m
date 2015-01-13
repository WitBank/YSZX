//
//  ZHCourseRootView.m
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ZHCourseRootView.h"
#import "ZHCourseRootCollectionViewCell.h"


@implementation ZHCourseRootView

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
    if (self) {
        _sourseArray= [[NSMutableArray alloc] init];
        [self addCollectionView];
    }
    return self;
}

//初始化顶部图片滚动的scrollView
- (void)addHeadScrollViewWithImageArray:(NSArray *)imageArray
{
//    _headImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120*WIDTHPROPORTION)];
//    [_headImageScrollView setPagingEnabled:YES];
//    [_headImageScrollView setShowsHorizontalScrollIndicator:NO];
//    [_headImageScrollView setShowsVerticalScrollIndicator:NO];
//    [_headImageScrollView setBounces:NO];
//    [_headImageScrollView setDelegate:self];
//    [_headImageScrollView setContentSize:CGSizeMake(self.frame.size.width*4, 0)];
//    [_headImageScrollView setBackgroundColor:[UIColor blackColor]];
//    [self addSubview:_headImageScrollView];
//    NSArray *imageArray = [NSArray arrayWithObjects:@"sliding_switcher_view5",@"sliding_switcher_view6",@"sliding_switcher_view7",@"sliding_switcher_view8", nil];
//    for (int i = 0; i < [imageArray count]; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
//        [imageView setFrame:CGRectMake(i*_headImageScrollView.frame.size.width, 0, _headImageScrollView.frame.size.width, _headImageScrollView.frame.size.height)];
//        [_headImageScrollView addSubview:imageView];
//    }
    _imageHeadView = [[ZHInformationImageHeadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150*WIDTHPROPORTION) andModelArray:imageArray];
    [self addSubview:_imageHeadView];
    [_imageHeadView setAutoPlayWithDelay:3.0f];
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150*WIDTHPROPORTION, self.frame.size.width, self.frame.size.height - 150*WIDTHPROPORTION) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerNib:[UINib nibWithNibName:@"ZHCourseRootCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZHCourseRootCollectionViewCell"];
    [_collectionView setAllowsMultipleSelection:YES];
    [_collectionView setPullDelegate:self];
    [_collectionView setCanPullDown:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [self addSubview:_collectionView];
}

#pragma mark - showData/添加数据
-(BOOL)showViewWithData:(NSDictionary *)dataDic
{
    if (dataDic == nil || [[dataDic allKeys] count] <= 0) {
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(145*WIDTHPROPORTION, 110*WIDTHPROPORTION);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5*WIDTHPROPORTION, 5*WIDTHPROPORTION, 5*WIDTHPROPORTION, 5*WIDTHPROPORTION);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectCollectionCell:)]) {
        [_delegate selectCollectionCell:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_sourseArray count] <= 0) {
        return 0;
    }
    return [_sourseArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_sourseArray count] <= 0) {
        return nil;
    }
    static NSString *cellName = @"ZHCourseRootCollectionViewCell";
    ZHCourseRootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHCourseRootCollectionViewCell" owner:self options:nil] lastObject];
    }
    [cell loadDataWithModel:[_sourseArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    
    if (state == PullDownLoadState) {
        if (_delegate && [_delegate respondsToSelector:@selector(refreshCourseData)]) {
            [_delegate refreshCourseData];
        }else{
            [self PullDownLoadEnd];
        }
    }
}

- (void)PullDownLoadEnd
{
    [_collectionView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd
{
    [_collectionView stopLoadWithState:PullUpLoadState];
}



@end
