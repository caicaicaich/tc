//
//  RefreshFooter.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>


NS_ASSUME_NONNULL_BEGIN

@interface RefreshFooter : MJRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowView;

@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

NS_ASSUME_NONNULL_END
