//
//  RandomViewController.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "RandomViewController.h"
#import "RandomTopView.h"
#import "RandomTableView.h"
#import "RandomModel.h"
#import "AnswerboardViewController.h"
#import "SVProgressHUD.h"

#define RANDOMVIEWCONTROLLER @"RandomViewController"

@interface RandomViewController ()<UIScrollViewDelegate,AnswerbordViewDelegate,RandomTableViewDelegate>{
    BOOL isRequest;
}


@end
@implementation RandomViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackWithDisMissOrPop:0];
    
}
//单选下一题
- (void)gotoNextQuestion{
    int page = _scollView.contentOffset.x/WinSize.width + 1;
    if (page == _dataArray.count) {
        return;
    }
    [UIView animateWithDuration:0.45 animations:^{
        [self setScollTopage:page+1];
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isRequest == NO) {
        [self makeView];
        [self startRequest];
    }
    isRequest = YES;
    
    [MTA trackPageViewBegin:RANDOMVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:RANDOMVIEWCONTROLLER];
}

//跳转答题板
- (void)goAnswerBoard{
    AnswerboardViewController *ansBd = [[AnswerboardViewController alloc] init];
    ansBd.delegate = self;
    ansBd.dataArray = _dataArray;
    ansBd.examid = self.examId;
    NSString *bankId = @"1";
    if ([self.questionstype isEqualToString:@"0"]) {
        bankId = self.qSortId;
    }
    ansBd.questionbankId = bankId;
    ansBd.questionstype = self.questionstype;
    [self.navigationController pushViewController:ansBd animated:YES];
}

//点击跳转
- (void)buttonClick:(UIButton *)bt{
    //答题板
    if (!([self.navigationController.viewControllers lastObject] == self)) {
        return;
    }
    if (bt.tag == 0||bt.tag == 3) {
        [self goAnswerBoard];
    }else{
        
        [SVProgressHUD showSuccessWithStatus:@"暂未实现!"];
    }
}
- (void)makeView{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray array] init];
    }
    if([self.questionstype isEqualToString:@"1"]){
        self.title = @"随便练练";
    }else if([self.questionstype isEqualToString:@"2"]){
        self.title = @"模拟考试";
    }else{
        self.title = @"章节练习";
    }
    //顶部视图
    _topView = [[RandomTopView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, 40)];
    [self.view addSubview:_topView];
        //中间滚动视图
    _scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WinSize.width, WinSize.height-40-64-55)];
    _scollView.backgroundColor = [UIColor whiteColor];
    _scollView.pagingEnabled = YES;
    _scollView.delegate = self;
    _scollView.bounces = NO;
    _scollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scollView];
    
    //是答题
    if (!self.isResolve) {
        //底部导航
        UIImageView *tooBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, WinSize.height-55-64, WinSize.width, 55)];
        tooBar.userInteractionEnabled = YES;
        tooBar.backgroundColor = UIColorFromRGB(0x2ea4fe);
        NSArray *images = @[@"exercise_answer_card",@"shouchang",@"jiucuo",@"exercise_comdit"];
        NSArray *titles = @[@"答题板",@"收藏",@"纠错",@"提交"];
        float ttx = (WinSize.width - 68*4)*0.2;
        //底部四个按钮
        for (int i = 0 ; i < 4; ++i) {
            UIButton *ibt = [AControll createButtonWithFrame:CGRectMake(ttx+(ttx+68)*i, 0, 68, 55) title:titles[i] image:images[i] tag:i];
            [tooBar addSubview:ibt];
            [ibt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:tooBar];
    }else{
        [_topView setTitleLbWith:self.title];
        [self loadScollViewData];
    }
    
}
//开始请求
- (void)startRequest{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * userId = [ud objectForKey:@"userId"];
    NSString * qSortId = self.qSortId;
    int qStype = [AControll getMedicineType]; // 中药1西药0
  //  NSLog(@"questionsSortId == %@,questionstype == %d",qSortId,qStype);
    NSString * whereXml = [NSString stringWithFormat:@"<data><questionsSortId>%@</questionsSortId><UserId>%@</UserId><questionstype>%d</questionstype></data>",qSortId,userId,qStype];
    NSString* pageType=@"1";
    NSString * funtionType=@"4";
    NSString * dataType=@"1";
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:@"1" whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //xml解析
//        NSLog(@"%@",operation.responseString);
        NSString * xmlString= [XmlBody convertXMl:operation.responseString];
        NSArray *arr = [xmlString componentsSeparatedByString:@"㌕"];
        if (arr.count >= 2) {
            self.examId = arr[1];
        }
        
        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
        for (GDataXMLElement *ele in [doc nodesForXPath:@"//xmlns:ds" namespaces:@{@"xmlns":XMLHTTPHEAD,@"s":@"http://schemas.xmlsoap.org/soap/envelope/"} error:nil]) {
            RandomModel *data = [[RandomModel alloc] init];
            for (GDataXMLElement *el in [ele children]) {
                [data setValue:[el stringValue] forKey:[el name]];
            }
            [_dataArray addObject:data];
        }
        [SVProgressHUD dismiss];
        [self loadScollViewData];
        [_topView startTime];
        [_topView setAllPage:(int)_dataArray.count];
        [self masklayer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showMsg:@"网络不给力！"];
    }];
    [op start];
}
//加载ScrollView上的数据
- (void)loadScollViewData{
    for (int i = 0; i< _dataArray.count; ++i) {
        RandomTableView *v = [[RandomTableView alloc] initWithFrame:CGRectMake(i*_scollView.frame.size.width, 0, _scollView.frame.size.width, _scollView.frame.size.height)];
        v.randomDelegate = self;
        [_scollView addSubview:v];
        [v setDataWithData:_dataArray[i]];
    }
    _scollView.contentSize = CGSizeMake(_dataArray.count*WinSize.width, 0);
    [_topView setAllPage:(int)_dataArray.count];
}
//滚动到第几页
- (void)setScollTopage:(int)page{
    _scollView.contentOffset = CGPointMake((page-1)*WinSize.width, 0);
    [_topView setCurrenPage:page];
}
//获取答题时间
- (int)getSeconds{
    return [_topView getTime];
}
//第一次启动提示
- (void)masklayer{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:@"masklayer"]) {
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = RGBColor(0, 0, 0, 0.5);
        maskView.image = [UIImage imageNamed:@"masklayer_bg.png"];
        maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [maskView addGestureRecognizer:tap];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(0, 0, 200, 35);
        [bt setBackgroundImage:[UIImage imageNamed:@"mask_bt.png"] forState:UIControlStateNormal];
        bt.center = CGPointMake(maskView.center.x, maskView.center.y+40);
        [bt addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [maskView addSubview:bt];
        maskView.tag = 999;
        [self.view addSubview:maskView];
        [ud setObject:@"YES" forKey:@"masklayer"];
        [ud synchronize];
    }
}
- (void)tap:(id)sender{
    UIView *view = [self.view viewWithTag:999];
    [view removeFromSuperview];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/WinSize.width + 1;
    [_topView setCurrenPage:page];
}
//最后一页条转答题板
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int page = scrollView.contentOffset.x/WinSize.width + 1;
    if (page == _dataArray.count) {
        [self goAnswerBoard];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setDataArray:(NSMutableArray *)array{
    _dataArray = array;
}
- (NSArray *)dataArray{
    return _dataArray;
}
- (void)dealloc
{
    [_topView stopTime];
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
