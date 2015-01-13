//
//  ProposeViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ProposeViewController.h"
#import <AFNetworking/AFNetworking.h>

#define PROPOSEVIEWCONTROLLER @"ProposeViewController"
@interface ProposeViewController ()<UITextViewDelegate>

@end

@implementation ProposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"反馈与建议";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackWithDisMissOrPop:1];
    
    //输入文本框
    _propseText = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 200)];
    _propseText.layer.borderColor = [UIColorFromRGB(0xE6E6FA) CGColor];
    _propseText.layer.borderWidth = 1;
    _propseText.delegate = self;
     [self.view addSubview:_propseText];
    _propseText.font = [UIFont systemFontOfSize:15.0];
    label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH-10, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    [_propseText addSubview:label];
    label.text = @"请输入反馈与建议,我们将为您不断改进";
    
    _propseText.userInteractionEnabled = YES;
    _propseText.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    _propseText.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    _propseText.scrollEnabled = YES;//是否可以拖动

    _propseText.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [_propseText becomeFirstResponder];
    //首字母是否大写
    _propseText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //是否纠错
    _propseText.autocorrectionType = UITextAutocorrectionTypeNo;
    
   

    //提交Button
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 280, SCREENWIDTH-20, 40);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setEnabled:NO];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PROPOSEVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PROPOSEVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonAction:(UIButton *)btn
{
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeGradient];
    NSString *ms = [_propseText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw/feedback.jspx?ctgId=4&email=shenzl@qq.com&phone=18658160756&qq=645566259&title=1231&content=%@",ms];
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
    
        NSLog(@"%@",operation.responseString);
        _propseText.text = @"";
        [self textViewDidChange:_propseText];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showMsg:@"网络连接失败!"];
            [SVProgressHUD dismiss];
        }];
    [op start];
}

#pragma mark -UITextView
//如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [_propseText resignFirstResponder];
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_propseText.text == nil||[_propseText.text isEqualToString:@""]) {
        label.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES) {
        [_propseText resignFirstResponder];
        return NO;
    }
    return YES;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (_propseText.text !=nil &&![_propseText.text isEqualToString:@""]) {
        [button setEnabled:YES];
        label.hidden = YES;
    }else{
        label.hidden = NO;
        [button setEnabled:NO];
    }
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
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
