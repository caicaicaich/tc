//
//  SpliceFullUrlByDomainBeanSpecialPath.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SpliceFullUrlByDomainBeanSpecialPath.h"
#import "UrlConstantForThisProject.h"

@implementation SpliceFullUrlByDomainBeanSpecialPath

- (NSString *)fullUrlByDomainBeanSpecialPath:(NSString *)specialPath {
  return [NSString stringWithFormat:@"%@%@%@", UrlConstant_MainUrl, @"/", specialPath];
}

@end
