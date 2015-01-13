//
//  ApplyDirectionViewController.m
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ApplyDirectionViewController.h"

#define APPLYDIRECTIONVIEWCONTROLLER @"ApplyDirectionViewController"

@interface ApplyDirectionViewController ()<UIAlertViewDelegate>
{
    UIButton *_pharmacy; // 中药学
    UIButton *_wpharmacy; // 西药学
}
@end

@implementation ApplyDirectionViewController

- (void)buttonClick:(UIButton *)bt{
    if(bt.tag == 0){
        _pharmacy.selected = YES;
        _wpharmacy.selected = NO;
        self.type = 1;
    }else{
        _pharmacy.selected = NO;
        _wpharmacy.selected = YES;
        self.type = 0;
    }
}
//下一步
- (void)nextClick:(id)sender{

    if (self.type == -1) {
        return;
    }
    NSString *msg =@"";
    if (self.type == 1) {
        //中药学
        msg = @"你选择的是《中药学》,是否确认?";
    }else{
        msg = @"你选择的是《西药学》,是否确认?";
        // 西药学
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定提示框" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self startRequest];
    }
}
//选择成功
- (void)seleltSucces{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:(self.type?@"1":@"0") forKey:@"meDirection"];
    [ud setObject:self.phoneNum forKey:@"username"];
    [ud synchronize];
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).isCall = YES;
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).menuCall = YES;
    
    if(self.from == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"正在加载.." maskType:SVProgressHUDMaskTypeBlack];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *loginName = self.phoneNum;
    NSString *ssoToken = [ud objectForKey:@"acountData"];
    int yaoType = self.type;

    int mobType = [self.mobType intValue];
    
    NSString * whereXml = [NSString stringWithFormat:@"<data><LoginName>%@</LoginName><yaoType>%d</yaoType><mobType>%d</mobType><ssoToken>%@</ssoToken></data>",loginName,yaoType,mobType,ssoToken];
    
    

    NSString * pageType=@"1";
    NSString * funtionType=@"23";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:nil whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [doc rootElement];
       // NSLog(@"%@",root.XMLString);
        int result = [root.stringValue intValue];
        if (result == 1) {
            //选择成功
            [self seleltSucces];
            
        }else{
            [self showMsg:@"选择失败"];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.from == 0) {
        [self setBackWithDisMissOrPop:1];
    }else{
        [self setBackWithDisMissOrPop:0];
    }
    
    self.title = @"报考方向";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, WinSize.width, 50)];
    lb.numberOfLines = 0;
    lb.text = @"选择您的报考方向\n请根据实际报名情况选择";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:lb];
    float ttx = (WinSize.width - 200-30)*0.5;
    NSArray *imgs = @[@"select_zy",@"select_xy"];
    NSArray *titles = @[@"中药学",@"西药学"];
    for (int i = 0; i < 2; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(ttx+130*i, 140, 100, 100);
        [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_no",imgs[i]]] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_yes",imgs[i]]] forState:UIControlStateSelected];
        [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_yes",imgs[i]]] forState:UIControlStateHighlighted];
        bt.tag = i;
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bt];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(ttx+130*i, 270, 100, 50)];
        name.text = titles[i];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor grayColor];
        name.font = [UIFont boldSystemFontOfSize:15];
        [self.view addSubview:name];
        if (i == 0){
            _pharmacy = bt;
        }else{
            _wpharmacy = bt;
        }
    }
    if(self.type == 1){
        _pharmacy.selected = YES;
    }else{
        _wpharmacy.selected = YES;
    }
    UIButton *nextBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBt.frame = CGRectMake(20, WinSize.height-64-80, WinSize.width-40, 35);
    [nextBt setTitle:@"完成" forState:UIControlStateNormal];
    [nextBt setBackgroundColor:UIColorFromRGB(0x1E90FF)];
    nextBt.titleLabel.font =[UIFont boldSystemFontOfSize:15];
    [nextBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBt addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBt];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:APPLYDIRECTIONVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:APPLYDIRECTIONVIEWCONTROLLER];
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
