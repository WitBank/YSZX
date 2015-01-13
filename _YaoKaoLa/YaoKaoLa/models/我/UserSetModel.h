//
//  UserSetModel.h
//  yaokaola
//
//  Created by pro on 14/12/8.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSetModel : NSObject
@property (nonatomic,assign) int type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,assign)BOOL swOn;

@end
