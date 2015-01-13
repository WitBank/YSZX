//
//  AnswerboardViewController.m
//  yaokaola
//
//  Created by pro on 14/12/2.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "AnswerboardViewController.h"
#import "RandomModel.h"
#import "ComitViewController.h"
#import "SVProgressHUD.h"

#define ANSWERBOARDVIEWCONTROLLER @"AnswerboardViewController"

@interface AnswerboardViewController ()
{
    UILabel *_topLb;
    UIScrollView *_sc;
}
@property (nonatomic,copy)NSString *sTimes;
@end

@implementation AnswerboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.title = @"答题卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackWithDisMissOrPop:1];
    [self makeView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:ANSWERBOARDVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ANSWERBOARDVIEWCONTROLLER];
}

- (void)makeView{
    //头部
    UIView *_topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, 40)];
    float t = 233/255.0;
    _topView.backgroundColor = [UIColor colorWithRed:t green:t blue:t alpha:1];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 18, 22)];
    img.image = [UIImage imageNamed:@"parepeople_lan.png"];
    [_topView addSubview:img];
    
    _topLb = [AControll createLabelWithFrame:CGRectMake(35, 0, 300, 40) text:@"类型 : 章节练练" font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor blackColor]];
    if ([self.questionstype isEqualToString:@"1"]) {
        _topLb.text = @"类型 : 随便练练";
    }else if([self.questionstype isEqualToString:@"2"]){
        _topLb.text = @"类型 : 模拟考试";
    }
    _topLb.textAlignment = NSTextAlignmentLeft;
    [_topView addSubview:_topLb];
    [self.view addSubview:_topView];
    //中间
    _sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WinSize.width,WinSize.height - 65-64-70)];

    [self loadScView];
    [self.view addSubview:_sc];
    //已答未答
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, WinSize.height-65-64-40, WinSize.width, 40)];
    NSArray *titles = @[@"未答",@"已答"];
    NSArray *images = @[@"weida",@"yida"];
    for (int i = 0; i< 2; ++i) {
        UIButton *bt = [AControll createButtonWithFrame:CGRectMake(WinSize.width*0.5*i, 0, WinSize.width*0.5, 40) title:titles[i] titleColor:[UIColor blackColor] backgroungImage:nil tag:0];
        [bt setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [im addSubview:bt];
    }
    [self.view addSubview:im];

    //底部提交
    UIButton *tooBar = [[UIButton alloc] initWithFrame:CGRectMake(0, WinSize.height-55-64, WinSize.width, 55)];
    tooBar.userInteractionEnabled = YES;
    tooBar.backgroundColor = UIColorFromRGB(0x2ea4fe);
    [tooBar setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
    [tooBar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tooBar.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [tooBar addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tooBar];
}
//中间
- (void)loadScView{
    float ttx = (WinSize.width - 150)/6;
    int count = (int)_dataArray.count;
    for(int i = 0 ;i<count;i++){
        RandomModel *md = _dataArray[i];
        int type = 1;
        if (md.selectArray==nil||md.selectArray.count == 0) {
            type = 0;
        }
        UIButton *bt = [AControll createRButtonFrame:CGRectMake(ttx+(ttx+30)*(i%5), 40+(70)*(i/5), 30, 30) title:[NSString stringWithFormat:@"%d",i+1] type:type tag:i];
        [bt addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sc addSubview:bt];
        if (i == count-1) {
            _sc.contentSize = CGSizeMake(0, bt.frame.origin.y+80);
        }
    }
}
//点击题目
- (void)itemClick:(UIButton *)bt{
    if([self.delegate  respondsToSelector:@selector(setScollTopage:)]){
        [self.delegate setScollTopage:(int)bt.tag+1];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
- (void)buttonClick:(id)sender{

    [self startRequest];
   //
}
//请求数据
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
    ComitViewController *com = [[ComitViewController alloc] init];
    com.questionstype = self.questionstype;

    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:[self createXmlBody]];
    com.dataArray = self.dataArray;
    com.examId = self.examid;
    com.times = self.sTimes;
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //xml解析
        GDataXMLDocument  *ele = [[GDataXMLDocument alloc] initWithXMLString:[AControll getDataResultElementWithXml:operation.responseString] error:nil];
        int t = [[[ele rootElement] stringValue] intValue];
        if (t == 0) {
            [self showMsg:@"交卷失败"];
        }else{
            ((AppDelegate *)([UIApplication sharedApplication].delegate)).isCall = YES;
            ((AppDelegate *)([UIApplication sharedApplication].delegate)).menuCall = YES;

            [self.navigationController pushViewController:com animated:YES];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showMsg:@"网络连接失败！"];
    }];
    [op start];
}
    //构建xmlbody
- (XmlBody *)createXmlBody{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableString * whereXml = [NSMutableString stringWithString:@"<answerdata>"];
    NSString *userid = [ud objectForKey:@"userId"];
    NSString *examid = self.examid;//试卷id
    NSString *questionstype = self.questionstype;//1练一练，0章节

    NSString *times = @"00";
    if ([self.delegate respondsToSelector:@selector(getSeconds)]) {
        int time =[self.delegate getSeconds];
        times = [NSString stringWithFormat:@"%d",time];
        self.sTimes = [NSString stringWithFormat:@"交卷时间：%@ 用时：%02d:%02d",[AControll getTime],time/60,time%60];
    }
    NSString *medicinetype = [NSString stringWithFormat:@"%d",[AControll getMedicineType]];//中药，西药
    NSString *questionbankId = self.questionbankId;//练一练是1，章节对应的节点
    
    for (int i = 0 ; i < self.dataArray.count; ++i) {
        RandomModel *model = self.dataArray[i];
        NSString *questionsid = model.questionsId; // 每题id
        NSString *correctKey = model.correctKey; // 正确答案
        NSString *orderss = model.Orderss;
        if (model.selectArray) {
            [AControll sortArray:model.selectArray];//排序
        }
        NSString *useranswer = [model.selectArray componentsJoinedByString:@","];
        int trueandfalse = 0;//0错，1对
        if ([useranswer isEqualToString:correctKey]) {
            trueandfalse = 1;
        }
        NSString *s =[NSString stringWithFormat:@"<table><examid>%@</examid><questionstype>%@</questionstype><Orderss>%@</Orderss><questionsid>%@</questionsid><correctKey>%@</correctKey><useranswer>%@</useranswer><trueandfalse>%d</trueandfalse><times>%@</times><userid>%@</userid><medicinetype>%@</medicinetype><questionbankId>%@</questionbankId></table>",examid,questionstype,orderss,questionsid,correctKey,useranswer,trueandfalse,times,userid,medicinetype,questionbankId];
        [whereXml appendString:s];
    }
    [whereXml appendString:@"</answerdata>"];
    NSString* pageType=@"1";
    NSString * funtionType=@"22";
    NSString * dataType=@"1";
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:@"1" whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    return xml;
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
