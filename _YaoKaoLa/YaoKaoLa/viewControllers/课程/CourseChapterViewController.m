//
//  CourseChapterViewController.m
//  yaokaola
//
//  Created by HuXin on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "CourseChapterViewController.h"
#import "CourseChapterTableView.h"
#import "CourseChapterDetailView.h"
#import "CourseChapterDownloadTableView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoURLStringEncryption.h"
#import "ZHCoreDataManage.h"
#import "ZHDownloadManage.h"
#import "ZHFileManage.h"



#define COURSECHAPTERVIEWCONTROLLER @"CourseChapterViewController"

@interface CourseChapterViewController ()


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZHCourseDetailTabbarView *titleTabbarView;
@property (nonatomic, strong) CourseChapterDownloadTableView *downloadView;
@property (nonatomic, assign) NSInteger downloadNumber;                      //同时下载的数量
@property (nonatomic, assign) BOOL isMaxDown;                                //判断下载数是否达到上限

@end

@implementation CourseChapterViewController
{
    CourseChapterTableView *_chapterView;
    CourseChapterDetailView *_chapterDetailView;


}
@synthesize chapterArray = _chapterArray;

- (instancetype)initWithCourseModel:(ZHCourseRootSourseModel *)courseModel andChapterArray:(NSArray *)array andDLArray:(NSArray *)dlArray
{
    _chapterArray = [[NSMutableArray alloc] init];
    _downLoadArray = [[NSMutableArray alloc] init];
    _downLoadOperation = [[NSMutableArray alloc] init];
    if (array != nil && [array count] > 0) {
        _chapterArray = [NSMutableArray arrayWithArray:array];
    }
    if (dlArray != nil && [dlArray count] > 0) {
        _downLoadArray = [NSMutableArray arrayWithArray:dlArray];
    }
    _courseModel = courseModel;
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self addBackItem];
        [self setHidesBottomBarWhenPushed:YES];
        [self.tabBarController.tabBar setFrame:CGRectMake(-self.view.frame.size.width, 0, 0, 0)];
        [self addImageView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addScrollView];
    [self attTabbarView];
    if ([_chapterArray count] <= 0) {
        [self requestCourseChapterData];
    }else{
        _chapterView.courseChapterArray = _chapterArray;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:COURSECHAPTERVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:COURSECHAPTERVIEWCONTROLLER];
    for (int i = 0; i < [_downLoadOperation count]; i++) {
        ZHDownloadManage *manage = [_downLoadOperation objectAtIndex:i];
        [manage _PauseDownload];
    }
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

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320*WIDTHPROPORTION,100*WIDTHPROPORTION)];
    [imageView setImage:[UIImage imageNamed:@"chapter_head.png"]];
    [self.view addSubview:imageView];
}

- (void)addBackItem
{
    UIButton *backButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:1
                                                       andTitleColor:nil
                                                           andTarget:self
                                                              andSEL:@selector(willBack)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"ZH_YKL_NavigationBack@3x"].CGImage scale:0 orientation:UIImageOrientationDown]
                                                            andFrame:CGRectMake(10*WIDTHPROPORTION, 12*WIDTHPROPORTION, 14*WIDTHPROPORTION, 20*WIDTHPROPORTION)];
    UIBarButtonItem *leftBBI1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *backTitleLabel = [ZHCustomControl _customLabelWithTitle:_courseModel.courseName
                                                             andFont:17.0f
                                                       andTitleColor:[UIColor whiteColor]
                                                            andFrame:CGRectMake(0, 0, 180*WIDTHPROPORTION, 44*WIDTHPROPORTION)];
    [backTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:backTitleLabel];
    [self.navigationItem setLeftBarButtonItem:leftBBI1];
    
//    UIButton *referBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [referBtn setImage:[UIImage imageNamed:@"g3_nav_refresh"] forState:UIControlStateNormal];
//    [referBtn setFrame:CGRectMake(4, 5, 22.5, 22.5)];
//    [referBtn addTarget:self action:@selector(requestCourseChapterData) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBBI1 = [[UIBarButtonItem alloc] initWithCustomView:referBtn];
//    [self.navigationItem setRightBarButtonItem:rightBBI1];
}

- (void)willBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScrollView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130*WIDTHPROPORTION, SCREENWIDTH, SCREENHEIGHT - (_allController_y + 130)*WIDTHPROPORTION)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setExclusiveTouch:NO];
    [_scrollView setScrollEnabled:NO];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*3, 0)];
    [self.view addSubview:_scrollView];
    CGRect rect = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    CourseChapterViewController *m_self = self;
    _chapterView = [[CourseChapterTableView alloc] initWithFrame:rect];
    [_chapterView setPlayVideo:^(int index) {
        ZHCourseChapterModel *model = [m_self.chapterArray objectAtIndex:index];
        NSURL *URL = nil;
        if ([model.isDownload isEqualToString:@"1"]) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[ud objectForKey:@"username"],model.fileId];
            NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
            URL = [NSURL fileURLWithPath:path];
        }else{
            NSString *newURL = [VideoURLStringEncryption getNewURLStringWithPath:model.fileUrl];
            URL = [NSURL URLWithString:newURL];
        }
        MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
        playerController.view.transform = landscapeTransform;
        [m_self presentMoviePlayerViewControllerAnimated:playerController];
    }];
    [_chapterView setDownloadVideo:^(int index) {
        ZHCourseChapterModel *model = [m_self.chapterArray objectAtIndex:index];
        [m_self addDownloadWithModel:model];
        [m_self.titleTabbarView setButtonSelectedWithTag:2];
        [m_self.scrollView setContentOffset:CGPointMake(m_self.scrollView.frame.size.width*2, 0)];
    }];
    [_chapterView setRefreshData:^{
        [m_self requestCourseChapterData];
    }];
    [_scrollView addSubview:_chapterView];
    
    
    rect.origin.y += _scrollView.frame.size.width;
    _chapterDetailView = [[CourseChapterDetailView alloc] initWithFrame:rect];
    [_scrollView addSubview:_chapterDetailView];
/*------------------------------------------------------------------------------------*/
    //添加下载列表
    rect.origin.y += _scrollView.frame.size.width;
    _downloadView = [CourseChapterDownloadTableView shareDownloadController];
    [_scrollView addSubview:_downloadView];
    for (int i = 0; i < [_downLoadArray count]; i++) {
        [_downloadView.leftSelectedArray addObject:[NSNumber numberWithBool:NO]];
        [_downloadView.rightSelectedArray addObject:[NSNumber numberWithBool:NO]];
        ZHCourseChapterModel *m_Model = [_downLoadArray objectAtIndex:i];
        ZHDownloadManage *manage = [[ZHDownloadManage alloc] initWithModel:m_Model];
        [manage setTag:i];
        if (![m_Model.isDownload isEqualToString:@"1"]) {
//            [manage _StartDownload];
        }
        ZHDownloadManage *m_Manage = manage;
        [manage setCompleteDownload:^(BOOL isComplete){
            ZHCourseChapterModel *c_model = [m_self.downLoadArray objectAtIndex:[m_Manage tag]];
            //完成下载 修改cell状态
            CourseChapterDownloadCell *cell = (CourseChapterDownloadCell *)[_downloadView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[m_Manage tag] inSection:0]];
            RightButtonType type = RightButtonTypeWithNormal;
            if (isComplete == YES) {
                [c_model setIsDownload:@"1"];
                [ZHCoreDataManage saveDownloadCompleteWithModel:c_model];
                type = RightButtonTypeWithPlay;
            }else{
                //下载失败
//                NSLog(@"下载失败");
//                NSString *messageStr = [NSString stringWithFormat:@"下载[%@]失败，请重新尝试下载",c_model.fileName];
//                HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"温馨提示"
//                                                                 andMessage:messageStr
//                                                                andDelegate:self
//                                                                 andAddInfo:nil
//                                                             andButtonColor:HJCOLORBLUE
//                                                            andButtonTitles:@"取消",@"确定",nil];
//                [alertView setTag:10001];
//                [alertView show];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setDownloadButtonType:type];
//            });
        }];
        [manage setProcessChange:^(double p, int64_t t) {
            CourseChapterDownloadCell *cell = (CourseChapterDownloadCell *)[_downloadView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[m_Manage tag] inSection:0]];
            NSString *totalString = [NSString stringWithFormat:@"%.1lfM",t/(1024.0*1024)];
            BOOL isNot = NO;
            if (![cell.totalLabel.text isEqualToString:totalString]) {
                
                ZHCourseChapterModel *c_model = [m_self.downLoadArray objectAtIndex:[m_Manage tag]];
                [ZHCoreDataManage saveDownloadCompleteWithModel:c_model];
                isNot = YES;
                c_model.fileNumber = [NSString stringWithFormat:@"%lld",t];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.timeLabel setText:[NSString stringWithFormat:@"%.1f%%",(p*100)]];
                if (isNot == YES) {
                    [cell.totalLabel setText:totalString];
                }
//            });
            
        }];
        
        [_downLoadOperation addObject:manage];
    }
    _downloadView.downLoadingArray = _downLoadArray;
    [_downloadView addTableView];
    [_downloadView setChangeDownloadType:^(BOOL isDownload, NSInteger index) {
        ZHDownloadManage *manage = [m_self.downLoadOperation objectAtIndex:index];
        if (isDownload == YES) {
            if (m_self.isMaxDown == YES) {
                HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"温馨提示"
                                                                 andMessage:@"当前下载数量达到最大数，请等待下载完成或者暂停下载中的课程"
                                                                andDelegate:m_self
                                                                 andAddInfo:nil
                                                             andButtonColor:HJCOLORBLUE
                                                            andButtonTitles:@"取消",@"确定",nil];
                [alertView setTag:10003];
                [alertView show];
            }else{
                m_self.downloadNumber += 1;
                [manage _StartDownload];
                if (m_self.downloadNumber >= 2) {
                    [m_self setIsMaxDown:YES];
                }
//                int bunm = 0;
//                for (int i = 0; i<[m_self.downloadView.rightSelectedArray count]; i++) {
//                    if ([[m_self.downloadView.rightSelectedArray objectAtIndex:i] boolValue] == YES) {
//                        bunm += 1;
//                    }
//                    if (bunm == 3) {
//                        [m_self setIsMaxDown:YES];
//                        break;
//                    }
//                }
            }
            
        }else{
            m_self.downloadNumber -= 1;
            [manage _PauseDownload];
            [m_self setIsMaxDown:NO];
        }
    }];
    [_downloadView setPlayVedio:^(NSString *fileId) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
        NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[[array objectAtIndex:0] objectForKey:@"username"],fileId];
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        NSURL *URL = [NSURL fileURLWithPath:path];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [m_self presentMoviePlayerViewControllerAnimated:moviePlayerController];
        moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
        [moviePlayerController.moviePlayer play];
    }];
    [_downloadView setButtonViewSelected:^(BOOL isLeft, BOOL isDownload) {
        if (isLeft == YES) {
            if (isDownload == YES) {
                if (m_self.downloadNumber >= 2) {
                    HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"温馨提示"
                                                                     andMessage:@"当前下载数量达到最大数，请等待下载完成或者暂停下载中的课程"
                                                                    andDelegate:m_self
                                                                     andAddInfo:nil
                                                                 andButtonColor:HJCOLORBLUE
                                                                andButtonTitles:@"取消",@"确定",nil];
                    [alertView setTag:10003];
                    [alertView show];
                }else{
                    for (int i = 0; i < [m_self.downloadView.rightSelectedArray count]; i++) {
                        if ([[m_self.downloadView.rightSelectedArray objectAtIndex:i] boolValue] == NO) {
                            [m_self.downloadView.rightSelectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                            ZHDownloadManage *manage = [m_self.downLoadOperation objectAtIndex:i];
                            [manage _StartDownload];
                            m_self.downloadNumber += 1;
                            if (m_self.downloadNumber >= 2) {
                                break;
                            }
                        }
                    }
                }
                
            }else{
                for (int i = 0; i < [m_self.downloadView.rightSelectedArray count]; i++) {
                    if ([[m_self.downloadView.rightSelectedArray objectAtIndex:i] boolValue] == YES) {
                        [m_self.downloadView.rightSelectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                        ZHDownloadManage *manage = [m_self.downLoadOperation objectAtIndex:i];
                        [manage _PauseDownload];
                    }
                }
            }
        }else{
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
            for (int i = 0; i < [m_self.downloadView.leftSelectedArray count]; i++) {
                if ([[m_self.downloadView.leftSelectedArray objectAtIndex:i] boolValue] == YES) {
                    ZHDownloadManage *m_manage = [m_self.downLoadOperation objectAtIndex:i];
                    [m_manage _PauseDownload];
                    ZHCourseChapterModel *m_Model = [m_self.downLoadArray objectAtIndex:i];
                    BOOL isDownload = NO;
                    if ([m_Model.isDownload isEqualToString:@"1"]) {
                        isDownload = YES;
                    }
                    [ZHFileManage removeVideoWithUserName:[[array objectAtIndex:0] objectForKey:@"username"] andFileId:m_Model.fileId andIsDownload:isDownload];
                    [m_self.downloadView.leftSelectedArray removeObjectAtIndex:i];
                    [m_self.downloadView.downLoadingArray removeObjectAtIndex:i];
                    [m_self.downloadView.rightSelectedArray removeObjectAtIndex:i];
                    [m_self.downLoadOperation removeObjectAtIndex:i];
                    [ZHCoreDataManage removeDownloadVideoWithId:m_Model.fileId];
                    i--;
                }
                [m_self.downloadView.tableView reloadData];
            }
        }
    }];
}

- (void)attTabbarView
{
    _titleTabbarView = [[[NSBundle mainBundle] loadNibNamed:@"ZHCourseDetailTabbarView" owner:self options:nil] lastObject];
    [_titleTabbarView setFrame:CGRectMake(0, 100*WIDTHPROPORTION, SCREENWIDTH, 30*WIDTHPROPORTION)];
    [_titleTabbarView setDelegate:self];
    [self.view addSubview:_titleTabbarView];
}



- (void)requestCourseChapterData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *acntData = [userDefaults objectForKey:@"acountData"];
    NSMutableString *acntString = [NSMutableString stringWithString:acntData];
    [acntString insertString:[NSString stringWithFormat:@",\"courseId\":\"%@\"",_courseModel.courseId] atIndex:[acntString length]-1];
    XmlBody *xmlBody = [[XmlBody alloc] init];
    [xmlBody setPageXml:nil whereXml:acntString pageType:@"1" functionType:@"3" dataType:@"1"];
    AFHTTPRequestOperation *operation = [AControll createHttpOperatWithXmlBody:xmlBody];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *mstring = [AControll getDataResultElementWithXml_2:operation.responseString];
        mstring = [XmlBody convertXMl:mstring];
        GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:mstring error:nil];
        NSArray *videofilesArray = [xmlDocument nodesForXPath:@"videofiles" error:nil];
        GDataXMLElement *videofilesEle = [videofilesArray lastObject];
        NSArray *videofileArray = [videofilesEle nodesForXPath:@"videofile" error:nil];
        if ([videofileArray count] > 0) {
            [_chapterArray removeAllObjects];
            [ZHCoreDataManage removeAllCOurseChapterModelWithId:_courseModel.courseId];
            [_chapterView.courseChapterArray removeAllObjects];
        }
        for (GDataXMLElement *ele in videofileArray) {
            ZHCourseChapterModel *model = [[ZHCourseChapterModel alloc] init];
            model.courseId = _courseModel.courseId;
            model.fileId = [[[ele nodesForXPath:@"fileId" error:nil] lastObject] stringValue];
            model.fileName = [[[ele nodesForXPath:@"fileName" error:nil] lastObject] stringValue];
            model.fileTime = [[[ele nodesForXPath:@"fileTime" error:nil] lastObject] stringValue];
            model.fileUrl = [[[ele nodesForXPath:@"fileUrl" error:nil] lastObject] stringValue];
            [_chapterArray addObject:model];
            [ZHCoreDataManage saveCourseChapterModel:model];
        }
        _chapterView.courseChapterArray = _chapterArray;
        [_chapterView.tableView reloadData];
        [_chapterView PullDownLoadEnd];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        [_chapterView PullDownLoadEnd];
    }];
    [operation start];
}

- (void)HJalertView:(HJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex AddInformation:(id)addInfo
{
    switch (alertView.tag) {
        case 10001:
            
            break;
        case 10002:
            
            break;
        case 10003:
            
            break;
        default:
            break;
    }
}

#pragma mark - ZHCourseDetailTabbarViewDelegate
- (void)selectButtonWithTag:(NSInteger)tag
{
    int page = (int)tag - 101;
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*page, 0)];
    switch (tag) {
        case 101:
            break;
        case 102:
            break;
        case 103:
            break;
        default:
            break;
    }
}



#pragma mark - 添加下载列表
- (void)addDownloadWithModel:(ZHCourseChapterModel *)model
{
    for (int i = 0; i < [_downLoadArray count]; i++) {
        ZHCourseChapterModel *d_model = [_downLoadArray objectAtIndex:i];
        if ([d_model.fileId isEqualToString:model.fileId]) {
            return;
        }
    }
    [ZHCoreDataManage saveVideoDownloadModel:model];
    [_downLoadArray addObject:model];
    AppDelegate *appDelegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.downloadArray addObject:model];
    [_downloadView.leftSelectedArray addObject:[NSNumber numberWithBool:NO]];
    [_downloadView.rightSelectedArray addObject:[NSNumber numberWithBool:YES]];
    ZHDownloadManage *manage = [[ZHDownloadManage alloc] initWithModel:model];
    if (_isMaxDown == NO) {
        _downloadNumber += 1;
        [manage _StartDownload];
        if (_downloadNumber >= 2) {
            [self setIsMaxDown:YES];
        }
//        int bunm = 0;
//        for (int i = 0; i<[_downloadView.rightSelectedArray count]; i++) {
//            if ([[_downloadView.rightSelectedArray objectAtIndex:i] boolValue] == YES) {
//                bunm += 1;
//            }
//            if (bunm == 3) {
//                [self setIsMaxDown:YES];
//                break;
//            }
//        }
    }
    [manage setTag:[_downLoadOperation count]];
    ZHDownloadManage *m_Manage = manage;
    CourseChapterViewController *m_self = self;
    [manage setCompleteDownload:^(BOOL isComplete){
        ZHCourseChapterModel *c_model = [m_self.downLoadArray objectAtIndex:[m_Manage tag]];
        //完成下载 修改cell状态
        CourseChapterDownloadCell *cell = (CourseChapterDownloadCell *)[_downloadView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[m_Manage tag] inSection:0]];
        RightButtonType type = RightButtonTypeWithNormal;
        if (isComplete == YES) {
            [c_model setIsDownload:@"1"];
            [ZHCoreDataManage saveDownloadCompleteWithModel:c_model];
            type = RightButtonTypeWithPlay;
        }else{
            //下载失败
//            NSString *messageStr = [NSString stringWithFormat:@"下载[%@]失败，请重新尝试下载",c_model.fileName];
//            HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"温馨提示"
//                                                             andMessage:messageStr
//                                                            andDelegate:self
//                                                             andAddInfo:nil
//                                                         andButtonColor:HJCOLORBLUE
//                                                        andButtonTitles:@"取消",@"确定",nil];
//            [alertView setTag:10002];
//            [alertView show];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setDownloadButtonType:RightButtonTypeWithNormal];
//        });
    }];
    [manage setProcessChange:^(double p, int64_t t) {
        CourseChapterDownloadCell *cell = (CourseChapterDownloadCell *)[_downloadView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[m_Manage tag] inSection:0]];
        NSString *totalString = [NSString stringWithFormat:@"%.1lfM",t/(1024.0*1024)];
        BOOL isNot = NO;
        if (![cell.totalLabel.text isEqualToString:totalString]) {
            
            ZHCourseChapterModel *c_model = [m_self.downLoadArray objectAtIndex:[m_Manage tag]];
            [ZHCoreDataManage saveDownloadCompleteWithModel:c_model];
            isNot = YES;
            c_model.fileNumber = [NSString stringWithFormat:@"%lld",t];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.timeLabel setText:[NSString stringWithFormat:@"%.1f%%",(p*100)]];
            if (isNot == YES) {
                [cell.totalLabel setText:totalString];
            }
//        });
    }];
    [_downLoadOperation addObject:manage];
    [_downloadView.tableView reloadData];
}


@end
