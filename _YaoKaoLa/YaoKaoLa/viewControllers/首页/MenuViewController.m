//
//  MenuViewController.m
//  yaokaola
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeView.h"
#import "GDataXMLNode.h"
#import "HomeModel.h"
#import "XmlBody.h"
#import "AControll.h"
#import "UIViewExt.h"
#import "TestViewController.h"
#import "CourseViewController.h"


#define MENUVIEWCONTROLLER @"MenuViewController"
//获取物理屏幕的尺寸
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)


@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
//    self.title = @"首页";
    
    
//    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"药考啦"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];

    
    
    //请求数据
    [self _requestData];
    [self _initHomeView];
}
-(void)_initHomeView
{
    float h = (kScreenHeight-64-48)/3;
    
    _homeView = [[HomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _homeView.hidden = NO;
    [self.view addSubview:_homeView
     ];
    
    
    if (_homeView.frame.size.height==480) {
        UIButton *classbtn = [[UIButton alloc]initWithFrame:CGRectMake(30 +(kScreenWidth - 30)/3-10,h+h*2/5*3+h*2/5*2/7+45,70, 20)];
        classbtn.backgroundColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        classbtn.titleLabel.font = [UIFont fontWithName:nil size:14];
        [classbtn setTitle:@"开始" forState:UIControlStateNormal];
        
        classbtn.titleLabel.textColor = [UIColor whiteColor];
        
        [_homeView addSubview:classbtn];
        classbtn.tag = 100;
        [classbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *precticebtn = [[UIButton alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 40)/3*2-10,h+h*2/5*3+h*2/5*2/7+45,70, 20)];
        precticebtn.backgroundColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        precticebtn.titleLabel.font = [UIFont fontWithName:nil size:14];
        [precticebtn setTitle:@"开始" forState:UIControlStateNormal];
        
        precticebtn.titleLabel.textColor = [UIColor whiteColor];
        
        [_homeView addSubview:precticebtn];
        [precticebtn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        
        precticebtn.tag = 101;

    }else if (_homeView.frame.size.height != 480){
        
        
        
        
        
    
       UIButton *classbtn = [[UIButton alloc]initWithFrame:CGRectMake(30 +(kScreenWidth - 30)/3-10,h+h*2/5*3+h*2/5*2/7+55,70, 20)];
       classbtn.backgroundColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        classbtn.titleLabel.font = [UIFont fontWithName:nil size:14];
       [classbtn setTitle:@"开始" forState:UIControlStateNormal];
    
       classbtn.titleLabel.textColor = [UIColor whiteColor];
    
       [_homeView addSubview:classbtn];
       classbtn.tag = 100;
       [classbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
       UIButton *precticebtn = [[UIButton alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 40)/3*2-10,h+h*2/5*3+h*2/5*2/7+55,70, 20)];
       precticebtn.backgroundColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
       precticebtn.titleLabel.font = [UIFont fontWithName:nil size:14];
       [precticebtn setTitle:@"开始" forState:UIControlStateNormal];
    
       precticebtn.titleLabel.textColor = [UIColor whiteColor];

       [_homeView addSubview:precticebtn];
       [precticebtn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
    
       precticebtn.tag = 101;
    }
    
    
}
-(void)btnAction:(UIButton *)btn
{
    self.tabBarController.selectedIndex = 2;
    
    
}
-(void)btnAction1:(UIButton *)btn
{
    
    self.tabBarController.selectedIndex = 1;
}

-(void)_requestData
{


    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userId =[ud objectForKey:@"userId"];
    int type = [AControll getMedicineType];
    NSString * whereXml = [NSString stringWithFormat:@"<data><UserId>%@</UserId><questionstype>%d</questionstype></data>",userId,type];
    
    NSString * pageType=@"1";
    NSString * funtionType=@"11";
    NSString * dataType=@"1";
    
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:nil whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *st = [XmlBody convertXMl:operation.responseString];
        //xml解析
        GDataXMLDocument  *ele = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        
    //    NSLog(@"%@",[[[ele nodesForXPath:@"//ExamDays" error:nil] lastObject] stringValue]);
        
        
        if (_homeModel == nil) {
            _homeModel = [[HomeModel alloc] init];
        }
        
        
        _homeModel.examDays =[[[ele nodesForXPath:@"//ExamDays" error:nil] lastObject] stringValue];
        _homeModel.continuousLearning =[[[ele nodesForXPath:@"//ContinuousLearning" error:nil] lastObject] stringValue];
        _homeModel.totalLearning =[[[ele nodesForXPath:@"//TotalLearning" error:nil] lastObject] stringValue];
        
    //    NSLog(@"%@",_homeModel.examDays);
        
        
        
        _homeModel.courseComplete =[[[ele nodesForXPath:@"//Course/Complete" error:nil] lastObject] stringValue];
        _homeModel.courseTotal =[[[ele nodesForXPath:@"//Course/Total" error:nil] lastObject] stringValue];
        
        _homeModel.examComplete =[[[ele nodesForXPath:@"//Exam/Complete" error:nil] lastObject] stringValue];
        _homeModel.examTotal =[[[ele nodesForXPath:@"//Exam/Total" error:nil] lastObject] stringValue];
        
        
        _homeModel.todayCourseComplete =[[[ele nodesForXPath:@"//TodayTaskCourse/Complete" error:nil] lastObject] stringValue];
        _homeModel.todayCourseTotal =[[[ele nodesForXPath:@"//TodayTaskCourse/Total" error:nil] lastObject] stringValue];
        
        
        _homeModel.todayExamComplete =[[[ele nodesForXPath:@"//TodayTaskExam/Complete" error:nil] lastObject] stringValue];
        _homeModel.todayExamTotal =[[[ele nodesForXPath:@"//TodayTaskExam/Total" error:nil] lastObject] stringValue];
        
        _homeView.homeModel = _homeModel;
        [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败!"];
        [_homeView faildUpdata];

    }];
    [op start];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).menuCall) {
        [self _requestData];
    }
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).menuCall = NO;
    
    [MTA trackPageViewBegin:MENUVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:MENUVIEWCONTROLLER];
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

@end
