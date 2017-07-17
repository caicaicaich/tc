//
//  NetRequestHandleStub.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetRequestHandle.h"
#import "INetRequestIsCancelled.h"

@interface NetRequestHandleStub : NSObject <INetRequestHandle, INetRequestIsCancelled>
- (instancetype)init;
- (void)setBusy:(BOOL)isBusy;
@end
