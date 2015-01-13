//
//  RegisterCoderController.m
//  yaokaola
//
//  Created by pro on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "RegisterCoderController.h"
#import "RegisterPassWorldViewController.h"

#define REGISTERCODERCONTROLLER @"RegisterCoderController"

@interface RegisterCoderController ()<UITextFieldDelegate>
{
    UITextField * _coder;
    UILabel * _phone;
    UILabel *_timeLb;
    NSTimer *_timer;
    int time;
}
@end

@implementation RegisterCoderController
- (void)dealloc
{
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写验证码";
    [self setBackWithDisMissOrPop:1];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    [self startTime];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:REGISTERCODERCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:REGISTERCODERCONTROLLER];
}

//下一步
- (void)next:(id)sender{
    if (_coder == nil||[_coder.text isEqualToString:@""]) {
        [self showMsg:@"请填写验证码！"];
    }else if(time == 0){
        [self showMsg:@"验证码过期！"];
    }else if([self.code isEqualToString:_coder.text]){
        RegisterPassWorldViewController *pvc = [[RegisterPassWorldViewController alloc] init];
        pvc.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:pvc animated:YES];
    }else{
        [self showMsg:@"验证码错误"];
    }
}
//重新获取验证码
- (void)reSetClick:(id)sender{
    [self startRequest];
    [self startTime];
}
//开始计时
- (void)startTime{
    time = 60;
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(rePeatTime) userInfo:nil repeats:YES];
}
- (void)rePeatTime{
    _timeLb.text = [NSString stringWithFormat:@"(%02d)",--time];
    if (time == 0) {
        [_timer invalidate],_timer = nil;
    }
}
//重新请求数据
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"loading.." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString * whereXml = [NSString stringWithFormat:@"<data><PhoneNum>%@</PhoneNum></data>",self.phoneNum];
    NSString * pageType=@"1";
    NSString * funtionType=@"20";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:nil whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        GDataXMLElement *root = [doc rootElement];
        NSString *result = root.stringValue;

        if (![result isEqualToString:@"用户名已存在"]) {
            self.code = result;
            
        }else{
            [self showMsg:result];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
}
- (void)makeView{
    _phone = [AControll createLabelWithFrame:CGRectMake((WinSize.width-250)*0.5, 40, 300, 30) text:[NSString stringWithFormat:@"验证码已发送到您的手机:%@",self.phoneNum] font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor blackColor]];
    _phone.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_phone];
    _coder = [AControll createTextFieldWithFrame:CGRectMake((WinSize.width-250)*0.5, 75, 250, 35) plceCoder:@"请输入四位验证码"];
    _coder.textColor = [UIColor grayColor];
    _coder.borderStyle = UITextBorderStyleNone;
    _coder.delegate = self;
    UILabel *letf = [AControll createLabelWithFrame:CGRectMake(0,10,55,35) text:@"验证码:  " font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor grayColor]];
    _coder.leftView = letf;
    letf.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_coder];
    [_coder setLeftViewMode:UITextFieldViewModeAlways];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((WinSize.width-250)*0.5, 105, 250, 1)];
    //线
    float c = 233/255.0;
    line.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
    [self.view addSubview:line];
    
    //时间
    _timeLb = [AControll createLabelWithFrame:CGRectMake((WinSize.width-250)*0.5, 106, 40, 35) text:@"(00)" font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor blueColor]];
    _timeLb.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_timeLb];
    //重新获取
    UIButton *reSet = [AControll createButtonWithFrame:CGRectMake((WinSize.width-250)*0.5+40, 106, 100, 40) title:@"重新获取验证码" titleColor:[UIColor blackColor] backgroungImage:nil tag:0];
    reSet.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [reSet addTarget:self action:@selector(reSetClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:reSet];
    //下一步
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.bounds = CGRectMake(0, 0, 220, 35);
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setBackgroundColor:UIColorFromRGB(0x4876FF)];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    next.center = self.view.center;
    [self.view addSubview:next];

}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_coder resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
