//
//  TCLocationListView.h
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "IndexViewModel.h"

typedef void(^clickBlock)(double longitude,double latitude);

@interface TCLocationListView : UIView

- (void)requestLocationList:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;

@property (nonatomic, strong) IndexViewModel *viewModel;

@property (nonatomic, assign) NSInteger locationCount;

@property (nonatomic, copy) clickBlock click;

@end
