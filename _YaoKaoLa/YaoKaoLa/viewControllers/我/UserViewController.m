//
//  UserViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "UserViewController.h"
#import "UserSetCell.h"
#import "ApplyDirectionViewController.h"
#import "AControll.h"
#import "AboutViewController.h"
#import "QuestionViewController.h"
#import "ProposeViewController.h"

#define USERVIEWCONTROLLER @"UserViewController"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    NSMutableArray *_cellArray;
    int _type;      //0中药，1西药
    UserSetCell *_cacheCell;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  //  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.navigationItem.title = @"个人中心";//[ud objectForKey:@"username"];
    [self makeView];
    
    // Do any additional setup after loading the view from its nib.
}


//设置缓存
- (void)readCache{
    //code
    
    [_cacheCell setTestDate:@"1.0 M"];
}
//清除缓存
- (void)clearCache{
    //code
    
    
    [_cacheCell setTestDate:@"0.0 M"];
    
}

//退出登录
- (void)exitClick:(id)sender{
    [self exitRequest];
}
//退出成功
- (void)exitSuccece{
    //清除操
    [self clearInfo];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) showLogin];
}
  //清除操作
- (void)clearInfo{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"username"];
    [ud removeObjectForKey:@"userpassword"];
    [ud removeObjectForKey:@"acountData"];
    [ud removeObjectForKey:@"userId"];
    [ud removeObjectForKey:@"JSuserId"];
    [ud removeObjectForKey:@"meDirection"];
    [ud removeObjectForKey:@"directionTime"];
    [ud removeObjectForKey:@"directionTime"];
    [ud synchronize];
}
//退出请求
- (void)exitRequest{
    [SVProgressHUD showWithStatus:@"正在退出.." maskType:SVProgressHUDMaskTypeBlack];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString * whereXml = [ud objectForKey:@"acountData"];

    NSString * pageType=@"1";
    NSString * funtionType=@"25";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:nil whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [doc rootElement];
        NSString *st = root.stringValue;
        NSLog(@"%@",st);
        if ([st isEqualToString:@"退出成功"]){
            [self exitSuccece];
        }else{
            [self showMsg:@"退出失败"];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
}
- (void)makeView{
    //初始化数据
    [self loadTableViewData];
    //背景
    UIImageView *_gerenbank = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, WinSize.height-64-49)];
    _gerenbank.image = [UIImage imageNamed:@"user_bg.png"];
    [self.view addSubview:_gerenbank];
    //下部分scrolleView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, WinSize.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
   // _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);
   // _tableView.separatorColor = UIColorFromRGB(0xE6E6FA);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, 60)];
    
    
    UIButton *exitbt = [UIButton buttonWithType:UIButtonTypeCustom];
    exitbt.frame = CGRectMake(40, 15, WinSize.width-80, 30);
    exitbt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [exitbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitbt setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitbt addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
    exitbt.backgroundColor = UIColorFromRGB(0x1E90FF);
    [footView addSubview:exitbt];
    
    _tableView.tableFooterView = footView;
    
    [self.view addSubview:_tableView];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSetCell *cell =_cellArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSetModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        return 10;
    }else if (model.type == 0 ||model.type == 9) {
        return 30;
    }else if (model.type == 1) {
        return 70;
    }
    return 40;
}
//加载数据源
- (void)loadTableViewData{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    if (_cellArray == nil) {
        _cellArray = [[NSMutableArray alloc] init];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *name = [ud objectForKey:@"username"];
    NSArray *titles = @[@"",name,@"学习管理",@"考试日期",@"报考方向",@"通用设置",@"允许2G/3G播放",@"允许2G/3G下载",@"清除缓存",@"意见反馈",@"版本更新",@"常见问题",@"意见反馈",@"关于药考啦"];
    NSArray *images = @[@"",@"zd_userimg",@"",@"zbpfive",@"zbpfour",@"",@"zbpsix",@"zbpsever",@"zbpegith",@"",@"zbpten",@"zbpevelen",@"zbpten",@"zbpnine"];
    for (int i = 0; i < 14; i++) {
        UserSetModel *data = [[UserSetModel alloc] init];
        UserSetCell *cell = [[UserSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usercell1"];
        if(i == 0||i == 2||i == 5){
            data.type = 0;
        }else if(i == 6||i == 7){
            data.type = i;
        }else{
            data.type = i;
        }
        cell.tag = i;
        data.title = titles[i];
        data.image = images[i];
        [_dataArray addObject:data];
        
        [cell updateData:data];
        [_cellArray addObject:cell];
        if(i == 8){
            _cacheCell = cell;
        }
        if (i == 3|| i == 6|| i == 7 ||i ==10 || i ==11||i== 12) {
            [cell setSeperateLine];
        }
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserSetCell *directCell = _cellArray[4];
    UserSetCell *directTime = _cellArray[3];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *md =@"";
    _type = [AControll getMedicineType];
//  西药0，中药1
    if (_type == 1) {
        md = @"中药学";
    }else if(_type == 0){
        md = @"西药学";
    }
    
    [directCell setTestDirect:md];
 
    [directTime setTestDate:[ud objectForKey:@"directionTime"]];
    
    //读取缓存
    [self readCache];
    [MTA trackPageViewBegin:USERVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:USERVIEWCONTROLLER];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        //NSLog(@"编辑资料");
    }else if (indexPath.row == 3) {
        
        //NSLog(@"报考日期");
    }else if(indexPath.row == 4){
        
        ApplyDirectionViewController *advc = [[ApplyDirectionViewController alloc] init];
        advc.type = _type;
        advc.phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        advc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:advc animated:YES];
    }else if(indexPath.row == 6){
        // NSLog(@"2G/3G播放");
    }else if(indexPath.row == 7){
        //NSLog(@"2G/3G下载");
    }else if(indexPath.row == 8){
        UIAlertView *alev = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"返回", nil];
        [alev show];
    }else if(indexPath.row == 9){
    }else if(indexPath.row == 10){
        NSLog(@"版本更新");
    }else if(indexPath.row == 11){
        QuestionViewController *qvc = [[QuestionViewController alloc] init];
        qvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qvc animated:YES];
    }else if(indexPath.row == 12){
        ProposeViewController *pvc = [[ProposeViewController alloc] init];
        pvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (indexPath.row == 13){
        AboutViewController *ab = [[AboutViewController alloc] init];
        ab.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ab animated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self clearCache];
    }
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
