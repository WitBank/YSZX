//
//  RandomTableView.m
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "RandomTableView.h"
#import "AnswerCell.h"
@interface RandomTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView* _bgim;
    UILabel *_topLb;
    CGSize size;
    BOOL _isSigle; //单选
}
@property (nonatomic,copy)NSString *AparentContent;
@property (nonatomic,assign)RandomModel *data;
@end
@implementation RandomTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self){
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[AnswerCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

//设置底部视图
- (void)setFootView{
    
}
//初始化数据
- (void)setDataWithData:(RandomModel *)data{
    self.data = data;

    if(_data.parentContent == nil ||[_data.parentContent isEqualToString:@""]||[_data.parentContent isEqualToString:@"."]){
        self.AparentContent = @"";
    }else{
        NSMutableString *string = [NSMutableString stringWithString:data.parentContent];
        [string replaceOccurrencesOfString:@"&amp;lt;br&amp;gt;" withString:@"\n" options:0 range:NSMakeRange(0, string.length)];
        self.AparentContent = [NSString stringWithFormat:@"\n\n%@",_data.parentContent];
    }
    

    if ([data.questionsSortType isEqualToString:@"单选题"]) {
        self.allowsMultipleSelection = NO;
        _isSigle = YES;
    }else{
        _isSigle = NO;
        self.allowsMultipleSelection = YES;
    }
    [self reloadData];
}

#pragma mark -tableview代理
//取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    AnswerCell *cell = (AnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setAnswerSelected:NO];
    //取消答案
    AnswerModel *model = _data.answers[indexPath.row];
    model.isSelected = NO;
    NSString *seleKey = [NSString stringWithFormat:@"%c",[model.selectKey characterAtIndex:model.selectKey.length-1]];
    [_data.selectArray removeObject:seleKey];
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCell *cell = (AnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setAnswerSelected:YES];
    if (_data.selectArray == nil) {
        _data.selectArray = [[NSMutableArray alloc] init];
    }
    //选中答案添加
    AnswerModel *model = _data.answers[indexPath.row];
    model.isSelected = YES;
    NSString *seleKey = [NSString stringWithFormat:@"%c",[model.selectKey characterAtIndex:model.selectKey.length-1]];
    [_data.selectArray addObject:seleKey];
    
    if(_isSigle){
        if([self.randomDelegate respondsToSelector:@selector(gotoNextQuestion)]){
            [self.randomDelegate gotoNextQuestion];
        }
    }
    
}
//头部试题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_bgim == nil) {
        _bgim = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        _bgim.image = [[UIImage imageNamed:@"zzxian"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

        _topLb = [[UILabel alloc] initWithFrame:_bgim.frame];
        
        _topLb.numberOfLines = 0;
        _topLb.font = [UIFont boldSystemFontOfSize:15];
        _topLb.textColor = [UIColor grayColor];
        [_bgim addSubview:_topLb];
    }
    
    _topLb.text = [NSString stringWithFormat:@"(%@)%@%@",_data.questionsSortType,_data.questionsContent,self.AparentContent];
    _topLb.frame = CGRectMake((self.frame.size.width-310)*0.5, 0, 310, size.height+10);
    return _bgim;
}
//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.answers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AnswerModel *model = _data.answers[indexPath.row];
    [cell updateData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //内容大小
    
   size =[[NSString stringWithFormat:@"(%@)%@%@",_data.questionsSortType,_data.questionsContent,self.AparentContent] boundingRectWithSize:CGSizeMake(310, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f]} context:nil].size;

    return size.height+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
