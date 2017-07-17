//
//  Search.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"

@interface Search : BaseModel

@property (nonatomic, assign) NSInteger dataId;

@property (nonatomic, assign) NSInteger createId;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) NSInteger updateId;

@property (nonatomic, assign) long long updateTime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) double latitude;

@property (nonatomic, copy) NSString *distance;

@end
