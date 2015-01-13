//
//  ComitModel.h
//  yaokaola
//
//  Created by pro on 14/12/3.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComitModel : NSObject
@property(nonatomic,copy)NSString *chapterdetailedId;
@property(nonatomic,copy)NSString *correctNum; //正确个数
@property(nonatomic,copy)NSString *tiems;
@property(nonatomic,copy)NSString *avgnum;     //正确率
@property(nonatomic,copy)NSString *questionnum;
@property(nonatomic,copy)NSString *quetsioncount;//总题个数
@property(nonatomic,copy)NSString *peoplenum; // 击败人数

@end
