//
//  SimpleObjectSerialization.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SimpleObjectSerialization.h"
#import "PRPDebug.h"
#import "NSString+isEmpty.h"


void SimpleSerializeObject(id object, NSString *key, NSString *filePath) {
  
  do {
    
    if ([NSString isEmpty:key] || [NSString isEmpty:filePath]) {
      PRPLog(@"入参 key or filePath 为空.");
      break;
    }
    
    NSString *serializeObjectPath = [filePath stringByAppendingPathComponent:key];
    /* 先删除旧的序列化文件. */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:serializeObjectPath]) {
      NSError *error = nil;
      [fileManager removeItemAtPath:serializeObjectPath error:&error];
      if (error != nil) {
        PRPLog(@"删除旧的序列化文件失败! 错误描述:%@", error.localizedDescription);
        break;
      }
    }
    
    if (object == nil) {
      // 调用者想要清理本地的序列化缓存
      break;
    }
    
    if (![object conformsToProtocol:@protocol(NSCoding)]) {
      PRPLog(@"要进行序列化操作的对象, 必须实现 NSCoding 协议");
      break;
    }
    
    @try {
      [NSKeyedArchiver archiveRootObject:object toFile:serializeObjectPath];
    } @catch (NSException *exception) {
      PRPLog(@"序列化失败! 错误描述:%@", [exception description]);
      break;
    }
    
  } while (NO);
}



id SimpleDeserializeObject(NSString *key, NSString *filePath) {
  do {
    if ([NSString isEmpty:key] || [NSString isEmpty:filePath]) {
      PRPLog(@"入参 key or filePath 为空.");
      break;
    }
    
    NSString *serializeObjectPath = [filePath stringByAppendingPathComponent:key];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:serializeObjectPath]) {
      PRPLog(@"要反序列化的文件不存在, key = %@", key);
      break;
    }
    
    PRPLog(@"序列化文件 %@ 的 size = %lld", key, [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize]);
    
    @try {
      return [NSKeyedUnarchiver unarchiveObjectWithFile:serializeObjectPath];
    }
    @catch (NSException *exception) {
      PRPLog(@"反序列化失败! 错误描述:%@", [exception description]);
      break;
    }
    
  } while (NO);
  
  return nil;
}

@implementation SimpleObjectSerialization

@end
