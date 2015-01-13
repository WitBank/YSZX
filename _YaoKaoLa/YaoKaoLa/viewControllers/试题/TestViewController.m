//
//  TestViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "TestViewController.h"
#import "RandomViewController.h"
#import "TestTopView.h"
#import "GDataXMLNode.h"
#import "SectionViewController.h"
#import "SimulatedViewController.h"

#define TESTVIEWCONTROLLER @"TestViewController"

@interface TestViewController ()<UIAlertViewDelegate>
{
    TestTopView *_topView;
    TestModel *_data;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
}
- (void)makeView{
    //导航右边按钮
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"examtopimg.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
//    self.navigationItem.rightBarButtonItem = right;
    //上部
    float th = (WinSize.height-64-44)*0.5;
    _topView = [[TestTopView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, th)];
    [self.view addSubview:_topView];
    //中间线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, th-1, WinSize.width, 1)];
    line.image = [UIImage imageNamed:@"sifengexian.png"];
    [self.view addSubview:line];
    
    //下部分
    UIView * _downView = [[UIView alloc] initWithFrame:CGRectMake(0, th, WinSize.width, th)];
    _downView.backgroundColor = [UIColor whiteColor];
    //添加按钮
    float tx = (WinSize.width - 180)*0.25;
    float ty = (_downView.frame.size.height - 120)/3 - 5;
    NSArray *titles = @[@"随便练练",@"章节练习",@"模拟考场",@"在线竞技",@"错题练习",@"收藏练习"];
    NSArray *images = @[@"suijilianxi.png",@"zhangjielianxinew.png",@"monikaoshinew.png",@"zaixianjingsai.png",@"cuotilianxi.png",@"shoucanglianxi.png"];
    for (int i = 0; i < 6; ++ i) {
        CGRect frame = CGRectMake(tx+(tx+60)*(i%3), ty-10+(ty+70)*(i/3), 60, 60);
        UIButton *bt = [AControll createButtonWithFrame:frame title:nil titleColor:nil backgroungImage:images[i] tag:i];
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame1 = CGRectMake(bt.frame.origin.x, bt.frame.origin.y+60, 60, 20);
        UILabel *lb = [AControll createLabelWithFrame:frame1 text:titles[i] font:[UIFont boldSystemFontOfSize:13] textColor:nil];
        [_downView addSubview:lb];
        [_downView addSubview:bt];
    }
    [self.view addSubview:_downView];
    [self startRequest];
}
//请求数据
- (void)startRequest{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * userId = [ud objectForKey:@"userId"];
    int qStype = [AControll getMedicineType];
    NSString *pageXml = @"<NewDataSet><Table><pageIndex>0</pageIndex><pageSize>10</pageSize><orderString></orderString></Table></NewDataSet>";
    NSString * whereXml = [NSString stringWithFormat:@"<NewDataSet><Table><UserId>%@</UserId><questionstype>%d</questionstype></Table></NewDataSet>",userId,qStype];

    NSString * pageType=@"1";
    NSString * funtionType=@"14";
    NSString * dataType=@"1";

    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //xml解析
        GDataXMLDocument  *ele = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
      //  NSLog(@"%@",operation.responseString);
        if (_data == nil) {
            _data = [[TestModel alloc] init];
        }
        _data.complete =[[[ele nodesForXPath:@"//Complete" error:nil] lastObject] stringValue];
        _data.total =[[[ele nodesForXPath:@"//Total" error:nil] lastObject] stringValue];
        _data.totalQuestions =[[[ele nodesForXPath:@"//TotalQuestions" error:nil] lastObject] stringValue];
        _data.practiceDays =[[[ele nodesForXPath:@"//PracticeDays" error:nil] lastObject] stringValue];
        _data.ranking =[[[ele nodesForXPath:@"//Ranking" error:nil] lastObject] stringValue];
        _data.correct = [[[ele nodesForXPath:@"//Correct" error:nil] lastObject] stringValue];
        [_topView updateDataWith:_data];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   //     NSLog(@"请求失败");
        [_topView faildUpdata];
        [self showMsg:@"网络连接失败"];
    }];
    [op start];
}

- (void)buttonClick:(UIButton *)bt{
    if (!([self.navigationController.viewControllers lastObject] == self)) {
        return;
    }
    //随机测试
    if (bt.tag == 0) {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定进入练习？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alv show];
    }else if(bt.tag == 1){
        //章节练习
        SectionViewController *svc = [[SectionViewController alloc] init];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
    }else if(bt.tag == 2){
        //模拟考场
        SimulatedViewController *sivc = [[SimulatedViewController alloc] init];
        sivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sivc animated:YES];
    
    }else {
        [SVProgressHUD showSuccessWithStatus:@"暂未开放！"];
    }
}
//导航右边按钮点击
- (void)itemClick:(UIBarButtonItem *)item{
    //[self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - alerView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //确定
    if (buttonIndex == 1) {
        RandomViewController *vc = [[RandomViewController alloc] init];
        vc.questionstype = @"1";
        vc.qSortId = @"1";
        vc.qType = 1;
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nv animated:NO completion:nil];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).isCall) {
        [self startRequest];
    }
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).isCall = NO;
    [MTA trackPageViewBegin:TESTVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:TESTVIEWCONTROLLER];
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
