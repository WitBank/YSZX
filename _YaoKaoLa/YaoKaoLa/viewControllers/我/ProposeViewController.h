//
//  ProposeViewController.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
/*意见反馈接口
反馈内容 邮箱（可空） qq（可空）  手机 （可空）  标题(不为空) 内容(不为空)

http://ssyw.51yaoshi.com
 /ssyw/feedback.jspx?
 ctgId=3&
 email=shenzl@qq.com&
 phone=18658160756&
 qq=645566259&
 title=1231&
 content=afsadfafasfasdfasfa

*/
#import "BaseViewController.h"

@interface ProposeViewController : BaseViewController<UITextViewDelegate>
{
    UITextView *_propseText;
    UILabel *label;
    NSString *title;
    NSString *content;
    UIButton *button;
}
@end
