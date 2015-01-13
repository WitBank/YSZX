//
//  CourseViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "CourseViewController.h"
#import <AFNetworking.h>
#import "CourseChapterViewController.h"
#import "ZHCoreDataManage.h"
#import "ZHCourseRootImageModel.h"
#import "AppDelegate.h"

#define COURSEVIEWCONTROLLER @"CourseViewController"

@interface CourseViewController ()

@end

@implementation CourseViewController
{
    NSMutableArray *_imageArray;
//    NSMutableArray *_courseArray;
//    NSMutableArray *_allChapterArray;
//    NSMutableArray *_downLarray;
    NSString *_acntData;                //保存用户信息做全局
    AppDelegate *_appDelegate;
}

- (id)init
{
    self = [super init];
    if(self){
        [self addTitleView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self addCourseRootView];
    [self requestClassRootData];
    [self requestImageData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:COURSEVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:COURSEVIEWCONTROLLER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - addSubView
- (void)addTitleView
{
//    ZHPickTitleView *pickTitleView = [[[NSBundle mainBundle] loadNibNamed:@"ZHPickTitleView" owner:self options:nil] lastObject];
//    [pickTitleView setFrame:CGRectMake(0, 0, 200, 44)];
//    [pickTitleView setBackgroundColor:[UIColor clearColor]];
//    [pickTitleView setButtonTitleWithLeft:@"已购课程" andReight:@"购买课程"];
//    [pickTitleView.leftButton setEnabled:NO];
//    [pickTitleView.rightButton setEnabled:NO];
//    [pickTitleView setDelegate:self];
//    [self.navigationItem setTitleView:pickTitleView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"已购课程"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
}

- (void)addCourseRootView
{
    _courseRootView = [[ZHCourseRootView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT -(_allController_y + 49)*WIDTHPROPORTION)];
    [_courseRootView setDelegate:self];
    [self.view addSubview:_courseRootView];
    _courseRootView.sourseArray = _appDelegate.courseArray;
    [_courseRootView.collectionView reloadData];
}

#pragma mark - ZHPickTitleViewDelegate
- (void)selectLeftButton:(BOOL)selectLeft
{
    
}

#pragma mark - ZHCourseRootViewDelegate
- (void)selectCollectionCell:(NSIndexPath *)indexPath
{
    ZHCourseRootSourseModel *model = [_appDelegate.courseArray objectAtIndex:indexPath.row];
    NSMutableArray *chArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_appDelegate.chapterArray count]; i++) {
        ZHCourseChapterModel *cpModel = [_appDelegate.chapterArray objectAtIndex:i];
        if ([cpModel.courseId isEqualToString:model.courseId]) {
            [chArray addObject:cpModel];
        }
    }
    NSMutableArray *dlArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_appDelegate.downloadArray count]; i++) {
        ZHCourseChapterModel *dlModel = [_appDelegate.downloadArray objectAtIndex:i];
        if ([dlModel.courseId isEqualToString:model.courseId]) {
            [dlArray addObject:dlModel];
        }
    }
    CourseChapterViewController *coursChapterViewControl = [[CourseChapterViewController alloc] initWithCourseModel:model andChapterArray:chArray andDLArray:dlArray];
    [self.navigationController pushViewController:coursChapterViewControl animated:YES];
}

- (void)refreshCourseData
{
    [self requestClassRootData];
}

#pragma mark - RequestData/请求数据
- (void)requestClassRootData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _acntData = [userDefaults objectForKey:@"acountData"];
    XmlBody *xmlBody = [[XmlBody alloc] init];
    [xmlBody setPageXml:nil whereXml:_acntData pageType:@"1" functionType:@"2" dataType:@"1"];
    AFHTTPRequestOperation *operation = [AControll createHttpOperatWithXmlBody:xmlBody];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *mstring = [AControll getDataResultElementWithxxxml:operation.responseString];
        mstring = [XmlBody convertXMl:mstring];
        GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:mstring error:nil];
        NSArray *coursesArray = [xmlDocument nodesForXPath:@"courses" error:nil];
        GDataXMLElement *coursesEle = [coursesArray lastObject];
        NSArray *courseArray = [coursesEle nodesForXPath:@"course" error:nil];
        if ([courseArray count] > 0) {
            [_appDelegate.courseArray removeAllObjects];
            [ZHCoreDataManage removeALLCourseModel];
        }
        for (GDataXMLElement *ele in courseArray) {
            ZHCourseRootSourseModel *model = [[ZHCourseRootSourseModel alloc] init];
            model.courseId = [[[ele nodesForXPath:@"courseId" error:nil] lastObject] stringValue];
            model.courseName = [[[ele nodesForXPath:@"courseName" error:nil] lastObject] stringValue];
            model.courseImg = [[[ele nodesForXPath:@"courseImg" error:nil] lastObject] stringValue];
            model.courseContent = [[[ele nodesForXPath:@"courseContent" error:nil] lastObject] stringValue];
            model.teacher = [[[ele nodesForXPath:@"teacher" error:nil] lastObject] stringValue];
            model.endTime = [[[ele nodesForXPath:@"endTime" error:nil] lastObject] stringValue];
            model.videoCount = [[[ele nodesForXPath:@"videoCount" error:nil] lastObject] stringValue];
            [_appDelegate.courseArray addObject:model];
        }
        if ([_appDelegate.courseArray count] > 0) {
            [ZHCoreDataManage saveCourseWithModelArray:_appDelegate.courseArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            _courseRootView.sourseArray = _appDelegate.courseArray;
            [_courseRootView.collectionView reloadData];
            [_courseRootView PullDownLoadEnd];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"获取课程失败"];
        [_courseRootView PullDownLoadEnd];
    }];
    [operation start];
}

- (void)requestImageData
{
    NSString *xmlPath = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw/getContent.jspx?channelId=79"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
        GDataXMLElement *root = [doc rootElement];
        NSArray *itemArray = [root nodesForXPath:@"item" error:nil];
        NSMutableArray *iamgeArray = [[NSMutableArray alloc] init];
        for (GDataXMLElement *ele in itemArray) {
            ZHCourseRootImageModel *model = [[ZHCourseRootImageModel alloc] init];
            model.categoryName = [[[ele nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
            model.categoryId = [[[ele nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
            model.newsId = [[[ele nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
            model.title = [[[ele nodesForXPath:@"title" error:nil] lastObject] stringValue];
            model.descrip = [[[ele nodesForXPath:@"description" error:nil] lastObject] stringValue];
            model.contentUrl = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com:88/ssyw/newscontent/%@",[[[ele nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue]];
            model.contentHtmlUrl = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw%@",[[[ele nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
            model.titleImg = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com%@",[[[ele nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
            model.pubDate = [[[ele nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
            [iamgeArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_courseRootView addHeadScrollViewWithImageArray:iamgeArray];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"获取图片失败"];
    }];
    [op start];
}

@end
