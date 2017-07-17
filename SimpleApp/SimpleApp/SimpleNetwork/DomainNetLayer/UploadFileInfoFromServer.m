//
//  UploadFileInfoFromServer.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "UploadFileInfoFromServer.h"
#import "RNAssert.h"
#import "PRPDebug.h"

@implementation UploadFileInfoFromServer

- (instancetype)initWithFileId:(NSString *)fileId fileUrl:(NSString *)fileUrl {
  
  if ((self = [super init])) {
    _fileId = fileId;
    _fileUrl = fileUrl;
  }
  
  return self;
}

#pragma mark -
#pragma mark - 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (nullable instancetype)init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}



- (NSString *)description {
  return descriptionForDebug(self);
}

@end
