//
//  ListNetRespondBean.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ListNetRespondBean.h"

@implementation ListNetRespondBean

// 拷贝构造
- (instancetype)initWithCopyOther:(ListNetRespondBean *)other {
  if (self = [super init]) {
    
    _isLastPage = other.isLastPage;
    [(NSMutableArray *)self.list addObjectsFromArray:other.list];
  }
  
  return self;
}

- (NSArray *)list {
  if (_list == nil) {
    _list = [[NSMutableArray alloc] init];
  }
  return _list;
}

- (void)clear {
  [(NSMutableArray *)self.list removeAllObjects];
  
  self.isLastPage = NO;
}

@end
