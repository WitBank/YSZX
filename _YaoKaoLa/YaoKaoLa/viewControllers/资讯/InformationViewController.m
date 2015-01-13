//
//  InformationViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTitleView.h"
#import "InformationRootHtmlModel.h"
#import "HJProgressHUD.h"
#import "ZHInformationTableViewCell.h"
#import "InformationDetailViewController.h"

#define INFORMATIONVIEWCONTROLLER @"InformationViewController"

@interface InformationViewController ()

@end

@implementation InformationViewController
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    HJProgressHUD *_HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    InformationViewController *m_self = self;
    
//    InformationTitleView *titleView= [[[NSBundle mainBundle] loadNibNamed:@"InfromationTitleView" owner:self options:nil] lastObject];
    InformationTitleView *titleView = [[InformationTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50*WIDTHPROPORTION)];
//    [titleView setFrame:CGRectMake(0, 10*WIDTHPROPORTION, SCREENWIDTH, 50*WIDTHPROPORTION)];
    [self.view addSubview:titleView];
    
    [titleView setTitleSelected:^(InformationTitleType type) {
        switch (type) {
            case InformationTitleTypeWithLeft:
                [m_self requestHtmlDataWithID:@"81"];
                break;
            case InformationTitleTypeWithCenter:
                [m_self requestHtmlDataWithID:@"82"];
                break;
            case InformationTitleTypeWithRight:
                [m_self requestHtmlDataWithID:@"83"];
                break;
            default:
                break;
        }
    }];
    
    [self requestHtmlDataWithID:@"81"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (50)*WIDTHPROPORTION, SCREENWIDTH, SCREENHEIGHT - (_allController_y+50)*WIDTHPROPORTION) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:INFORMATIONVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:INFORMATIONVIEWCONTROLLER];
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

#pragma mark - 获取html地址数据
- (void)requestHtmlDataWithID:(NSString *)idString
{
//    [self startAmination:@"获取数据中"];
    NSString *xmlPath = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw/getContent.jspx?channelId=%@",idString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
        GDataXMLElement *root = [doc rootElement];
        NSArray *itemArray = [root nodesForXPath:@"item" error:nil];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (GDataXMLElement *itemEle in itemArray) {
            InformationRootHtmlModel *model = [[InformationRootHtmlModel alloc] init];
            model.categoryName = [[[itemEle nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
            model.categoryId = [[[itemEle nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
            model.newsId = [[[itemEle nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
            model.title = [[[itemEle nodesForXPath:@"title" error:nil] lastObject] stringValue];
            model.descrip = [[[itemEle nodesForXPath:@"description" error:nil] lastObject] stringValue];
            model.contentUrl = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com:88/ssyw/newscontent/%@",[[[itemEle nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue]];
            model.contentHtmlUrl = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw%@",[[[itemEle nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
            model.praise = [[[itemEle nodesForXPath:@"praise" error:nil] lastObject] stringValue];
            model.titleImg = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com%@",[[[itemEle nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
            model.pubDate = [[[itemEle nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
            [dataArray addObject:model];
        }
        if ([dataArray count] > 0) {
            [_dataArray removeAllObjects];
            _dataArray = dataArray;
            [_tableView reloadData];
        }
        
//        [self stopAmination];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self stopAmination];
    }];
    [op start];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"InformationCell";
    ZHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHInformationTableViewCell" owner:self options:nil] lastObject];
    }
    InformationRootHtmlModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell showDataWithModel:model andFont:1.0f];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray == nil || [_dataArray count] <= 0) {
        return 44*WIDTHPROPORTION;
    }
    return 90*WIDTHPROPORTION;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    InformationRootHtmlModel *model = [_dataArray objectAtIndex:indexPath.row];
    InformationDetailViewController *detailViewController = [[InformationDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


//联网开始转菊花
-(void)startAmination:(NSString *)strInfo
{
    [self.view bringSubviewToFront:_HUD];
    [_HUD startShow:strInfo];
}

//停止转菊花
-(void)stopAmination
{
    [_HUD startHide];
}

@end
