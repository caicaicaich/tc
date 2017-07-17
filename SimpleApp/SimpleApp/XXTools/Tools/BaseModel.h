//
//  BaseModel.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//
//  所有Model的父类, 主要是封装了KVC, 通过入参 : 数据字典 来直接反射成业务Bean
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding, NSCopying, NSMutableCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue;

@end
