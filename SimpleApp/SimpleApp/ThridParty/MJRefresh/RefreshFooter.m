//
//  RefreshFooter.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "RefreshFooter.h"

@interface RefreshFooter ()
{
  __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation RefreshFooter

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
  _activityIndicatorViewStyle = activityIndicatorViewStyle;
  
  self.loadingView = nil;
  [self setNeedsLayout];
}
#pragma mark - 重写父类的方法

- (void)prepare
{
  [super prepare];
  
  self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
  [super placeSubviews];
  
  CGFloat arrowCenterX = self.mj_w * 0.5;
  if (!self.stateLabel.hidden) {
    arrowCenterX -= self.labelLeftInset + self.stateLabel.mj_textWith * 0.5;
  }
  CGFloat arrowCenterY = self.mj_h * 0.5;
  CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
  
  if (self.arrowView.constraints.count == 0) {
    self.arrowView.mj_size = CGSizeMake(self.arrowView.image.size.width*0.75, self.arrowView.image.size.height*0.75);
    self.arrowView.center = arrowCenter;
  }
  
  if (self.loadingView.constraints.count == 0) {
    self.loadingView.center = arrowCenter;
  }
  
  self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state
{
  MJRefreshCheckState
  
  if (state == MJRefreshStateIdle) {
    if (oldState == MJRefreshStateRefreshing) {
      self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
      [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
        self.loadingView.alpha = 0.0;
      } completion:^(BOOL finished) {
        self.loadingView.alpha = 1.0;
        [self.loadingView stopAnimating];
        
        self.arrowView.hidden = NO;
      }];
    } else {
      self.arrowView.hidden = NO;
      [self.loadingView stopAnimating];
      [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
      }];
    }
  } else if (state == MJRefreshStatePulling) {
    self.arrowView.hidden = NO;
    [self.loadingView stopAnimating];
    [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
      self.arrowView.transform = CGAffineTransformIdentity;
    }];
  } else if (state == MJRefreshStateRefreshing) {
    self.arrowView.hidden = YES;
    [self.loadingView startAnimating];
  } else if (state == MJRefreshStateNoMoreData) {
    self.arrowView.hidden = YES;
    [self.loadingView stopAnimating];
  }
}

#pragma mark - getter

- (UIImageView *)arrowView
{
  if (!_arrowView) {
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_arrow"] ];
    arrowView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_arrowView = arrowView];
  }
  return _arrowView;
}

- (UIActivityIndicatorView *)loadingView
{
  if (!_loadingView) {
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
    loadingView.hidesWhenStopped = YES;
    [self addSubview:_loadingView = loadingView];
  }
  return _loadingView;
}


@end
