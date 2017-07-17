//
//  SearchNetRespondBean.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"
@class Search;

@interface SearchNetRespondBean : BaseModel


@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSArray <Search *> *Data;

@end
