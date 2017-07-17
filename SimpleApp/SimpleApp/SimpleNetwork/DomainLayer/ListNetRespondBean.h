//
//  ListNetRespondBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"

@interface ListNetRespondBean<T>: BaseModel

// 当前是否已经是最后一页数据
@property (nonatomic, assign) BOOL isLastPage;

// 最新的帖子总数
@property (nonatomic, assign) NSUInteger total;

// 数据列表
@property (nonatomic, copy) NSArray<T> *list;

- (void)clear;

// 拷贝构造
- (instancetype)initWithCopyOther:(ListNetRespondBean *)other;

@end
