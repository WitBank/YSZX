//
//  AboutViewController.m
//  YaoKaoLa
//
//  Created by pro on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于药考啦";
    [self setBackWithDisMissOrPop:1];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WinSize.width, WinSize.height-64)];
    NSString *st = @"aboutyaokaola2.png";
    if (WinSize.height <= 480) {
        st = @"aboutyaokaola1.png";
    }
    UIImage *image = [UIImage imageNamed:st];
    img.image = image;
    [self.view addSubview:img];
    
    // Do any additional setup after loading the view.
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
