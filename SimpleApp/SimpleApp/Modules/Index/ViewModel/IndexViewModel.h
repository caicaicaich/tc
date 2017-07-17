//
//  IndexViewModel.h
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchNetRequestBean.h"
#import "SearchNetRespondBean.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Search.h"

@interface IndexViewModel : NSObject

@property (nonatomic, readonly, strong) RACCommand *requestLocationListCommand;

@property (nonatomic, readonly, strong) RACCommand *cancelRequestLocationListCommand;

@property (nonatomic, readonly, strong) NSMutableArray<Search*> *locationList;

@end
