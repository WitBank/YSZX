//
//  RegisterPassWorldViewController.m
//  yaokaola
//
//  Created by pro on 14/12/22.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "RegisterPassWorldViewController.h"
#import "ApplyDirectionViewController.h"
#import "UIDevice+IdentifierAddition.h"

#define REGISTERPASSWORLDVIEWCONTROLLER @"RegisterPassWorldViewController"

@interface RegisterPassWorldViewController ()<UITextFieldDelegate>
{
    UITextField *_pswd;
    
}
@property (nonatomic,copy) NSString *mobType;
@end

@implementation RegisterPassWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写密码";
    [self setBackWithDisMissOrPop:1];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:REGISTERPASSWORLDVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:REGISTERPASSWORLDVIEWCONTROLLER];
}

//下一步
- (void)next:(id)sender{
    if (_pswd == nil ||[_pswd.text isEqualToString:@""]) {
        [self showMsg:@"请填写密码！"];
        return;
    }

    [self startRequest];
    
}
- (BOOL)isCellPhone:(NSString *)phone{
    if (phone.length <= 11||phone == nil) {
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
- (void)goNext{
    ApplyDirectionViewController *apvc = [[ApplyDirectionViewController alloc] init];
    apvc.from = 1;
    apvc.mobType = self.mobType;
    apvc.type = 0;
    apvc.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:apvc animated:YES];
}
//重新请求数据
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"正在注册.." maskType:SVProgressHUDMaskTypeBlack];
    NSString *identifier = [[UIDevice currentDevice]uniqueGlobalDeviceIdentifier];
    NSString * whereXml = [NSString stringWithFormat:@"<data><LoginName>%@</LoginName><Password>%@</Password><appid>%@</appid></data>",self.phoneNum,_pswd.text,identifier];
    NSString * pageType=@"1";
    NSString * funtionType=@"1";
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
       // NSLog(@"%@",st);
        NSArray *array = [st componentsSeparatedByString:@"="];
        NSString *result = @"";
        NSString *userData =@"";
        self.mobType = @"0";
        if (array.count>=3) {
            result = array[1];
            userData = array[0];
            self.mobType = array[2];
        }

        if([result isEqualToString:@"注册成功"]){
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"acountData"];
            [self goNext];
        }else{
            NSArray *stArray = [st componentsSeparatedByString:@"="];
            NSString *msg = @"注册失败！";
            if(stArray.count>=1){
                msg = stArray[1];
            }
            [self showMsg:msg];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showMsg:@"网络连接失败！"];
        [SVProgressHUD dismiss];
    }];
    [op start];
}


- (void)makeView{
    
    UILabel *lable = [AControll createLabelWithFrame:CGRectMake((WinSize.width-250)*0.5, 40, 300, 30) text:[NSString stringWithFormat:@"填写密码"] font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
    lable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lable];
    
    _pswd = [AControll createTextFieldWithFrame:CGRectMake((WinSize.width-250)*0.5, 75, 250, 35) plceCoder:@"不少于六位"];
    _pswd.textColor = [UIColor grayColor];
    _pswd.borderStyle = UITextBorderStyleNone;
    _pswd.secureTextEntry = YES;
    _pswd.delegate = self;
    UILabel *letf = [AControll createLabelWithFrame:CGRectMake(0,10,45,35) text:@"密码: " font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor grayColor]];
    _pswd.leftView = letf;
    letf.textAlignment = NSTextAlignmentLeft;
    [_pswd setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:_pswd];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((WinSize.width-250)*0.5, 105, 250, 1)];
    //线
    float c = 233/255.0;
    line.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
    [self.view addSubview:line];
    //下一步
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.bounds = CGRectMake(0, 0, 220, 35);
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next setTitle:@"立即注册" forState:UIControlStateNormal];
    [next setBackgroundColor:UIColorFromRGB(0x4876FF)];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    next.center = self.view.center;
    [self.view addSubview:next];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_pswd resignFirstResponder];
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
