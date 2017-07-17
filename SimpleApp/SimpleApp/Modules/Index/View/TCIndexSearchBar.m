//
//  TCIndexSearchBar.m
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "TCIndexSearchBar.h"

@interface TCIndexSearchBar ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;

@end

@implementation TCIndexSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.icon = [[UIImageView alloc] init];
    self.icon.image = [UIImage imageNamed:@"shouye_shousuo"];
    self.icon.frame = CGRectMake(15, 15, 20, 20);
    [self addSubview:self.icon];
    
    self.title = [UILabel new];
    self.title.text = @"请输入地点";
    self.title.font = [UIFont systemFontOfSize:18];
    self.title.textColor = [UIColor lightGrayColor];
    self.title.frame = CGRectMake(50, 0, 200, 50);
    [self addSubview:self.title];
    
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

@end
