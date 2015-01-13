//
//  SimulatedDetailViewController.m
//  yaokaola
//
//  Created by pro on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "SimulatedDetailViewController.h"
#import "RandomModel.h"
#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/testCache"]
#define PATHKEY [NSString stringWithFormat:@"%@",self.examId]
#import "RandomTopView.h"

#define SIMULATEDDETAILVIEWCONTROLLER @"SimulatedDetailViewController"

@interface SimulatedDetailViewController ()

@end

@implementation SimulatedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackWithDisMissOrPop:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    [self startRequest];
    // Do any additional setup after loading the view.
}
- (void)startRequest{
   // [SVProgressHUD showWithStatus:@"正在加载.." maskType:SVProgressHUDMaskTypeNone];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *examid = self.examId;
    NSString * pageXml = @"<NewDataSet><Table><pageIndex>0</pageIndex><pageSize>6</pageSize><orderString></orderString></Table></NewDataSet>";
    NSString * whereXml = [NSString stringWithFormat:@"<data><UserId>%@</UserId><ExamId>%@</ExamId></data>",userId,examid];
    NSString * pageType=@"1";
    NSString * funtionType=@"27";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * xmlSt = operation.responseString;
        NSString * result = [[xmlSt componentsSeparatedByString:@"<GetDataResult>"]lastObject];
        result = [[result componentsSeparatedByString:@"</GetDataResult>"]firstObject];
        
        if ([result intValue] == 1){
            xmlSt = [self getCacheWithKey:self.examId];
        }else {
            //设置最新缓存
            [self setCacheWithObject:xmlSt key:self.examId];
        }
        if(xmlSt == nil ||[xmlSt isEqualToString:@""])
        {
            [self showMsg:@"亲，暂无数据!"];
        }else{
            GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:xmlSt] error:nil];
            GDataXMLElement *root = [doc rootElement].children.firstObject;
            for (GDataXMLElement *ele in root.children) {
           
                RandomModel *data = [[RandomModel alloc] init];
                for (GDataXMLElement *el in [ele children]) {
                    [data setValue:[el stringValue] forKey:[el name]];
                }
                [_dataArray addObject:data];
            }
            [self loadScollViewData];
            [_topView startTime];
            [_topView setAllPage:(int)_dataArray.count];
            [self masklayer];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
    
}
//缓存
- (BOOL)setCacheWithObject:(NSString *)data key:(NSString *)key{
    [self createFile];
    BOOL ret = [NSKeyedArchiver archiveRootObject:data toFile:[NSString stringWithFormat:@"%@/%@.xml",PATH,key]];
    return ret;
}
- (NSString *)getCacheWithKey:(NSString *)key{
    NSString *data =[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.xml",PATH,key]];
    if (data == nil){
        data = @"";
    }
    return data;
}
//创建缓存路径文件夹
- (void)createFile{
    NSString *imageDir = PATH;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MTA trackPageViewBegin:SIMULATEDDETAILVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:SIMULATEDDETAILVIEWCONTROLLER];
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
