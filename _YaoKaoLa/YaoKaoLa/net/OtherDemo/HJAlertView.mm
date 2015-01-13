//
//  HJAlertView.m
//  XCTG3
//
//  Created by lujianhui on 13-12-9.
//  Copyright (c) 2013年 lthj. All rights reserved.
//  弹出框

#import "HJAlertView.h"
#import "ZHCustomControl.h"

@implementation HJAlertView
@synthesize textFieldArray;
@synthesize rightButton;


-(void)dealloc
{
    rightButton = nil;
    textFieldArray = nil;
    addInfo = nil;
}

//-(void)deviceOrientionDidChange
//{
//    
//    if([_delegate isKindOfClass:[UIViewController class]])
//    {
//        UIViewController *viewCtl = (UIViewController *)_delegate;
//        switch (viewCtl.interfaceOrientation) {
//            case UIInterfaceOrientationPortrait://上
//                backView.transform = CGAffineTransformMakeRotation(0);
//                break;
//            case UIInterfaceOrientationLandscapeRight://右
//                backView.transform = CGAffineTransformMakeRotation(M_PI/2);
//                break;
//            case UIInterfaceOrientationPortraitUpsideDown://下
//                backView.transform = CGAffineTransformMakeRotation(M_PI);
//                break;
//            case UIInterfaceOrientationLandscapeLeft://左
//                backView.transform = CGAffineTransformMakeRotation(M_PI*3/2);
//                break;
//            default:
//                break;
//        }
//    }
//}

#pragma mark - init

//1.针对显示字符串的style
-(id)initWithTitle:(NSString *)stTitle
           message:(NSString *)stMsg
          delegate:(id /*<HJAlertViewDelegate>*/)delegate
           addInfo:(id)add_info
      buttonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if(self)
    {
        /*
         //如果支持旋转屏幕
         [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientionDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
         */
        _delegate = delegate;
        addInfo = add_info;
        //1. 获取按钮个数
        btnArray = [[NSMutableArray alloc]  initWithCapacity:2];
        va_list arglist;
        va_start(arglist, otherButtonTitles);
        id arg;
        if(otherButtonTitles)
        {
            [btnArray addObject:otherButtonTitles];
            while((arg = va_arg(arglist, id))) {
                if (arg)
                {
                    [btnArray addObject:arg];
                }
            }
        }
        else
        {
            //没有 默认为确定
            [btnArray addObject:@"确 定"];
        }
        va_end(arglist);
        
        //2. 添加背景 == self
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.frame;
        self.center = window.center;
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];//[UIColor clearColor];
        [window addSubview:self];
        
        
        //3.判断动态高度
        //判断内容高度
        CGSize constraint = CGSizeMake(180, self.frame.size.height - 100-45);
        if([btnArray count]>2)
        {
            constraint = CGSizeMake(180, self.frame.size.height - 100-[btnArray count]*45);
        }
        CGSize msgSize = [stMsg sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        float msgHeight = msgSize.height + 15;//内容高度
        float backViewHeight = 0;//backView高度
        float titleHeight = 35;//标题高度
        if(stTitle == nil || [stTitle isEqualToString:@""])
        {
            titleHeight = 0;
        }
        BOOL  bScrolEnable = NO;
        //根据按钮个数，判断按钮高度
        if([btnArray count] <=2)
        {
            //小于两个按钮  横排放
            if(msgHeight <= 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.bounds.size.height - 150-45)
            {
                msgHeight = self.bounds.size.height - 145;
                bScrolEnable = YES;
            }
            else
            {
                if(msgHeight >200)
                {
                    msgHeight -=  35;
                    bScrolEnable = YES;
                }
            }
            backViewHeight = msgHeight + 45+ titleHeight+10;
        }
        else
        {
            //大于两个按钮 竖排存放
            if(msgHeight < 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.frame.size.height - 150-[btnArray count]*45)
            {
                msgHeight = self.frame.size.height - 150 -[btnArray count]*45;
                bScrolEnable = YES;
            }
            backViewHeight = msgHeight + titleHeight+10 + 45*[btnArray count];
        }
        
        //4. 设置背景视图
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (self.frame.size.height-backViewHeight)/2, 270, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = HEXCOLOR(0xe1e1e1);
        //        backView.layer.borderWidth = 0.5;
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        
        //5. 添加 标题
        if(stTitle && ![stTitle isEqualToString:@""])
        {
            titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,backView.frame.size.width-20,35)];
            titlelabel.text = stTitle;
            titlelabel.font = [UIFont systemFontOfSize:17];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titlelabel];
        }
        
        //6. 添加 消息
        NSRange range = [stMsg rangeOfString:@"\n"];
        if(stMsg.length<18 && range.location == NSNotFound)
        {
            //如果一行 上下居中显示。则把textview的位置居中
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10,titleHeight+10+(msgHeight -msgSize.height-10)/2,backView.frame.size.width-20,msgSize.height+10)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        else
        {
            //多行显示
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10,titleHeight+10,backView.frame.size.width-20,msgHeight)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        
        //7. 添加 按钮
        float nBtnHeigtht = 40;//btn默认高度
        if(textView.frame.origin.x+textView.frame.size.height >= backView.frame.size.height-40)
        {
            nBtnHeigtht = backView.frame.size.height - (textView.frame.origin.x+textView.frame.size.height) - 3;
        }
        //单个按钮
        if(1 == [btnArray count])
        {
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width+1.0f,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn1.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
        }
        //2个按钮
        else if(2 == [btnArray count])
        {
            
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width/2+1.0f,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn1.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
            
            UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(backView.frame.size.width/2,backView.frame.size.height-40,backView.frame.size.width/2+1.0f,40+1.0f);
            btn2.tag = 101;
            [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn2 setTitle:[btnArray objectAtIndex:1] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn2.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn2.layer.borderWidth = 0.5f;
            [backView addSubview:btn2];
        }
        //多个按钮
        else if([btnArray count]>2)
        {
            UIImage * btnGray0 = [UIImage imageNamed:@"cancel"];
            for(int i=0;i<[btnArray count];i++)
            {
                UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10,backView.frame.size.height-45*([btnArray count] - i),backView.frame.size.width-20,35);
                [btn setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.tag = i+100;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:btnGray0 forState:UIControlStateNormal];
                [backView addSubview:btn];
            }
        }
    }
    return  self;
}

//2.下面为title下方带横线  并且可以点击空白消失  中间内容视图label内容居中
-(id)initWithTitle:(NSString *)stTitle
        andMessage:(NSString *)stMsg
       andDelegate:(id /*<HJAlertViewDelegate>*/)delegate
        andAddInfo:(id)add_info andButtonColor:(UIColor *)buttonColor
   andButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        addInfo = add_info;
        //按钮个数
        btnArray = [[NSMutableArray alloc]  initWithCapacity:2];
        va_list arglist;
        va_start(arglist, otherButtonTitles);
        id arg;
        if(otherButtonTitles)
        {
            [btnArray addObject:otherButtonTitles];
            while((arg = va_arg(arglist, id))) {
                if (arg)
                {
                    [btnArray addObject:arg];
                }
            }
        }
        else
        {
            //没有 默认为确定
            [btnArray addObject:@"确 定"];
        }
        va_end(arglist);
        
        //添加背景 == self
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.bounds;
        self.center = window.center;
        self.backgroundColor = [UIColor clearColor];//;
        [window addSubview:self];
        UIControl *popViewcontrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        popViewcontrol.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [popViewcontrol addTarget:self action:@selector(hideAlertAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:popViewcontrol];
        
        //判断动态高度
        CGSize constraint = CGSizeMake(180*WIDTHPROPORTION, self.frame.size.height - (100+45)*WIDTHPROPORTION);
        if([btnArray count]>2)
        {
            constraint = CGSizeMake(180*WIDTHPROPORTION, self.frame.size.height - 100*WIDTHPROPORTION-[btnArray count]*45*WIDTHPROPORTION);
        }
        CGSize msgSize = [stMsg sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        
        float msgHeight = msgSize.height + 15*WIDTHPROPORTION;//内容高度
        float backViewHeight = 0;//backView高度
        float titleHeight = 35*WIDTHPROPORTION;//标题高度
        if(stTitle == nil || [stTitle isEqualToString:@""])
        {
            titleHeight = 0;
        }
        BOOL  bScrolEnable = NO;
        
        if([btnArray count] <=2)
        {
            //小于两个按钮  横排放
            if(msgHeight <= 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.bounds.size.height - (150+45)*WIDTHPROPORTION)
            {
                msgHeight = self.bounds.size.height - 145*WIDTHPROPORTION;
                bScrolEnable = YES;
            }
            else
            {
                if(msgHeight >200*WIDTHPROPORTION)
                {
                    msgHeight -=  35*WIDTHPROPORTION;
                    bScrolEnable = YES;
                }
            }
            backViewHeight = msgHeight + 45*WIDTHPROPORTION+ titleHeight+10*WIDTHPROPORTION;
        }
        else
        {
            //大于两个按钮 竖排存放
            if(msgHeight < 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.frame.size.height - 150*WIDTHPROPORTION-[btnArray count]*45*WIDTHPROPORTION)
            {
                msgHeight = self.frame.size.height - 150*WIDTHPROPORTION -[btnArray count]*45*WIDTHPROPORTION;
                bScrolEnable = YES;
            }
            backViewHeight = msgHeight + titleHeight+10*WIDTHPROPORTION + 45*[btnArray count]*WIDTHPROPORTION;
        }
        
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25*WIDTHPROPORTION, (self.frame.size.height-backViewHeight)/2, 270*WIDTHPROPORTION, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        //        backView.layer.borderWidth = 0.5;
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        //标题
        if(stTitle && ![stTitle isEqualToString:@""])
        {
            titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,5*WIDTHPROPORTION,backView.frame.size.width-20*WIDTHPROPORTION,35*WIDTHPROPORTION)];
            titlelabel.text = stTitle;
            titlelabel.font = [UIFont systemFontOfSize:15];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titlelabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46*WIDTHPROPORTION, backView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:HJCOLORLINE];
            [backView addSubview:lineView];
        }
        //消息
        NSRange range = [stMsg rangeOfString:@"\n"];
        CGFloat contentHeight = (backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION - msgSize.height)/2 + 35*WIDTHPROPORTION;
        if(stMsg.length<18 && range.location == NSNotFound)
        {
            //如果一行 上下居中显示。则把textview的位置居中
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,contentHeight,backView.frame.size.width-20*WIDTHPROPORTION,backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        else
        {
            
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,contentHeight,backView.frame.size.width-20*WIDTHPROPORTION,backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        
        //按钮
        float nBtnHeigtht = 40*WIDTHPROPORTION;//btn默认高度
        if(textView.frame.origin.x+textView.frame.size.height >= backView.frame.size.height-40*WIDTHPROPORTION)
        {
            nBtnHeigtht = backView.frame.size.height - (textView.frame.origin.x+textView.frame.size.height) - 3;
        }
        if(1 == [btnArray count])
        {
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width+1.0f,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:buttonColor forState:UIControlStateNormal];
//            btn1.titleLabel.textColor = buttonColor;
            btn1.layer.borderColor = HJCOLORLINE.CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
        }
        else if(2 == [btnArray count])
        {
            
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width/2+1.0f+0.5,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:buttonColor forState:UIControlStateNormal];
            btn1.layer.borderColor = HJCOLORLINE.CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
            
            UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(backView.frame.size.width/2,backView.frame.size.height-40*WIDTHPROPORTION,backView.frame.size.width/2+1.0f,(40+1.0f)*WIDTHPROPORTION);
            btn2.tag = 101;
            [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn2 setTitle:[btnArray objectAtIndex:1] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitleColor:buttonColor forState:UIControlStateNormal];
            btn2.layer.borderColor = HJCOLORLINE.CGColor;
            btn2.layer.borderWidth = 0.5f;
            [backView addSubview:btn2];
        }
        else if([btnArray count]>2)
        {
            UIImage * btnGray0 = [UIImage imageNamed:@"cancel"];
            for(int i=0;i<[btnArray count];i++)
            {
                UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10*WIDTHPROPORTION,backView.frame.size.height-45*([btnArray count] - i)*WIDTHPROPORTION,backView.frame.size.width-20*WIDTHPROPORTION+0.5,35*WIDTHPROPORTION);
                [btn setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.tag = i+100;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:btnGray0 forState:UIControlStateNormal];
                [backView addSubview:btn];
            }
        }
    }
    return  self;
}

//3.针对带有button显示字符串的style
-(id)initButtonAlertmessage:(NSString *)stMsg
                   delegate:(id)delegate
                    addInfo:(id)add_info
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        addInfo = add_info;
        
        btnArray=[[NSMutableArray alloc] initWithObjects:@"取消",@"继续", nil];

        //添加背景 == self
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.frame;
        self.center = window.center;
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
        [window addSubview:self];
        
        //判断动态高度
        CGSize constraint = CGSizeMake(180,self.frame.size.height - 100-45);
        CGSize msgSize = [stMsg sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        
        float msgHeight = msgSize.height + 15;//内容高度
        BOOL  bScrolEnable = NO;
        
        if(msgHeight <= 80)
        {
            msgHeight = 80;//如果高度比较小的话让其在中间显示出来
        }
        else if(msgHeight >= self.bounds.size.height - 150-45)//如果高度比较大的话让其能够显示出来
        {
            msgHeight = self.bounds.size.height - 145;
            bScrolEnable = YES;
        }
        else
        {
            if(msgHeight >250)
            {
                msgHeight -=  35;
            }
        }
        float backViewHeight = msgHeight + 45+10+17;//backView高度，也就是弹出框所显示的包括按钮范围之内的大小
        
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (self.frame.size.height-backViewHeight)/2, 270, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = HEXCOLOR(0xe1e1e1);
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        //消息
        NSRange range = [stMsg rangeOfString:@"\n"];
        if(stMsg.length<18 && range.location == NSNotFound)
        {
            //如果一行 上下居中显示。则把textview的位置居中
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10,10+(msgHeight -msgSize.height-10)/2,backView.frame.size.width-20-30,msgSize.height+10)];
            textView.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10,10,backView.frame.size.width-20,msgHeight)];
            textView.textAlignment = NSTextAlignmentCenter;
        }
        textView.backgroundColor = [UIColor clearColor];
        textView.scrollEnabled = bScrolEnable;
        textView.dataDetectorTypes = UIDataDetectorTypeNone;
        textView.font = [UIFont systemFontOfSize:14];
        textView.delegate=self;
        textView.text=stMsg;
        [backView addSubview:textView];
        
        rightButton=[[UIButton alloc] initWithFrame:CGRectMake(25,textView.frame.size.height+textView.frame.origin.y,17,17)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"g3_txt_password"] forState:UIControlStateNormal];
        [backView addSubview:rightButton];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.tag=0;
        
        UILabel *labelShow=[[UILabel alloc] initWithFrame:CGRectMake(50,rightButton.frame.origin.y,100,17)];
        labelShow.font=[UIFont systemFontOfSize:14];
        labelShow.text=@"不再提示";
        labelShow.textColor=[UIColor blackColor];
        labelShow.backgroundColor=[UIColor clearColor];
        [backView addSubview:labelShow];
        
        //按钮
        float nBtnHeigtht = 40;//btn默认高度
        UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width/2+1.0f,nBtnHeigtht+1.0f);
        btn1.tag = 100;
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
        btn1.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
        btn1.layer.borderWidth = 0.5f;
        [backView addSubview:btn1];
            
        UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(backView.frame.size.width/2,backView.frame.size.height-40,backView.frame.size.width/2+1.0f,nBtnHeigtht+1.0f);
        btn2.tag = 101;
        [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [btn2 setTitle:[btnArray objectAtIndex:1] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
        btn2.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
        btn2.layer.borderWidth = 0.5f;
        [backView addSubview:btn2];
    }
    return  self;
}

//4.针对全部是输入框的style
-(id)initWithAlertInputStyleTitles:(NSString *)stTitle
                 placeholderTitles:(NSArray *)place_HoldsArray
                          delegate:(id /*<HJAlertViewDelegate>*/)delegate
                           addInfo:(id)add_info
                      buttonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if(self)
    {
        
        _delegate = delegate;
        addInfo = add_info;
        //按钮个数
        btnArray = [[NSMutableArray alloc]  initWithCapacity:2];
        va_list arglist;
        va_start(arglist, otherButtonTitles);
        id arg;
        if(otherButtonTitles)
        {
            [btnArray addObject:otherButtonTitles];
            while((arg = va_arg(arglist, id))) {
                if (arg)
                {
                    [btnArray addObject:arg];
                }
            }
        }
        else
        {
            //没有 默认为确定
            [btnArray addObject:@"确 定"];
        }
        va_end(arglist);
        
        
        //添加背景 == self
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.frame;
        self.center = window.center;
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];//[UIColor clearColor];
        [window addSubview:self];
        
        placeHoldsArray = [[NSMutableArray alloc] initWithCapacity:2];
        [placeHoldsArray removeAllObjects];
        if(place_HoldsArray == nil)
        {
            //如果place_HoldsArray == nil  则默认一个输入框 ，标题titlelabel.text代替palceHolder的功能来表述输入框的作用
            [placeHoldsArray addObject:@""];
        }
        else
        {
            [placeHoldsArray addObjectsFromArray:place_HoldsArray];
        }
        //判断动态高度
        float backViewHeight  = 134+[placeHoldsArray count]*38;
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (self.frame.size.height-backViewHeight)/2, 270, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = HEXCOLOR(0xe1e1e1);
        //        backView.layer.borderWidth = 0.5;
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        
        //标题
        if(stTitle && ![stTitle isEqualToString:@""])
        {
            titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10,20,backView.frame.size.width-20,25)];
            titlelabel.text = stTitle;
            titlelabel.font = [UIFont systemFontOfSize:17];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titlelabel];
            
        }
        
        
        //输入框
        for(int i=0;i<[placeHoldsArray count];i++)
        {
            if(nil==textFieldArray)
            {
                textFieldArray=[[NSMutableArray alloc] initWithCapacity:2];
            }
            UITextField *inputText = [[UITextField alloc] initWithFrame:CGRectMake(17,65+38*i,235,38)];
            inputText.placeholder = [placeHoldsArray objectAtIndex:i];
            inputText.textAlignment = NSTextAlignmentCenter;
            inputText.borderStyle = UITextBorderStyleNone;
            inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
            inputText.delegate = self;
            inputText.tag = 100+i;
            inputText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            inputText.borderStyle = UITextBorderStyleNone;
            inputText.returnKeyType = UIReturnKeyDone;
            inputText.font = [UIFont systemFontOfSize:17];
            inputText.textColor = HEXCOLOR(0x8f8f8f);
            inputText.layer.backgroundColor = [UIColor whiteColor].CGColor;
            inputText.layer.borderWidth = 0.3f;
            inputText.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
            [backView addSubview:inputText];
            
            NSRange range = [inputText.placeholder rangeOfString:@"密码"];
            if(range.location != NSNotFound)
            {
                inputText.secureTextEntry = YES;
            }
            else
            {
                inputText.secureTextEntry = NO;
            }
            [textFieldArray addObject:inputText];
            if(i==0)
            {
                [inputText becomeFirstResponder];
            }
        }
        //按钮
        if(1 == [btnArray count])
        {
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-40,backView.frame.size.width+1.0f,40+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn1.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn1.layer.borderWidth = 0.3f;
            [backView addSubview:btn1];
        }
        else if(2 == [btnArray count])
        {
            
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-40,backView.frame.size.width/2+1.0f,40+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn1.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn1.layer.borderWidth = 0.3f;
            [backView addSubview:btn1];
            
            UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(backView.frame.size.width/2,backView.frame.size.height-40,backView.frame.size.width/2+1.0f,40+1.0f);
            btn2.tag = 101;
            [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn2 setTitle:[btnArray objectAtIndex:1] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn2.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn2.layer.borderWidth = 0.3f;
            [backView addSubview:btn2];
        }
        else if([btnArray count]>2)
        {
            UIImage * btnGray0 = [UIImage imageNamed:@"cancel"];
            for(int i=0;i<[btnArray count];i++)
            {
                UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10,backView.frame.size.height-45*([btnArray count] - i),backView.frame.size.width-20,35);
                [btn setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.tag = i+100;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:btnGray0 forState:UIControlStateNormal];
                [backView addSubview:btn];
            }
        }
    }
    return  self;
    
    
}

//5.针对全是button的提示框
- (id)initWithTitle:(NSString *)title
     andButtonArray:(NSArray *)buttonArray
        andDelegate:(id)delegate
         andAddInfo:(id)add_Info
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        addInfo = add_Info;
        
        //添加背景 == self
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.frame;
        self.center = window.center;
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];//[UIColor clearColor];
        [window addSubview:self];
        
        UIControl *popViewcontrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, window.frame.size.height)];
        popViewcontrol.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [popViewcontrol addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:popViewcontrol];
        
        //设置背景view
        CGFloat myHeight = 40;
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25,
                                                                 (self.frame.size.height-(myHeight*([buttonArray count]+1)))/2,
                                                                 270,
                                                                 myHeight*([buttonArray count]+1))];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = HEXCOLOR(0xe1e1e1);
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        
        //设置title
        if(title && ![title isEqualToString:@""])
        {
            titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,backView.frame.size.width,39.5)];
            titlelabel.text = title;
            titlelabel.font = [UIFont systemFontOfSize:15];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titlelabel];
            //设置label下的线条
            UIView *titleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, backView.frame.size.width, 0.5)];
            [titleLineView setBackgroundColor:HJCOLORLINE];
            [backView addSubview:titleLineView];
        }
        
        //设置button
        for (int i = 0; i< [buttonArray count]; i++) {
            UIButton *button = [ZHCustomControl _customUIButtonWithTitle:[buttonArray objectAtIndex:i]
                                                                 andFont:14.0f
                                                           andTitleColor:HJCOLORBLUE
                                                               andTarget:self
                                                                  andSEL:@selector(alertButtonClicked:)
                                                         andControlEvent:UIControlEventTouchUpInside
                                                              andBGImage:nil
                                                                andFrame:CGRectMake(0, myHeight, backView.frame.size.width, 40-0.5)];
            [button setTag:1000+i];
            [backView addSubview:button];
            if (i < [buttonArray count]-1) {
                UIView *buttonLineView = [[UIView alloc] initWithFrame:CGRectMake(0, myHeight + 40 -0.5, backView.frame.size.width, 0.5)];
                [buttonLineView setBackgroundColor:HJCOLORLINE];
                [backView addSubview:buttonLineView];
            }
            myHeight += 40;
        }
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andMsg:(NSString *)msg andButton:(NSString *)buttontitle andDelegate:(id)delegate 
{
    self = [super init];
    if(self)
    {
        
        _delegate = delegate;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.frame;
        self.center = window.center;
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
        [window addSubview:self];
        
        //判断动态高度
        CGSize constraint = CGSizeMake(180,self.frame.size.height - 100-45);
        CGSize msgSize = [msg sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        
        float msgHeight = msgSize.height ;//内容高度
        BOOL  bScrolEnable = NO;
        
        float backViewHeight = msgHeight + 45+10+17;//backView高度，也就是弹出框所显示的包括按钮范围之内的大小
        
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (self.frame.size.height-backViewHeight)/2, 270, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = HEXCOLOR(0xffffff);
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        textView = [[UITextView alloc] initWithFrame:CGRectMake(15,10,backView.frame.size.width-30,msgHeight)];
        textView.textAlignment = NSTextAlignmentCenter;
        
        textView.backgroundColor = [UIColor clearColor];
        textView.scrollEnabled = bScrolEnable;
        textView.dataDetectorTypes = UIDataDetectorTypeNone;
        textView.font = [UIFont systemFontOfSize:15];
        textView.delegate=self;
        textView.text=msg;
        [backView addSubview:textView];
        
        rightButton=[[UIButton alloc] initWithFrame:CGRectMake(25,textView.frame.size.height+textView.frame.origin.y,17,17)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"g3_txt_password"] forState:UIControlStateNormal];
        [backView addSubview:rightButton];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.tag=0;
        
        UILabel *labelShow=[[UILabel alloc] initWithFrame:CGRectMake(50,rightButton.frame.origin.y,100,17)];
        labelShow.font=[UIFont systemFontOfSize:14];
        labelShow.text=@"不再提示";
        labelShow.textColor=[UIColor blackColor];
        labelShow.backgroundColor=[UIColor clearColor];
        [backView addSubview:labelShow];
        
        if (![buttontitle isEqualToString:@""]) {
            float nBtnHeigtht = 40;//btn默认高度
            UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(0,backView.frame.size.height-40,backView.frame.size.width,nBtnHeigtht+1.0f);
            btn2.tag = 101;
            [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn2 setTitle:buttontitle forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitleColor:HJCOLORBLUE forState:UIControlStateNormal];
            btn2.layer.borderColor = HEXCOLOR(0xb2b2b2).CGColor;
            btn2.layer.borderWidth = 0.5f;
            [backView addSubview:btn2];
        }
        else
        {
            
        }
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andMsg:(NSString *)msg andDelegate:(id)delegate
{
    self = [super init];
    if(self)
    {

        
    }
    return self;
}

#pragma mark -
-(void)rightButtonPressed:(UIButton *)button
{
    if(rightButton.tag==0)
    {
        rightButton.tag=1;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"g3_pswdShow"] forState:UIControlStateNormal];
    }
    else
    {
        rightButton.tag=0;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"g3_txt_password"] forState:UIControlStateNormal];
    }
}

- (void)alertButtonClicked:(UIButton *)btn
{
    [self hideAlertAction];
    NSInteger buttonClicked = btn.tag-1000;
    if([_delegate respondsToSelector:@selector(HJalertView:clickedButtonAtIndex:AddInformation:)]){
        [_delegate HJalertView:self clickedButtonAtIndex:buttonClicked AddInformation:addInfo];
    }
}

- (void)removeView
{
    if ([_delegate respondsToSelector:@selector(removeAlertView)]) {
        [_delegate removeAlertView];
    }
}

//根据索引获取按钮标题
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
   if([btnArray count] > buttonIndex)
   {
       return (NSString *)[btnArray objectAtIndex:buttonIndex];
   }
    return @"";
}

-(void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self hideAlertAction];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if([_delegate respondsToSelector:@selector(HJalertView:clickedButtonAtIndex:AddInformation:)])
             {
                 [_delegate HJalertView:self clickedButtonAtIndex:btn.tag-100 AddInformation:addInfo];
             }
             
         });
         
     });

}
-(void)show
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [backView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAlertAction {
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    hideAnimation.delegate = self;
    [backView.layer addAnimation:hideAnimation forKey:nil];
    
    [backView removeFromSuperview];
    backView = nil;
    [self removeFromSuperview];
    
    
}

-(id)initWithTitle:(NSString *)stTitle
        andMessage:(NSString *)stMsg
       andDelegate:(id /*<HJAlertViewDelegate>*/)delegate
        andAddInfo:(id)add_info
    andButtonColor:(UIColor *)buttonColor
     andParentView:(UIViewController *)viewControl
   andButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        addInfo = add_info;
        //按钮个数
        btnArray = [[NSMutableArray alloc]  initWithCapacity:2];
        va_list arglist;
        va_start(arglist, otherButtonTitles);
        id arg;
        if(otherButtonTitles)
        {
            [btnArray addObject:otherButtonTitles];
            while((arg = va_arg(arglist, id))) {
                if (arg)
                {
                    [btnArray addObject:arg];
                }
            }
        }
        else
        {
            //没有 默认为确定
            [btnArray addObject:@"确 定"];
        }
        va_end(arglist);
        
        //添加背景 == self
        self.frame = viewControl.view.bounds;
        self.center = viewControl.view.center;
        self.backgroundColor = [UIColor clearColor];//;
        [viewControl.view addSubview:self];
        UIControl *popViewcontrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, viewControl.view.frame.size.width, viewControl.view.frame.size.height)];
        popViewcontrol.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [popViewcontrol addTarget:self action:@selector(hideAlertAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:popViewcontrol];
        
        //判断动态高度
        CGSize constraint = CGSizeMake(180*WIDTHPROPORTION, self.frame.size.height - (100+45)*WIDTHPROPORTION);
        if([btnArray count]>2)
        {
            constraint = CGSizeMake(180*WIDTHPROPORTION, self.frame.size.height - 100*WIDTHPROPORTION-[btnArray count]*45*WIDTHPROPORTION);
        }
        CGSize msgSize = [stMsg sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        
        float msgHeight = msgSize.height + 15*WIDTHPROPORTION;//内容高度
        float backViewHeight = 0;//backView高度
        float titleHeight = 35*WIDTHPROPORTION;//标题高度
        if(stTitle == nil || [stTitle isEqualToString:@""])
        {
            titleHeight = 0;
        }
        BOOL  bScrolEnable = NO;
        
        if([btnArray count] <=2)
        {
            //小于两个按钮  横排放
            if(msgHeight <= 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.bounds.size.height - (150+45)*WIDTHPROPORTION)
            {
                msgHeight = self.bounds.size.height - 145*WIDTHPROPORTION;
                bScrolEnable = YES;
            }
            else
            {
                if(msgHeight >200*WIDTHPROPORTION)
                {
                    msgHeight -=  35*WIDTHPROPORTION;
                    bScrolEnable = YES;
                }
            }
            backViewHeight = msgHeight + 45*WIDTHPROPORTION+ titleHeight+10*WIDTHPROPORTION;
        }
        else
        {
            //大于两个按钮 竖排存放
            if(msgHeight < 80)
            {
                msgHeight = 80;
            }
            else if(msgHeight >= self.frame.size.height - 150*WIDTHPROPORTION-[btnArray count]*45*WIDTHPROPORTION)
            {
                msgHeight = self.frame.size.height - 150*WIDTHPROPORTION -[btnArray count]*45*WIDTHPROPORTION;
                bScrolEnable = YES;
            }
            backViewHeight = msgHeight + titleHeight+10*WIDTHPROPORTION + 45*[btnArray count]*WIDTHPROPORTION;
        }
        
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(25*WIDTHPROPORTION, (self.frame.size.height-backViewHeight)/2, 270*WIDTHPROPORTION, backViewHeight)];
        backView.userInteractionEnabled = YES;
        backView.clipsToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        //        backView.layer.borderWidth = 0.5;
        backView.layer.cornerRadius = 5.0f;
        backView.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
        [self addSubview:backView];
        //标题
        if(stTitle && ![stTitle isEqualToString:@""])
        {
            titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,5*WIDTHPROPORTION,backView.frame.size.width-20*WIDTHPROPORTION,35*WIDTHPROPORTION)];
            titlelabel.text = stTitle;
            titlelabel.font = [UIFont systemFontOfSize:15];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titlelabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46*WIDTHPROPORTION, backView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:HJCOLORLINE];
            [backView addSubview:lineView];
        }
        //消息
        NSRange range = [stMsg rangeOfString:@"\n"];
        CGFloat contentHeight = (backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION - msgSize.height)/2 + 35*WIDTHPROPORTION;
        if(stMsg.length<18 && range.location == NSNotFound)
        {
            //如果一行 上下居中显示。则把textview的位置居中
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,contentHeight,backView.frame.size.width-20*WIDTHPROPORTION,backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        else
        {
            
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10*WIDTHPROPORTION,contentHeight,backView.frame.size.width-20*WIDTHPROPORTION,backView.frame.size.height - 40*WIDTHPROPORTION -35*WIDTHPROPORTION)];
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = bScrolEnable;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.text = stMsg;
            [backView addSubview:textView];
        }
        
        //按钮
        float nBtnHeigtht = 40*WIDTHPROPORTION;//btn默认高度
        if(textView.frame.origin.x+textView.frame.size.height >= backView.frame.size.height-40*WIDTHPROPORTION)
        {
            nBtnHeigtht = backView.frame.size.height - (textView.frame.origin.x+textView.frame.size.height) - 3;
        }
        if(1 == [btnArray count])
        {
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width+1.0f,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:buttonColor forState:UIControlStateNormal];
            //            btn1.titleLabel.textColor = buttonColor;
            btn1.layer.borderColor = HJCOLORLINE.CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
        }
        else if(2 == [btnArray count])
        {
            
            UIButton  *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(-1.0f,backView.frame.size.height-nBtnHeigtht,backView.frame.size.width/2+1.0f+0.5,nBtnHeigtht+1.0f);
            btn1.tag = 100;
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [btn1 setTitle:[btnArray objectAtIndex:0] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:buttonColor forState:UIControlStateNormal];
            btn1.layer.borderColor = HJCOLORLINE.CGColor;
            btn1.layer.borderWidth = 0.5f;
            [backView addSubview:btn1];
            
            UIButton  *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(backView.frame.size.width/2,backView.frame.size.height-40*WIDTHPROPORTION,backView.frame.size.width/2+1.0f,(40+1.0f)*WIDTHPROPORTION);
            btn2.tag = 101;
            [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [btn2 setTitle:[btnArray objectAtIndex:1] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitleColor:buttonColor forState:UIControlStateNormal];
            btn2.layer.borderColor = HJCOLORLINE.CGColor;
            btn2.layer.borderWidth = 0.5f;
            [backView addSubview:btn2];
        }
        else if([btnArray count]>2)
        {
            UIImage * btnGray0 = [UIImage imageNamed:@"cancel"];
            for(int i=0;i<[btnArray count];i++)
            {
                UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10*WIDTHPROPORTION,backView.frame.size.height-45*([btnArray count] - i)*WIDTHPROPORTION,backView.frame.size.width-20*WIDTHPROPORTION+0.5,35*WIDTHPROPORTION);
                [btn setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.tag = i+100;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:btnGray0 forState:UIControlStateNormal];
                [backView addSubview:btn];
            }
        }
    }
    return  self;
}



#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark -
#pragma mark UITextField Delegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if(textField.placeholder == nil || [textField.placeholder isEqualToString:@""])
//    {
//        //如果place_HoldsArray == nil  则默认一个输入框 ，标题titlelabel.text代替palceHolder的功能来表述输入框的作用
//        NSRange range = [titlelabel.text rangeOfString:@"资金密码"];
//        if(range.location != NSNotFound)
//        {
//            PswdKeyBoard  *boardview =[PswdKeyBoard getKeyboardView];
//            textField.inputView = boardview;
//            boardview.responder = textField;
//        }
//        else
//        {
//            NSRange range1 = [titlelabel.text rangeOfString:@"银行卡密码"];
//            if(range1.location != NSNotFound)
//            {
//                PswdKeyBoard  *boardview =[PswdKeyBoard getKeyboardView];
//                textField.inputView = boardview;
//                boardview.responder = textField;
//            }
//        }
//    }
//    else
//    {
//        NSRange range = [textField.placeholder rangeOfString:@"资金密码"];
//        if(range.location != NSNotFound)
//        {
//            PswdKeyBoard  *boardview =[PswdKeyBoard getKeyboardView];
//            textField.inputView = boardview;
//            boardview.responder = textField;
//        }
//        else
//        {
//           NSRange range1 = [textField.placeholder rangeOfString:@"银行卡密码"];
//           if(range1.location != NSNotFound)
//           {
//               PswdKeyBoard  *boardview =[PswdKeyBoard getKeyboardView];
//               textField.inputView = boardview;
//               boardview.responder = textField;
//           }
//        }
//    }
//    return  YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    25,
    backView.frame = CGRectMake(backView.frame.origin.x, (self.frame.size.height-backView.frame.size.height)/2 - 100, backView.frame.size.width, backView.frame.size.height);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    backView.frame = CGRectMake(backView.frame.origin.x, (self.frame.size.height-backView.frame.size.height)/2, backView.frame.size.width, backView.frame.size.height);
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
	return YES;
}





@end
