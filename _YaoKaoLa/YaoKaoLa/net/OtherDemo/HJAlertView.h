//
//  HJAlertView.h
//  XCTG3
//
//  Created by lujianhui on 13-12-9.
//  Copyright (c) 2013年 lthj. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum HJAlertStyle
//{
//   HJAlertViewStyleDefault,//无输入框
//   HJAlertViewStylePwdTextInput,//一个输入框
//   HJAlertViewStyleLoginAndPwdInput//两个输入框
//}HJAlertViewStyle;


@protocol HJAlertViewDelegate;

@interface HJAlertView : UIView <UITextViewDelegate,UITextFieldDelegate>
{
    UIImageView  *backView;
    UITextView  *textView;//文本内容
    UILabel     *titlelabel;//标题
    NSMutableArray *btnArray;
    NSMutableArray  *placeHoldsArray;
    id          addInfo;//附加信息
    UIButton *rightButton;
    
//    __strong  UIControl *_popViewcontrol;
}
@property(nonatomic,weak) id<HJAlertViewDelegate> delegate;
@property(nonatomic,readonly)NSMutableArray *textFieldArray;
@property(nonatomic,readonly)UIButton *rightButton;

//返回当前按钮的标题
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

/**
 *  1.针对显示字符串的style
 *
 *  @param stTitle           标题 可为nil
 *  @param stMsg             内容  可为nil
 *  @param delegate          HJAlertViewDelegate对象 可为nil
 *  @param add_info          用于返回界面使用 无则传nil 本类只做保存返回 不做对其处理
 *  @param otherButtonTitles  按钮标题 （可为nil ，必须以 nil结尾）
 *
 *  @return HJAlertView
 */
-(id)initWithTitle:(NSString *)stTitle
           message:(NSString *)stMsg
          delegate:(id /*<HJAlertViewDelegate>*/)delegate
           addInfo:(id)add_info
      buttonTitles:(NSString *)otherButtonTitles, ...;


/**
 *  2.下面为title下方带横线  并且可以点击空白消失
 *
 *  @param stTitle           标题 可为nil
 *  @param stMsg             内容  可为nil
 *  @param delegate          HJAlertViewDelegate对象 可为nil
 *  @param add_info          用于返回界面使用 无则传nil 本类只做保存返回 不做对其处理
 *  @param buttonColor       按钮颜色
 *  @param otherButtonTitles 按钮标题 （可为nil ，必须以 nil结尾）
 *
 *  @return HJAlertView
 */
-(id)initWithTitle:(NSString *)stTitle
        andMessage:(NSString *)stMsg
       andDelegate:(id /*<HJAlertViewDelegate>*/)delegate
        andAddInfo:(id)add_info
    andButtonColor:(UIColor *)buttonColor
   andButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  3.针对带有button显示字符串的style
 *
 *  @param stMsg    内容  可为nil
 *  @param delegate HJAlertViewDelegate对象 可为nil
 *  @param add_info 用于返回界面使用 无则传nil 本类只做保存返回 不做对其处理
 *
 *  @return HJAlertView
 */
-(id)initButtonAlertmessage:(NSString *)stMsg
                   delegate:(id /*<HJAlertViewDelegate>*/)delegate
                    addInfo:(id)add_info;

/**
 *  4.针对全部是输入框的style
 *
 *  @param stTitle           标题 可为nil
 *  @param place_HoldsArray  textField.placeHolder 可为nil 内部会默认add @“”
 *  @param delegate          HJAlertViewDelegate对象 可为nil
 *  @param add_info          用于返回界面使用 无则传nil 本类只做保存返回 不做对其处理
 *  @param otherButtonTitles 按钮标题 （可为nil ，必须以 nil结尾）
 *
 *  @return HJAlertView
 */
-(id)initWithAlertInputStyleTitles:(NSString *)stTitle
                 placeholderTitles:(NSArray *)place_HoldsArray
                          delegate:(id /*<HJAlertViewDelegate>*/)delegate
                           addInfo:(id)add_info
                      buttonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  5.针对全是button的提示框
 *
 *  @param title       提示框的title
 *  @param buttonArray 提示框内各个button的title(NSString*)
 *  @param delegate    设置代理
 *  @param add_Info    用于返回界面使用 无则传nil 本类只做保存返回 不做对其处理
 *
 *  @return view
 */
- (id)initWithTitle:(NSString *)title
     andButtonArray:(NSArray *)buttonArray
        andDelegate:(id)delegate
         andAddInfo:(id)add_Info;


-(id)initWithFrame:(CGRect)frame andMsg:(NSString *)msg andButton:(NSString *)buttontitle andDelegate:(id)delegate ;

-(id)initWithFrame:(CGRect)frame andMsg:(NSString *)msg andDelegate:(id)delegate;

/**
 *  显示弹出框
 */
-(void)show;


//
-(id)initWithTitle:(NSString *)stTitle
        andMessage:(NSString *)stMsg
       andDelegate:(id /*<HJAlertViewDelegate>*/)delegate
        andAddInfo:(id)add_info
    andButtonColor:(UIColor *)buttonColor
     andParentView:(UIViewController *)viewControl
   andButtonTitles:(NSString *)otherButtonTitles, ...;

@end


@protocol HJAlertViewDelegate <NSObject>

@optional

/**
 *  弹出框按钮点击处理
 *
 *  @param alertView   弹出框
 *  @param buttonIndex 按钮的索引
 *  @param addInfo     附加信息 初始化弹出框时,传入
 */
- (void)HJalertView:(HJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex AddInformation:(id)addInfo;

/**
 *  移除弹出框
 */
- (void)removeAlertView;

@end