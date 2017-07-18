//
//  GDNavigationViewController.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>


@interface GDNavigationViewController : UIViewController

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@end
