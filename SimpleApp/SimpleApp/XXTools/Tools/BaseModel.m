//
//  BaseModel.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import "PRPDebug.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue {
  if((self = [super init])) {
    
    [self setValuesForKeysWithDictionary:dictionaryValue];
  }
  return self;
}

- (BOOL)allowsKeyedCoding {
  return YES;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
  Class cls = [self class];
  while (cls != [NSObject class]) {
    /*判断是自身类还是父类*/
    BOOL bIsSelfClass = (cls == [self class]);
    unsigned int iVarCount = 0;
    unsigned int propVarCount = 0;
    unsigned int sharedVarCount = 0;
    Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
    objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
    sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
    
    for (int i = 0; i < sharedVarCount; i++) {
      const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
      NSString *key = [NSString stringWithUTF8String:varName];
      id varValue = [decoder decodeObjectForKey:key];
      if (varValue) {
        [self setValue:varValue forKey:key];
      }
    }
    free(ivarList);
    free(propList);
    cls = class_getSuperclass(cls);
  }
  return self;
  
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  Class cls = [self class];
  while (cls != [NSObject class]) {
    /*判断是自身类还是父类*/
    BOOL bIsSelfClass = (cls == [self class]);
    unsigned int iVarCount = 0;
    unsigned int propVarCount = 0;
    unsigned int sharedVarCount = 0;
    Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
    objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
    sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
    
    for (int i = 0; i < sharedVarCount; i++) {
      const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
      NSString *key = [NSString stringWithUTF8String:varName];
      /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
      id varValue = [self valueForKey:key];
      if (varValue) {
        [encoder encodeObject:varValue forKey:key];
      }
    }
    free(ivarList);
    free(propList);
    cls = class_getSuperclass(cls);
  }
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  // subclass implementation should do a deep mutable copy
  // this class doesn't have any ivars so this is ok
  BaseModel *newModel = [[BaseModel allocWithZone:zone] init];
  return newModel;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
  id copy = [[[self class] allocWithZone:zone] init];
  Class cls = [self class];
  while (cls != [NSObject class]) {
    /*判断是自身类还是父类*/
    BOOL bIsSelfClass = (cls == [self class]);
    unsigned int iVarCount = 0;
    unsigned int propVarCount = 0;
    unsigned int sharedVarCount = 0;
    Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
    objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
    sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
    
    for (int i = 0; i < sharedVarCount; i++) {
      const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
      NSString *key = [NSString stringWithUTF8String:varName];
      /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
      id varValue = [self valueForKey:key];
      if (varValue) {
        [copy setValue:varValue forKey:key];
      }
    }
    free(ivarList);
    free(propList);
    cls = class_getSuperclass(cls);
  }
  return copy;
  
}

#pragma mark - NSKeyValueCoding
- (id)valueForUndefinedKey:(NSString *)key {
  // subclass implementation should provide correct key value mappings for custom keys
  PRPLog(@"Undefined Key: %@", key);
  return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  // subclass implementation should set the correct key value mappings for custom keys
  PRPLog(@"Undefined Key: %@", key);
}

#pragma mark - NSObject
- (NSString *)description {
  return descriptionForDebug(self);
}

@end
