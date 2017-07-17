//
//  SearchNetRequestBean.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchNetRequestBean : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *token;

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy, readonly) NSString *longitude;

@property (nonatomic, copy, readonly) NSString *latitude;

#pragma mark -
#pragma mark - 构造方法
- (id)initWithName:(NSString *)name pageNo:(NSInteger)pageNO pageSize:(NSInteger)pageSize longitude:(NSString *)longitude latitude:(NSString *)latitude NS_DESIGNATED_INITIALIZER;

- (id)init DEPRECATED_ATTRIBUTE;
@end


NS_ASSUME_NONNULL_END
