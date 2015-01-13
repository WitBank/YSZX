//
//  SimulatedViewController.m
//  yaokaola
//
//  Created by pro on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "SimulatedViewController.h"
#import "SimulatedDetailViewController.h"
#import "SimulatedModel.h"

#define SIMULATEDVIEWCONTROLLER @"SimulatedViewController"

@interface SimulatedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation SimulatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackWithDisMissOrPop:1];
    self.navigationItem.title = @"考试列表";
    [self makeView];
    [self startRequest];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:SIMULATEDVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:SIMULATEDVIEWCONTROLLER];
}

- (void)makeView{
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, WinSize.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}



- (void)startRequest{
   // [SVProgressHUD showWithStatus:@"正在加载.." maskType:SVProgressHUDMaskTypeNone];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    NSString * pageXml = @"<NewDataSet><Table><pageIndex>0</pageIndex><pageSize>6</pageSize><orderString></orderString></Table></NewDataSet>";
    NSString * whereXml = [NSString stringWithFormat:@"<data><UserId>%@</UserId></data>",userId];
    NSString * pageType=@"1";
    NSString * funtionType=@"28";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [doc rootElement];

        GDataXMLElement *dataEle = (GDataXMLElement *)[root childAtIndex:0];
       
        for (GDataXMLElement *ele in dataEle.children) {
            SimulatedModel *model = [[SimulatedModel alloc] init];
            for (GDataXMLElement *el in ele.children) {
                [model setValue:el.stringValue forKey:el.name];
            }
            [_dataArray addObject:model];
        }

        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
    
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SimulatedDetailViewController *svc = [[SimulatedDetailViewController alloc] init];
    SimulatedModel *data = _dataArray[indexPath.row];
    svc.examId = data.examId;
    svc.questionstype = @"2";

    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:svc];
    [self presentViewController:nv animated:YES completion:nil];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simulateCell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"simulateCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.numberOfLines = 0;
    }
    SimulatedModel *data = _dataArray[indexPath.row];
    cell.textLabel.text = data.examName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"开始时间:%@",data.startTime];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
