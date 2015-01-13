//
//  HistoryViewController.m
//  yaokaola
//
//  Created by Mac on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryViewCell.h"
#import "GDataXMLNode.h"
#import "XmlBody.h"
#import "AControll.h"
#import "HistoryModel.h"
#import "RandomModel.h"
#import "ResolveViewController.h"

#define HISTORYVIEWCONTROLLER @"HistoryViewController"

@interface HistoryViewController ()
{
    NSMutableArray *_ddataArray;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"练习效果分析";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackWithDisMissOrPop:1];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinSize.width, WinSize.height-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    
    
    //请求数据
    [self _requestData];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:HISTORYVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:HISTORYVIEWCONTROLLER];
}

-(void)_requestData
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userId =[ud objectForKey:@"userId"];
    NSString * pageXml = @"<NewDataSet><Table><pageIndex>0</pageIndex><pageSize>6</pageSize><orderString></orderString></Table></NewDataSet>";
    
    int mtype = [AControll getMedicineType];

    NSString * whereXml = [NSString stringWithFormat:@" <NewDataSet><Table><userId>%@</userId><type>%d</type></Table></NewDataSet>",userId,mtype];
    
    NSString * pageType=@"1";
    NSString * funtionType=@"17";
    NSString * dataType=@"1";
    
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        
        //xml解析
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [[[doc rootElement] nodesForXPath:@"//NewDataSet" error:nil] lastObject];
//        NSLog(@"%@",root.XMLString);
        if (_historyArray == nil) {
            _historyArray = [[NSMutableArray alloc] init];
        }

        for (GDataXMLElement *el in root.children) {
            HistoryModel *data = [[HistoryModel alloc] init];
            
            for (GDataXMLElement *ele in el.children) {
                [data setValue:ele.stringValue forKey:ele.name];
            }
            [_historyArray addObject:data];
        }

        [_tableView reloadData];
        [SVProgressHUD dismiss];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败!"];

    }];
    [op start];
    [_tableView reloadData];

}

#pragma UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"HistoryIdentifier";
    HistoryViewCell * historyCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (historyCell == nil) {
        historyCell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryViewCell" owner:self options:nil]lastObject];
        
        historyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HistoryModel *data = _historyArray[indexPath.row];

    [historyCell updateData:data];
    return historyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryModel *model = _historyArray[indexPath.row];
    [self startRequestWith:model.chapterdetailedId];
   // NSLog(@"%@,%@",model.chapterdetailedId,model.questionsSortId);

}
- (void)goNext{
    if (_ddataArray == nil ||_ddataArray.count<=0) {
        [self showMsg:@"暂无数据!"];
        return;
    }
    ResolveViewController *rs = [[ResolveViewController alloc] init];
    rs.questionstype = @"0";
    rs.isResolve = YES; // 解析参数
    [rs setDataArray:_ddataArray];
    [self.navigationController pushViewController:rs animated:YES];
    
}
- (void)startRequestWith:(NSString *)chapId{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    if (_ddataArray == nil) {
        _ddataArray =[[NSMutableArray alloc] init];
    }
    [_ddataArray removeAllObjects];
    NSString * pageXml = @"1";
    NSString * whereXml = [NSString stringWithFormat:@"%@",chapId];
    NSString * pageType=@"1";
    NSString * funtionType=@"19";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [[[doc rootElement] nodesForXPath:@"//NewDataSet" error:nil] lastObject];
        for (GDataXMLElement *ele in root.children) {
            RandomModel *data = [[RandomModel alloc] init];
            for (GDataXMLElement *el in ele.children) {
                [data setValue:el.stringValue forKey:el.name];
                if ([el.name isEqualToString:@"useranswerkey"]) {
                    if (data.selectArray == nil) {
                        data.selectArray = [[NSMutableArray alloc] init];
                    }
                    for (NSString *st in [el.stringValue componentsSeparatedByString:@","]) {
                        [data.selectArray addObject:st];
                    } ;
                }
            }
            [_ddataArray addObject:data];
        }
        [self goNext];
        
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
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
