//
//  INetResponseRawEntityDataUnpack.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 将网络返回的原生数据, 解压成可识别的UTF8字符串(可在这里进行数据的解密工作)
@protocol INetResponseRawEntityDataUnpack <NSObject>
- (NSString *)unpackNetResponseRawEntityDataToUTF8String:(in NSData *)rawData;
@end
