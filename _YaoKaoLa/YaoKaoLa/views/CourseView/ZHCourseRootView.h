//
//  ZHCourseRootView.h
//  yaokaola
//
//  Created by HuXin on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+PullLoad.h"
#import "ZHInformationImageHeadView.h"

@protocol ZHCourseRootViewDelegate <NSObject>

- (void)selectCollectionCell:(NSIndexPath *)indexPath;
- (void)refreshCourseData;

@end

@interface ZHCourseRootView : UIView<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PullDelegate>
{
    UIScrollView *_headImageScrollView;         //顶部自动滑动图片的scrollView
//    UICollectionView *_collectionView;          //显示课程内容的collectionView
//    NSArray *_sourseArray;                      //存放课程数据源的数组
//    NSArray *_headImageArray;                   //存放顶部滚动图片的数组
}

@property (nonatomic, strong) ZHInformationImageHeadView *imageHeadView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sourseArray;
@property (nonatomic, weak) id <ZHCourseRootViewDelegate>delegate;

- (void)addHeadScrollViewWithImageArray:(NSArray *)imageArray;
- (BOOL)showViewWithData:(NSDictionary *)dataDic;
- (void)PullDownLoadEnd;

@end
