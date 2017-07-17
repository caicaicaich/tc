//
//  SearchViewModel.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@class Search;

@interface SearchViewModel : NSObject

@property (nonatomic, readonly, strong) RACCommand *requestSearchCommand;

@property (nonatomic, readonly, strong) RACCommand *cancelRequestSearchCommand;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *latitude;

@property (copy, readonly, nonatomic) NSArray <Search *> *searchArray;

/**
 *  是否是最后一条数据
 */
@property (assign, readonly, nonatomic) BOOL isLastPage;

@end
