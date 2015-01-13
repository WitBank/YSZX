//
//  LoginViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "LoginViewController.h"
#import "AControll.h"
#import "RegistViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import "AppDelegate.h"

#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]

#define LOGINVIEWCONTROLLER @"LoginViewController"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_count;
    UITextField *_passworld;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    //读取用户信息
    [self readUserInfo];
    // Do any additional setup after loading the view from its nib.
}

//读取用户信息
- (void)readUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"username"]) {
        _count.text = [ud objectForKey:@"username"];
        _passworld.text = [ud objectForKey:@"userpassword"];
    }
}
- (void)makeView{

    self.view.backgroundColor = [UIColor whiteColor];
    float t = (WinSize.height-20)*0.5-50;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WinSize.width,t)];
    [self.view addSubview:topView];
    
    
    //logo
    float twidth = WinSize.width*0.6;
    if (twidth > t){
        twidth = t - 10;
    }
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, twidth)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"login_logo@2x.png" ofType:nil];
    imgv.center = topView.center;
    imgv.image = [UIImage imageWithContentsOfFile:path];
    [topView addSubview:imgv];

    //输入框

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20+t,WinSize.width,t+100)];
    view.backgroundColor = UIColorFromRGB(0xF6F7F9);
    [self.view addSubview:view];
    float ttx = 20;

    NSArray *texts = @[@"账号：",@"密码："];
    NSArray *plceCoders = @[@"药师在线账号",@"请输入密码"];
    for (int i = 0;i < 2; i++){
        UITextField *tf = [AControll createTextFieldWithFrame:CGRectMake((WinSize.width-220)*0.5,ttx+i*55, 220, 35) plceCoder:plceCoders[i]];
        tf.font = [UIFont boldSystemFontOfSize:15];
        tf.delegate = self;
        tf.borderStyle = UITextBorderStyleNone;
        UILabel *letf = [AControll createLabelWithFrame:CGRectMake(0,10,55,35) text:texts[i] font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor grayColor]];
        tf.leftView = letf;
        [tf setLeftViewMode:UITextFieldViewModeAlways];
        if (i == 0 ) {
            _count = tf;
        }else{
            _passworld = tf;
            _passworld.secureTextEntry = YES;
        }
        [view addSubview:tf];
        //线
        float c = 233/255.0;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((WinSize.width-220)*0.5, tf.frame.origin.y+36, 220, 1)];
        line.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
        [view addSubview:line];
    }
    
    //登陆
    UIButton *login = [AControll createButtonWithFrame:CGRectMake((WinSize.width-220)*0.5, 110+ttx, 220, 35) title:nil titleColor:nil backgroungImage:@"login_button.png" tag:0];
    [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:login];
    //注册
    UIButton *regist = [AControll createButtonWithFrame:CGRectMake(0, 175+ttx, WinSize.width, 20) title:@"没有账号？  立即注册" titleColor:UIColorFromRGB(0x1E90FF) backgroungImage:nil tag:0];
    regist.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [regist addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:regist];
//   
    UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-60, WinSize.width, 40)];
    bottom.textAlignment = NSTextAlignmentCenter;
    bottom.numberOfLines = 0;
    bottom.font = [UIFont systemFontOfSize:14];
    NSString *text = @"药考啦V1.0 | 药师在线\nwww.51yaoshi.com";
    NSMutableAttributedString *stt = [[NSMutableAttributedString alloc] initWithString:text];
    [stt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xCDC9C9) range:NSMakeRange(text.length-17, 17)];
    [bottom setAttributedText:stt];
    [view addSubview:bottom];
    
    if(WinSize.height <= 480){
        //监听键盘弹出隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)noti{
    //键盘收起时间
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    }];
}
//键盘出现
-(void)keyboardWillshow:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    }];
}
//注册
- (void)registClick{
    RegistViewController *regist = [[RegistViewController alloc] init];
    regist.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:regist];
    [self presentViewController:nv animated:YES completion:nil];
}
//登录
- (void)login:(id)sender{
    [_count resignFirstResponder];
    [_passworld resignFirstResponder];
    [SVProgressHUD showWithStatus:@"login.." maskType:SVProgressHUDMaskTypeGradient];
    [self startRequest];
}
//请求数据
- (void)startRequest{
    //设备唯一标识
    NSString *identifier = [[UIDevice currentDevice]uniqueGlobalDeviceIdentifier];
    NSString *count = _count.text;
    NSString *password = _passworld.text;
    NSString * whereXml = [NSString stringWithFormat:@"<data><LoginName>%@</LoginName><Password>%@</Password><appid>%@</appid></data>",count,password,identifier];
    NSString * pageType=@"1";
    NSString * funtionType=@"0";
    NSString * dataType=@"1";
    //设置参数
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:nil whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //xml解析
      //  NSLog(@"%@",operation.responseString);
        NSString *st = [AControll getDataResultElementWithXml:operation.responseString];

        NSArray *carray = [st componentsSeparatedByString:@"="];
        NSString *userId = @"";
        NSString *meDirection = @"";
        NSString *directionTime = @"";
        if (carray.count>=4) {
            userId = [carray objectAtIndex:1];
            meDirection = [carray objectAtIndex:2];
            directionTime = [carray objectAtIndex:3];
            
        }

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        st = [[st componentsSeparatedByString:@"="] lastObject];
        st = [[st componentsSeparatedByString:@"<"] firstObject];
        [ud setObject:st forKey:@"acountData"];
        //选择方向 西药0，中药1
        [ud setObject:meDirection forKey:@"meDirection"];
        //报考时间
        [ud setObject:directionTime forKey:@"directionTime"];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[st dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *msg = dict[@"msg"];
        //登录成功
        if ([msg isEqualToString:@"登录成功"]) {
            [self showMainView];
            //保存信息
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            [ud setObject:dict[@"username"] forKey:@"username"];
            [ud setObject:_passworld.text forKey:@"userpassword"];
            [ud setObject:dict[@"userId"] forKey:@"JSuserId"];
            [ud setObject:userId forKey:@"userId"];
            [ud synchronize];
            
            //账号保存到plist中
            [self saveUserInfo];
            
        }else{ //登录失败
            [self showMsg:dict[@"msg"]];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showMsg:@"网络连接失败!"];

    }];
    [op start];
}
//保存到plist中
- (void)saveUserInfo{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{     @"username":[ud objectForKey:@"username"],
                                @"userpassword":[ud objectForKey:@"userpassword"],
                                @"acountData":[ud objectForKey:@"acountData"],
                                @"userId":[ud objectForKey:@"userId"],
                                @"JSuserId":[ud objectForKey:@"JSuserId"],
                                @"meDirection":[ud objectForKey:@"meDirection"],
                                @"directionTime":[ud objectForKey:@"directionTime"],
                        };
    //获取
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:PATH];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    //去重
    for (NSDictionary *dc in array) {
        NSString *userName = [dc objectForKey:@"username"];
        if ([userName isEqualToString:dict[@"username"]]) {
            [array removeObject:dc];
            break;
        }
    }
    [array insertObject:dict atIndex:0];
    
    [array writeToFile:PATH atomically:YES];
    NSString *fileName = [NSString stringWithFormat:@"Documents/%@/",[dict objectForKey:@"username"]];
    NSString*filepath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [manager fileExistsAtPath:filepath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

//跳转到主页
- (void)showMainView{
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) showMainView];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_count resignFirstResponder];
    [_passworld resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_count resignFirstResponder];
    [_passworld resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _count.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    [MTA trackPageViewBegin:LOGINVIEWCONTROLLER];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:LOGINVIEWCONTROLLER];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_count resignFirstResponder];
    [_passworld resignFirstResponder];
    return YES;
}
- (void)dealloc
{
    if(WinSize.height <= 480){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
