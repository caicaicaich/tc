//
//  INetResponseDataToNSDictionary.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 将已经解压的网络响应数据(UTF8String格式)转成 NSDictionary 数据
@protocol INetResponseDataToNSDictionary <NSObject>
- (NSDictionary *)netResponseDataToNSDictionary:(in NSString *)serverResponseDataOfUTF8String;
@end
