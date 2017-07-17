//
//  SearchNetRequestBean.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchNetRequestBean.h"
#import "PRPDebug.h"
#import "RNAssert.h"
#import "YYkit.h"
#import "NSString+isEmpty.h"

#define tokenSalt "17f20fAcf737f2Ef58b6462443a9aBa5"

@implementation SearchNetRequestBean

-(id)initWithName:(NSString *)name pageNo:(NSInteger)pageNO pageSize:(NSInteger)pageSize longitude:(NSString *)longitude latitude:(NSString *)latitude {
    if (self = [super init]) {
        _name = [name copy];
        _longitude = [longitude copy];
        _latitude = [latitude copy];
        _pageNO = pageNO;
        _pageSize = pageSize;
        NSString *tempToken = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",[NSString isEmpty:name]?@"null":name,[NSString isEmpty:longitude]?@"null":longitude,[NSString isEmpty:latitude]?@"null":latitude,[NSString stringWithFormat:@"%ld",pageNO],[NSString stringWithFormat:@"%ld",pageSize],@tokenSalt];
        _token = [tempToken sha1String];
    }
    return self;
}

@end
