//
//  SearchNetRespondBean.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchNetRespondBean.h"
#import "Search.h"


@implementation SearchNetRespondBean

-(NSArray<Search *> *) Data {
  if (_Data == nil) {
    _Data =  [NSMutableArray array];
  }
  return _Data;
}

-(void)setValue:(id)value forKey:(NSString *)key {
    //TODO:
  if ([key isEqualToString:@"data"]) {
    for (id item in value) {
      Search *search = nil;
      if ([item isKindOfClass:[Search class]]) { //目前使用运行时的手法来序列化和反序列化对象, 所以这里要进行额外的KVC映射判断, 这里是反序列化
        search = item;
      } else if ([item isKindOfClass:[NSDictionary class]]) {
        search = [[Search alloc] initWithDictionary:item];
      }
      [(NSMutableArray<Search *> *)self.Data addObject:search];
      
    }
  } else {
    [super setValue:value forKey:key];
  }
    
}



@end
