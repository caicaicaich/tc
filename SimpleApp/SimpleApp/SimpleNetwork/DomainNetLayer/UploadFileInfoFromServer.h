//
//  UploadFileInfoFromServer.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileInfoFromServer : NSObject

@property (nonatomic, readonly) NSString *fileId;
@property (nonatomic, readonly) NSString *fileUrl;

#pragma mark -
#pragma mark - 构造方法
- (nullable instancetype)init DEPRECATED_ATTRIBUTE;

- (instancetype)initWithFileId:(NSString *)fileId fileUrl:(NSString *)fileUrl ;
@end

NS_ASSUME_NONNULL_END

