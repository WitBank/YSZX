//
//  BaseViewController.m
//  test
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
@interface BaseViewController ()
{
    UIImageView *_bgView;
    UILabel *_msgLabel;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            _allController_y = 64;
        }else{
            _allController_y = 44;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setBackWithDisMissOrPop:(int)back{
    //返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    item.tag = back;
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back:(UIBarButtonItem *)item{
    if (item.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//显示请求的信息
- (void)showMsg:(NSString *)msg{
    //文本内容的大小
    _bgView.hidden = NO;

    CGSize size =[msg boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]} context:nil].size;
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font = [UIFont boldSystemFontOfSize:14];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.numberOfLines = 0;
        _bgView = [[UIImageView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [[UIColor grayColor]CGColor];
        
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [_bgView addSubview:_msgLabel];
        [self.view addSubview:_bgView];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.center = CGPointMake(self.view.center.x, self.view.center.y+70);
    } completion:^(BOOL finished) {
        _bgView.bounds = CGRectMake(0, 0, size.width+20, size.height+10);
        _bgView.center = CGPointMake(self.view.center.x, self.view.center.y+70);
        _msgLabel.frame = CGRectMake(10, 5, size.width, size.height);
        _msgLabel.text = msg;
    }];
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideMsg) object:Nil];
    [self performSelector:@selector(hideMsg) withObject:nil afterDelay:2.0f];
}
- (void)hideMsg{
    _bgView.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
