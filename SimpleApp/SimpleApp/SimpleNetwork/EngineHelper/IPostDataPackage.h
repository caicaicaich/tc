//
//  IPostDataPackage.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 打包post数据(可在这里进行数据的加密工作)
@protocol IPostDataPackage <NSObject>
- (NSData *)packagePostDataWithParamsDictionary:(in NSDictionary *)paramsDictionary;
@end
