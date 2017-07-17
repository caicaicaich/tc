//
//  IGetServerResponseDataValidityData.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 获取服务器返回的数据中的有效数据部分(一般数据使用json协议传递, 那么 data 部分的数据就是有效数据部分)
@protocol IGetServerResponseDataValidityData <NSObject>
- (id)serverResponseDataValidityData:(in NSDictionary *)serverResponseData;
@end
