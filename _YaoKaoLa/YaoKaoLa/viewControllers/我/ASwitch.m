//
//  ASwitch.m
//  xib1
//
//  Created by pro on 14/12/8.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "ASwitch.h"
@interface ASwitch()
{
    UIButton *thub;
    UIImageView *onImg;
    UIImageView *offImg;
}
@end
@implementation ASwitch

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 45, 17);
        NSArray *imags = @[@"bg_switch_on.png",@"bg_switch_off.png",];
        for (int i = 0; i< 2; ++i) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 17)];
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = 8;
            img.image = [UIImage imageNamed:imags[i]];
            [self addSubview:img];
            if (i == 0) {
                onImg = img;
            }else{
                offImg = img;
            }
        }
        thub = [UIButton buttonWithType:UIButtonTypeCustom];
        thub.frame = CGRectMake(0, 0.25, 16, 16);
        thub.backgroundColor = [UIColor whiteColor];
        thub.layer.masksToBounds = YES;
        thub.layer.cornerRadius = 8;
        [thub addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:thub];

        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setswIsOn:(BOOL)isOn{
    self.isOn = isOn;
    if (self.isOn) {
        thub.frame = CGRectMake(45-17, 0.25, 16, 16);
        offImg.frame = CGRectMake(45, 0, 0, 17);
        
    }else{
        thub.frame = CGRectMake(0, 0.25, 16, 16);
        offImg.frame = CGRectMake(0, 0, 45, 17);
    }
}
- (void)click:(id)sender{
    self.isOn = !self.isOn;
    if (self.isOn) {
        [UIView animateWithDuration:0.2 animations:^{
            thub.frame = CGRectMake(45-17, 0.25, 16, 16);
            offImg.frame = CGRectMake(45, 0, 0, 17);
        }];
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            thub.frame = CGRectMake(0, 0.25, 16, 16);
            offImg.frame = CGRectMake(0, 0, 45, 17);
        }];
    }
    //播放
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (self.tag == 6) {
        [ud setObject:self.isOn?@"YES":@"NO" forKey:@"2G3G_play"];
    }else if(self.tag == 7){ // 下载
        [ud setObject:self.isOn?@"YES":@"NO" forKey:@"2G3G_download"];
    }
    [ud synchronize];
}
@end
