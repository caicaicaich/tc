//
//  Simpletoast.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simpletoast : NSObject

/**
 *  显示一个toast
 *
 *  @param text     toast 中的文字信息
 *  @param duration 持续的时间
 */
+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
