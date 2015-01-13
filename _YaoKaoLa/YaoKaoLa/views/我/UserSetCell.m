//
//  UserSetCell.m
//  yaokaola
//
//  Created by pro on 14/12/8.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "UserSetCell.h"
#import "ASwitch.h"
#import "BaseViewController.h"
@interface UserSetCell()
{
    UIImageView *_imgView;
    UILabel *_textLb;
    ASwitch *_sw;
    UILabel *_dtLb;
}
@end
@implementation UserSetCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        _textLb = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 40)];
        _textLb.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_textLb];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        _sw = [[ASwitch alloc] init];
        _sw.center = CGPointMake(WinSize.width-60, self.center.y);
        [self.contentView addSubview:_sw];
        _sw.hidden = YES;
    }
    return self;
}
- (void)updateData:(UserSetModel *)data{
    _sw.tag = self.tag;
    if (data.type == 0||data.type == 9){
        NSString *st = @"usercell_bg";
        if(data.type == 9){
            st = @"usercell4_bg";
        }
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:st]];
        self.textLabel.text = @"";
        _textLb.hidden = YES;
        _imgView.hidden = YES;
        self.textLabel.hidden = NO;
    }else{
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.textLabel.hidden = YES;
        _textLb.hidden = NO;
        _imgView.hidden = NO;
        _textLb.text = data.title;
        _imgView.image = [UIImage imageNamed:data.image];
        if (data.type == 1) {
            _imgView.frame = CGRectMake(10, 5, 60, 60);
            _textLb.frame = CGRectMake(70, 15, 100, 40);
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    //播放
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(data.type == 6)
    {   BOOL swIsOn = [[ud objectForKey:@"2G3G_play"] isEqualToString:@"YES"];
        [_sw setswIsOn:swIsOn];
        _sw.hidden = NO;
    }else if(data.type == 7){
        BOOL swIsOn = [[ud objectForKey:@"2G3G_download"] isEqualToString:@"YES"];
        [_sw setswIsOn:swIsOn];
        _sw.hidden = NO;
    }
    if (self.tag == 3||self.tag == 4||self.tag == 8) {
        _dtLb = [[UILabel alloc] initWithFrame:CGRectMake(WinSize.width-120, 0, 80, 40)];
        _dtLb.textAlignment = NSTextAlignmentRight;
        _dtLb.font = [UIFont systemFontOfSize:13];
        NSString *st = @"2014/10/18";
        if (self.tag == 4) {
            st = @"中医学";
        }else if(self.tag == 8){
            st = @"0.0 M";
        }
        _dtLb.text = st;
        [self.contentView addSubview:_dtLb];
    }
    
}
// 设置考试日期
- (void)setTestDate:(NSString *)date{
   
        _dtLb.text = date;
}
// 设置报考方向
- (void)setTestDirect:(NSString *)direct1{
    if (self.tag == 4) {
        _dtLb.text = direct1;
    }
}
//设置分割线
- (void)setSeperateLine{
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15, 39.5, WinSize.width-30, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xE6E6FA);
    [self.contentView addSubview:line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}

@end
