//
//  ICustomHttpHeaders.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 自定义 http header
@protocol ICustomHttpHeaders <NSObject>
- (NSDictionary *)customHttpHeaders;
@end
