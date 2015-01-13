//
//  SectionViewController.m
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "SectionViewController.h"
#import "SectionCell.h"
#import "SectionButton.h"
#import "SectionModel.h"
#import "HistoryViewController.h"
#import "SVProgressHUD.h"
#import "RandomViewController.h"

#define SECTIONVIEWCONTROLLER @"SectionViewController"

@interface SectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_headArray;//头部视图
}
@end

@implementation SectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"章节练习";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackWithDisMissOrPop:1];
    [self makeView];
    
    [self startRequest];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:SECTIONVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:SECTIONVIEWCONTROLLER];
}

//跳转
- (void)goDetail:(NSString *)sortId{
    RandomViewController *vc = [[RandomViewController alloc] init];
    vc.questionstype = @"0";
    vc.qSortId = sortId;
    vc.qType = 0;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nv animated:NO completion:nil];
    
}
-(void)startRequest
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userId =[ud objectForKey:@"userId"];
    NSString * pageXml = @"<NewDataSet><Table><pageIndex>0</pageIndex><pageSize>10</pageSize><orderString></orderString></Table></NewDataSet>";
    int mtype = [AControll getMedicineType];
    NSString * whereXml = [NSString stringWithFormat:@"<NewDataSet><Table><userId>%@</userId><type>%d</type></Table></NewDataSet>",userId,mtype];
    
    NSString * pageType=@"1";
    NSString * funtionType=@"6";
    NSString * dataType=@"1";
    
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:pageXml whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //xml解析
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        NSArray *root = [doc nodesForXPath:@"//NewDataSet" error:nil];
        GDataXMLElement *first;
        GDataXMLElement *sencond;
        if (root.count >=2 ) {
            first = root[0];
            sencond = root[1];
            if (_dataArray == nil) {
                _dataArray = [[NSMutableArray alloc] init];
            }
        }
        //一级标题
        for (GDataXMLElement *ele in first.children) {
            
            SectionModel *scModel = [[SectionModel alloc] init];
            if (scModel.modelArray == nil) {
                scModel.modelArray = [[NSMutableArray alloc] init];
            }

            scModel.isOn = NO;
            for (GDataXMLElement *el in ele.children) {
                [scModel setValue:el.stringValue forKey:el.name];
                
            }
            [_dataArray addObject:scModel];
        }
        //二级标题
        for (GDataXMLElement *ele in sencond.children) {
            SectionModel *scModel = [[SectionModel alloc] init];
            for (GDataXMLElement *el in ele.children) {
                [scModel setValue:el.stringValue forKey:el.name];
            }
            for (int i = 0; i< _dataArray.count; i++) {
                SectionModel *data = _dataArray[i];
                NSString *st = [NSString stringWithFormat:@"%@%@,",data.depth,data.questionsSortId];

                NSComparisonResult result1 = [st caseInsensitiveCompare:scModel.depth];
                if (result1 == NSOrderedSame) {
                    [data.modelArray addObject:scModel];
                    
                    break ;
                }
            }
        }
        [self loadData];

        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showMsg:@"网络连接失败"];
    }];
    [op start];
}

- (void)loadData{
    if (_headArray == nil) {
        _headArray = [[NSMutableArray alloc] init];
    }
    //头部
    for(int i = 0;i < _dataArray.count; ++i){
        SectionModel *data = _dataArray[i];
        
        SectionButton *bt = [[SectionButton alloc] init];
        [bt updateData:data];
        bt.tag = i;
        [bt addTarget:self action:@selector(headSectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headArray addObject:bt];
    }
    [_tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    SectionModel *model  =_dataArray[indexPath.section];
    if (model.modelArray.count >= indexPath.row + 1) {
        SectionModel *data = model.modelArray[indexPath.row];
        [self goDetail:data.questionsSortId];
    }
    
}

//历史
- (void)historyClick:(id)sender{
    HistoryViewController *history = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:history animated:YES];
    
    
}
//头部点击事件
- (void)headSectionClick:(SectionButton *)bt{
    bt.isOn?[bt closeSecton]:[bt openSection];
    SectionModel *data = _dataArray[bt.tag];
    data.isOn = bt.isOn;
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:bt.tag];
    [_tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationFade];
}
- (void)makeView{
    UILabel *_sectionName = [AControll createLabelWithFrame:CGRectMake(40, 0, WinSize.width-40, 40) text:@"章节选择" font:[UIFont boldSystemFontOfSize:16] textColor:nil];
    _sectionName.textAlignment = NSTextAlignmentLeft;
    //对号
    UIImageView *duihao = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 18, 18)];
    duihao.image = [UIImage imageNamed:@"duihao.png"];
    [self.view addSubview:duihao];
    [self.view addSubview: _sectionName];
    //历史
    UIButton *history = [UIButton buttonWithType:UIButtonTypeCustom];
    history.frame = CGRectMake(WinSize.width-30, 12, 18, 18);
    [history setBackgroundImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
    [history addTarget:self action:@selector(historyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:history];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, WinSize.width, WinSize.height-64-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 20);
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SectionModel *data = _dataArray[section];
    int t = (int)data.modelArray.count;
    return  data.isOn?t:0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _headArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headArray[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    SectionModel *model  =_dataArray[indexPath.section];
    if (model.modelArray.count >= indexPath.row + 1) {
        SectionModel *data = model.modelArray[indexPath.row];
        [cell updateData:data];
    }

    return cell;
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
