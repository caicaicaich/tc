//
//  ErrorBean.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ErrorBean.h"
#import "ErrorCodeEnum.h"
#import "NSString+isEmpty.h"

@implementation ErrorBean

// 外部定义的错误码对应的错误信息字典
static NSDictionary *nErrorCodesDictionary = nil;

#define kHttpRequestErrorDomain @"HTTP_ERROR"
#define kCustomErrorDomain      @"CUSTOM_ERROR"

+ (void)initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [ErrorBean class]) {
    NSString *fileName = [NSString stringWithFormat:@"Errors_%@", [[NSLocale currentLocale] localeIdentifier]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    if(filePath != nil) {
      nErrorCodesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    } else {
      // fall back to english for unsupported languages
      NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Errors_zh_CN" ofType:@"plist"];
      nErrorCodesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
  }
}

+ (void)dealloc {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [ErrorBean class]) {
    [super dealloc];
  }
}

- (id)init {
  if ((self = [super init])) {
    _errorMessage = @"NONE";
    _errorCode = ErrorCodeEnum_NONE;
    return self;
  }
  
  return self;
}


/**
 * 重新初始化
 *
 * @param srcObject
 */
- (void)reinitialize:(ErrorBean *)srcObject {
  if (srcObject != nil) {
    _errorCode = srcObject.errorCode;
    _errorMessage = srcObject.errorMessage;
  } else {
    _errorMessage = @"NONE";
    _errorCode = ErrorCodeEnum_NONE;
  }
}

+ (id)errorBeanWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage {
  ErrorBean *netRequestErrorBean = [[ErrorBean alloc] init];
  netRequestErrorBean.errorCode = errorCode;
  netRequestErrorBean.errorMessage = errorMessage;
  return netRequestErrorBean;
}

+ (id)errorBeanWithNSError:(NSError *)error {
  return [ErrorBean errorBeanWithErrorCode:error.code errorMessage:error.localizedDescription];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_errorMessage forKey:@"errorMessage"];
  [encoder encodeInteger:_errorCode forKey:@"errorCode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if ((self = [super init])) {
    _errorMessage = [decoder decodeObjectForKey:@"errorMessage"];
    _errorCode = [decoder decodeIntegerForKey:@"errorCode"];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  ErrorBean *theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
  
  theCopy.errorMessage = _errorMessage;
  theCopy.errorCode = _errorCode;
  
  return theCopy;
}

#pragma mark -
#pragma mark super class implementations

-(NSInteger)code {
  if(_errorCode == 0) {
    return [super code];
  } else {
    return _errorCode;
  }
}
- (NSString *)domain {
  //
  if(_errorCode >= 100 && _errorCode <= 505) {
    return kHttpRequestErrorDomain;
  } else {
    return kCustomErrorDomain;
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Request failed with error %@[%ld]", _errorMessage, (unsigned long)_errorCode];
}

- (NSString *)localizedDescription {
  
  NSString *message = nil;
  if ([[self domain] isEqualToString:kCustomErrorDomain]) {
    message = [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)_errorCode]] objectForKey:@"Title"];
  }
  if ([NSString isEmpty:message]) {
    message = _errorMessage;
  }
  if ([NSString isEmpty:message]) {
    message = [super localizedDescription];
  }
  
  return message;
}

- (NSString *)localizedRecoverySuggestion {
  
  do {
    if(![[self domain] isEqualToString:kCustomErrorDomain]) {
      break;
    }
    NSString *message = [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)_errorCode]] objectForKey:@"Suggestion"];
    if ([NSString isEmpty:message]) {
      break;
    }
    return message;
  } while (NO);
  
  return [super localizedRecoverySuggestion];
}

- (NSString *)localizedOption {
  if([[self domain] isEqualToString:kCustomErrorDomain]) {
    return [[nErrorCodesDictionary objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)_errorCode]] objectForKey:@"Option-1"];
  } else {
    return nil;
  }
}

//===========================================================
// dealloc
//===========================================================
- (void)dealloc {
  _errorMessage = nil;
  _errorCode = -1;
}

@end
