//
//  UIScrollView+Refresh.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "RefreshFooter.h"
#import "RefreshHeader.h"

@implementation UIScrollView (Refresh)

- (void)addRefreshHeaderCallback:(void (^ __nullable)(void))callback
{
  RefreshHeader *header = [RefreshHeader headerWithRefreshingBlock:callback];
  header.stateLabel.hidden = YES;
  header.lastUpdatedTimeLabel.hidden = YES;
  self.mj_header = header;
}
- (void)addRefreshFooterCallback:(void (^ __nullable)(void))callback
{
  RefreshFooter *footer = [RefreshFooter footerWithRefreshingBlock:callback];
  footer.stateLabel.hidden = YES;
  self.mj_footer = footer;
}

@end
