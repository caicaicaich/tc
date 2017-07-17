//
//  UrlConstantForThisProject.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 主URL
extern NSString *const UrlConstant_MainUrl;
/// 主Path
extern NSString *const UrlConstant_MainPtah;

// V0.1
// 1.第三方授权登录接口
extern NSString *const UrlConstant_SpecialPath_oauthlogin;
// 2.登出接口
extern NSString *const UrlConstant_SpecialPath_logout;
// 3.推荐日记接口
extern NSString *const UrlConstant_SpecialPath_recommend;
// 4.请求日记详情接口
extern NSString *const UrlConstant_SpecialPath_detailbyid;
// 5.请求某天日记列表接口
extern NSString *const UrlConstant_SpecialPath_diary_findbydate;
// 6.获取日历列表的接口
extern NSString *const UrlConstant_SpecialPath_calendar;
// 7.请求用户的有效数据接口(最近20条)
extern NSString *const UrlConstant_SpecialPath_findbylately;
// 8. 发表日记接口
extern NSString *const UrlConstant_SpecialPath_diary;
// 9. 获取指定日期的事件
extern NSString *const UrlConstant_SpecialPath_event_findbydate;
// 10. 上传图片
extern NSString *const UrlConstant_SpecialPath_uploadimage;

// 登录接口
extern NSString *const UrlConstant_SpecialPath_login;
// 登录接口
extern NSString *const UrlConstant_SpecialPath_search;

// 心跳检测接口
extern NSString *const UrlConstant_SpecialPath_heartbeat;
// 上传音频
extern NSString *const UrlConstant_SpecialPath_uploadaudio;
// 发表新帖子接口
extern NSString *const UrlConstant_submit_posts;

@interface UrlConstantForThisProject : NSObject

@end
