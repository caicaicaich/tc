//
//  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetRequestHandle.h"
#import "INetRequestIsCancelled.h"

@interface HttpRequestHandleOfAFNetworkingOfNSURLSessionTask : NSObject <INetRequestHandle, INetRequestIsCancelled>

- (id)init;

- (void) setSessionTask:(NSURLSessionTask *)sessionTask;

@end
