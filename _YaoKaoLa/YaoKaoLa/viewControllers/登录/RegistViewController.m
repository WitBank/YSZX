//
//  RegistViewController.m
//  yaokaola
//
//  Created by pro on 14/12/1.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "RegistViewController.h"
#import "RegisterCoderController.h"

#define REGISTVIEWCONTROLLER @"RegistViewController"

@interface RegistViewController ()<UITextFieldDelegate>
{
    UITextField *_phone;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号注册";
    [self setBackWithDisMissOrPop:0];
    [self makeView];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:REGISTVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:REGISTVIEWCONTROLLER];
}

//下一步
- (void)next:(id)sender{
    [_phone resignFirstResponder];
    if (_phone.text == nil||[_phone.text isEqualToString:@""]){
        [self showMsg:@"账号不能为空！"];
        return;
    }
//    if ([self isCellPhone:_phone.text] == NO) {
//        [self showMsg:@"请输入正确的手机号!"];
//        return;
//    }
    [self startRequest];
}
- (BOOL)isCellPhone:(NSString *)phone{
    if (phone.length != 11||phone == nil) {
        return NO;
    }
    if ([phone characterAtIndex:0] != '1') {
        return NO;
    }
    for (int i = 0; i < phone.length; i++) {
        char c =[phone characterAtIndex:i];
        if (c <'0'||c>'9') {
            return NO;
        }
    }
    return YES;
}

//跳转下一页
- (void)gotoNext:(NSString *)code{
    [_phone resignFirstResponder];
    RegisterCoderController *next = [[RegisterCoderController alloc] init];
    next.phoneNum = _phone.text;
    next.code = code;
    [self.navigationController pushViewController:next animated:YES];
    
}


//请求数据
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"loading.." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString * whereXml = [NSString stringWithFormat:@"<data><PhoneNum>%@</PhoneNum></data>",_phone.text];
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
            [self gotoNext:result];

        }else{
            [self showMsg:result];
        }
        NSLog(@"%@",result);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
    
}
- (void)makeView{
    _phone = [AControll createTextFieldWithFrame:CGRectMake((WinSize.width-250)*0.5, 40, 250, 35) plceCoder:@"请输入手机号"];
    _phone.textColor = [UIColor grayColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((WinSize.width-250)*0.5, 75, 250, 1)];
    //线
    float c = 233/255.0;
    line.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
    [self.view addSubview:line];
    _phone.borderStyle = UITextBorderStyleNone;
    _phone.delegate = self;
    UILabel *letf = [AControll createLabelWithFrame:CGRectMake(0,10,55,35) text:@"手机号:  " font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor grayColor]];
    letf.textAlignment = NSTextAlignmentLeft;
    _phone.leftView = letf;
    [self.view addSubview:_phone];
    [_phone setLeftViewMode:UITextFieldViewModeAlways];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.bounds = CGRectMake(0, 0, 220, 35);
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setBackgroundColor:UIColorFromRGB(0x4876FF)];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    next.center = self.view.center;
    [self.view addSubview:next];
    UILabel *lb = [AControll createLabelWithFrame:CGRectMake(0, 78, WinSize.width, 30) text:@"为了账号安全，您的手机会收到短信验证码" font:[UIFont boldSystemFontOfSize:13] textColor:[UIColor blackColor]];
    [self.view addSubview:lb];

}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phone resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)back:(UIBarButtonItem *)item{
    [_phone resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
