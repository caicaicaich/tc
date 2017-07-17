//
//  INetRequestPublicParams.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ErrorBean;


// 访问网络接口时, 需要传递到服务器的公共参数
@protocol INetRequestPublicParams <NSObject>
- (NSDictionary *)publicParamsWithErrorOUT:(out ErrorBean **)errorOUT;
@end
