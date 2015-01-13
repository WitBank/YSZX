//
//  ComitViewController.m
//  yaokaola
//
//  Created by pro on 14/12/2.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ComitViewController.h"
#import "RandomModel.h"
#import "ComitModel.h"
#import "ResolveViewController.h"

#define COMITVIEWCONTROLLER @"ComitViewController"

@interface ComitViewController ()
{
    UILabel *_topLb;
    UIScrollView *_sc;
    UILabel *_pcLb; // 百分比
    UILabel *_defLb; //答对，击败
    NSMutableArray *_wrongArray;
}
@end

@implementation ComitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答题报告";
    [self setBackWithDisMissOrPop:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    [self startRequest];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:COMITVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:COMITVIEWCONTROLLER];
}

// 请求数据
- (void)startRequest{
    
    NSString * whereXml = self.examId; //试卷id

    NSString* pageType=@"1";
    NSString * funtionType=@"18";
    NSString * dataType=@"1";
    XmlBody *xml = [[XmlBody alloc] init];
    [xml setPageXml:@"1" whereXml:whereXml pageType:pageType functionType:funtionType dataType:dataType];
    //请求数据
    AFHTTPRequestOperation *op = [AControll createHttpOperatWithXmlBody:xml];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * xmlString= [XmlBody convertXMl:operation.responseString];

        GDataXMLDocument  *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
        ComitModel *model = [[ComitModel alloc] init];
        GDataXMLElement *ele = [[doc nodesForXPath:@"//xmlns:ds" namespaces:@{@"xmlns":XMLHTTPHEAD,@"s":@"http://schemas.xmlsoap.org/soap/envelope/"} error:nil] lastObject];
        for (GDataXMLElement *subEle in [ele children]) {
            [model setValue:subEle.stringValue forKey:subEle.name];
        }
        
        [self updateData:model];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showMsg:@"网络连接失败"];
    }];
    [op start];
}
- (void)makeView{
    //上方类型
    _topLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, 50)];
    _topLb.font = [UIFont systemFontOfSize:15];
    _topLb.numberOfLines = 2;

    NSString *tString = @"类型 : 章节练习";
    if ([self.questionstype isEqualToString:@"1"]) {
        tString = @"类型 : 随便练练";
    }else if([self.questionstype isEqualToString:@"2"]){
        tString = @"类型 : 模拟考试";
    }
    
    _topLb.text = [NSString stringWithFormat:@" %@\n %@",tString,self.times];
    [self.view addSubview:_topLb];
    //中间图片
    float tty = (WinSize.height -50-64-60)*0.5;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, WinSize.width, tty)];
    imv.image = [UIImage imageNamed:@"report_bg.png"];
    UILabel *clb = [AControll createLabelWithFrame:CGRectMake(10, 10, 100, 30) text:@"正确率" font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor whiteColor]];
    clb.textAlignment = NSTextAlignmentLeft;
    [imv addSubview:clb];
//    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(WinSize.width-40, 15, 20, 20)];
//    im.image = [UIImage imageNamed:@"report_share.png"];
//    [imv addSubview:im];
    //百分比
    _pcLb = [AControll createLabelWithFrame:CGRectMake(0, 0, tty*0.8, tty*0.8) text:@"0%" font:[UIFont boldSystemFontOfSize:30] textColor:[UIColor whiteColor]];
    _pcLb.center = CGPointMake(imv.bounds.size.width*0.5, imv.bounds.size.height*0.5);
    [imv addSubview:_pcLb];
    //答对，击败
    _defLb = [AControll createLabelWithFrame:CGRectMake(0, tty-30, WinSize.width, 30) text:@"答对0/0,击败0个小伙伴" font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor whiteColor]];
    [imv addSubview:_defLb];
    [self.view addSubview:imv];
    
    //中间答题板
    UILabel *lb = [AControll createLabelWithFrame:CGRectMake(0, 50+tty, 100, 20) text:@"  答题板" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    lb.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lb];
    _sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50+tty+20, WinSize.width,tty-15)];
    [self loadScView];
    [self.view addSubview:_sc];
    //底部2个按钮
    NSArray *images = @[@"all_pare_button.png",@"analysis_pare_button.png"];
    for (int i = 0 ; i < 2; ++i) {

        UIButton *ibt = [AControll createButtonWithFrame:CGRectMake(WinSize.width*0.5*i, WinSize.height-64-55, WinSize.width*0.5, 55) title:nil titleColor:nil backgroungImage:images[i] tag:i];

        [ibt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ibt];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(WinSize.width*0.5, WinSize.height-64-55, 0.5, 55)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
}
- (void)buttonClick:(UIButton *)bt{
    if (!([self.navigationController.viewControllers lastObject] == self)) {
        return;
    }
    ResolveViewController *rs = [[ResolveViewController alloc] init];
    rs.questionstype = self.questionstype; //练一练
    rs.isResolve = YES; // 解析参数
    //全部解析
    if (bt.tag == 0) {
        [rs setDataArray:_dataArray];
    }else{ // 错题解析
        [_wrongArray removeAllObjects];
        for (RandomModel *mod in _dataArray) {
            //错题
            if (_wrongArray == nil) {
                _wrongArray = [[NSMutableArray alloc] init];
            }

            if (![mod.correctKey isEqualToString:[mod.selectArray componentsJoinedByString:@","]]) {
                [_wrongArray addObject:mod];
            }
        }
        [rs setDataArray:_wrongArray];
    }
    [self.navigationController pushViewController:rs animated:YES];
}

//中间答题板
- (void)loadScView{
    float ttx = (WinSize.width - 140)/6;
    int count = (int)self.dataArray.count;
    for(int i = 0 ;i<count;i++){
        RandomModel *model = _dataArray[i];
        
        int type = 0;  //0 未答，1对，2错
        if ([model.correctKey isEqualToString:[model.selectArray componentsJoinedByString:@","]]) {
            type = 1;
            
        }else if(model.selectArray==nil||model.selectArray.count<=0){
            type = 0;
        }else{
            type = 2;
        }
        UIButton *bt = [AControll createRButtonFrame:CGRectMake(ttx+(ttx+30)*(i%5), 20+(70)*(i/5), 30, 30) title:[NSString stringWithFormat:@"%d",i+1] type:type tag:i];
        [bt addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [_sc addSubview:bt];
        if (i == count-1) {
            _sc.contentSize = CGSizeMake(0, bt.frame.origin.y+80);
        }
    }
}
//请求成功，刷新数据
- (void)updateData:(ComitModel *)model{
    NSString *st = [NSString stringWithFormat:@"%.2f",[model.avgnum floatValue]];
    NSNumber *numb = [NSNumber numberWithFloat:[st floatValue]];
    _pcLb.text = [NSString stringWithFormat:@"%@%%",numb];
    if (model.correctNum ==  nil) {
        model.correctNum = @"0";
    }
    if (model.quetsioncount == nil) {
        model.quetsioncount = @"0";
    }
    if (model.peoplenum == nil) {
        model.peoplenum = @"0";
    }
    _defLb.text = [NSString stringWithFormat:@"答对%@/%@,击败%@个小伙伴",model.correctNum,model.quetsioncount,model.peoplenum];
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
