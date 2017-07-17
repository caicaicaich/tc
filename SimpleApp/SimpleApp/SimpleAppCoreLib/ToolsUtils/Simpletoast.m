//
//  Simpletoast.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "Simpletoast.h"
#import "MBProgressHUD.h"

@implementation Simpletoast

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration {
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Configure for text only and offset down
    toast.mode = MBProgressHUDModeText;
    // 支持折行
    //toast.detailsLabelText = text;
    //  toast.margin = 4.f;
    
    toast.detailsLabel.text = text;
    
    toast.removeFromSuperViewOnHide = YES;
    
    [toast hideAnimated:YES afterDelay:duration];
    
}

@end
