//
//  NSDictionary+Contain.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Contain)

- (BOOL)containsKey:(id)key;
- (BOOL)containsValue:(id)value;
@end
