//
//  SearchTableViewCell.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Search;

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) Search *searchModel;

@property (nonatomic, copy) NSString *searchValue;

@end
