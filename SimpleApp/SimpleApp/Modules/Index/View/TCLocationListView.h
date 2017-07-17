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

@interface TCLocationListView : UIView

- (void)requestLocationList:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;

@end
