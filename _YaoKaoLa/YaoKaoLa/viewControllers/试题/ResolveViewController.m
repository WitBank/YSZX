//
//  ResolveViewController.m
//  yaokaola
//
//  Created by pro on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ResolveViewController.h"
#import "RandomTableView.h"
#import "RandomTopView.h"
#import "RandomModel.h"
#import "AControll.h"

#define RESOLVEVIEWCONTROLLER @"ResolveViewController"

@interface ResolveViewController ()

@end

@implementation ResolveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"试题解析";
    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(makeView) withObject:nil afterDelay:0.1];
    
    // Do any additional setup after loading the view.
}
//加载ScrollView上的数据
- (void)loadScollViewData{
    _scollView.frame = CGRectMake(0, 40, WinSize.width, WinSize.height-64-44);
    for (int i = 0; i< _dataArray.count; ++i) {
        RandomTableView *v = [[RandomTableView alloc] initWithFrame:CGRectMake(i*_scollView.frame.size.width, 0, _scollView.frame.size.width, _scollView.frame.size.height)];
        [_scollView addSubview:v];
        
        [_topView setAllPage:(int)_dataArray.count];
        [v setDataWithData:_dataArray[i]];
        v.allowsSelection = NO;
        v.allowsMultipleSelection = NO;
        //解析视图
        RandomModel *modle = _dataArray[i];
        UIView *foot = [[UIView alloc] init];
        //正确错误答案
        NSString *cst =@"";
        if(modle.selectArray&&modle.selectArray.count>0){
            cst =[modle.selectArray componentsJoinedByString:@","];
        }
        UILabel *lb = [AControll createLabelWithFrame:CGRectMake(0, 0, WinSize.width, 40) text:@"" font:[UIFont systemFontOfSize:15] textColor:nil];
        NSString *st = [NSString stringWithFormat:@"正确答案是:(%@),您的答案是:(%@)",modle.correctKey,cst];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:st];
        NSRange ran = [st rangeOfString:[NSString stringWithFormat:@"(%@)",modle.correctKey]];
        NSRange ran1 = [st rangeOfString:[NSString stringWithFormat:@"(%@)",cst] options:NSBackwardsSearch];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x2ea4fe) range:ran];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1] range:ran1];
        [lb setAttributedText:att];
        [foot addSubview:lb];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WinSize.width, 1)];
        float t = 233/255.0;
        line.backgroundColor = RGBColor(t, t, t, 1);
        [foot addSubview:line];
        //解析内容
        NSString *meDirection = [AControll getMedicineType]?@"中药":@"西药";
        NSString *anaSt = [NSString stringWithFormat:@"解析：\n%@\n涉及考点：%@",modle.analyes,meDirection];
        NSMutableAttributedString *stt = [[NSMutableAttributedString alloc] initWithString:anaSt];
        [stt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x2ea4fe) range:NSMakeRange(anaSt.length-2, 2)];
        CGSize size =[anaSt boundingRectWithSize:CGSizeMake(WinSize.width-10, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]} context:nil].size;
        UILabel *analyes = [AControll createLabelWithFrame:CGRectMake(5, 41, WinSize.width-10, size.height) text:@"" font:[UIFont boldSystemFontOfSize:14] textColor:nil];
        [analyes setAttributedText:stt];
        analyes.textAlignment = NSTextAlignmentLeft;
        analyes.numberOfLines = 0;
       
        foot.frame = CGRectMake(0, 0, WinSize.width, 41+size.height);
        [foot addSubview:analyes];

        v.tableFooterView = foot;
    }
    _scollView.contentSize = CGSizeMake(_dataArray.count*WinSize.width, 0);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [MTA trackPageViewBegin:RESOLVEVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{

    [MTA trackPageViewEnd:RESOLVEVIEWCONTROLLER];
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
