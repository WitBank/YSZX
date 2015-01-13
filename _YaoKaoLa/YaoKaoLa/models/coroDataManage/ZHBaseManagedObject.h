//
//  ZHBaseManagedObject.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ZHBaseManagedObject : NSManagedObject

//避免返回null
NSString * return_String(NSString *str);

@end
