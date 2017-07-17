//
//  Search.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "Search.h"


@implementation Search

@synthesize dataId = _id;

- (long long)createTime {
    return _createTime / 1000;
}

- (long long)updateTime {
    return _updateTime / 1000;
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

@end
