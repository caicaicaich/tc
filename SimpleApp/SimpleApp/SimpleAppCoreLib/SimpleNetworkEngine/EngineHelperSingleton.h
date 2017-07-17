//
//  EngineHelperSingleton.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEngineHelper.h"

@interface EngineHelperSingleton : NSObject <IEngineHelper>

+ (instancetype)sharedInstance;

@end
