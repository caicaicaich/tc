//
//  UIScrollView+Refresh.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)

- (void)addRefreshHeaderCallback:(void (^ __nullable)(void))callback;
- (void)addRefreshFooterCallback:(void (^ __nullable)(void))callback;

@end
