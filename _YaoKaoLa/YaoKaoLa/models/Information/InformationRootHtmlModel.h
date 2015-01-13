//
//  InformationRootHtmlModel.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/30.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "BaseObject.h"

@interface InformationRootHtmlModel : BaseObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descrip;
@property (nonatomic, copy) NSString *contentUrl;
@property (nonatomic, copy) NSString *contentHtmlUrl;
@property (nonatomic, copy) NSString *praise;
@property (nonatomic, copy) NSString *belittle;
@property (nonatomic, copy) NSString *titleImg;
@property (nonatomic, copy) NSString *pubDate;

@end
