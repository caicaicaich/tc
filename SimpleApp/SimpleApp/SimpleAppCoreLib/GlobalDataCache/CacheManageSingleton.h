//
//  CacheManageSingleton.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListRequestDirectionEnum.h"
#import "GlobalConstant.h"
/**
 * 缓存数据的标志位, 每一种标志位对应一种被缓存的数据
 */
typedef NS_ENUM(NSInteger, CacheTagEnum) {
  
  // 话题 banner list
  CacheTagEnum_TopicBannerList,
  // 福利 banner list
  CacheTagEnum_WelfareBannerList,
  // 明星 信息
  CacheTagEnum_StarInfo,
  // 频道详情
  CacheTagEnum_ChannelDetail,
  
};

@interface CacheManageSingleton : NSObject

#pragma mark -
#pragma mark - 单例
+ (instancetype) sharedInstance;

#pragma mark -
#pragma mark - 对外公开的方法

/**
 * 模块初始化方法, 使用模块前要先调用此方法(不能重复调用)
 */
- (void)initialize;

/**
 * 查询目标cacheTag对应的缓存
 * <p/>
 * 适用的CacheTag列表
 * <p/>
 * Homepage
 * TravelList
 * NewsPostsList
 * ImagesPostsList
 * StarPostsList
 * FansPostsList
 * MessageList
 * NoticeList
 * TopicBannerList
 * WelfareBannerList
 * HotTopicListAll
 * HotTopicListNormal
 * HotTopicListAudio
 * StarResourceCenterHomepage
 * StarResourceOfImage
 * StarResourceOfVideo
 * FootPrintList
 * NewPostsByTagList
 * WaveHomepagePostsList
 *
 * @param cacheTag
 * @param <CacheData> 缓存数据的类型
 * @return 如果没有缓存, 就返回 null
 */
- (id)cacheByTag:(CacheTagEnum)cacheTag;

/**
 * 查询目标cacheTag对应的缓存(用于查询一个itemId对应一个列表结构的情况, 比如话题帖子列表, 就是一个话题ID对应一种缓存)
 * <p>
 * 适用的CacheTag列表
 * <p>
 * TopicPostsList  : itemId = 话题ID
 * FamilyPostsList : itemId = 家族ID
 *
 * @param cacheTag
 * @param itemId
 * @param <CacheData>
 * @return
 */
- (id)cacheByTag:(CacheTagEnum)cacheTag itemId:(NSString *)itemId;

/**
 * 缓存数据的方法(由应用网络层调用)
 *
 * @param netRequestBean   网络请求业务Bean(作为key)
 * @param netRespondBean   网络响应业务Bean(作为value)
 * @param <NetRequestBean>
 * @param <NetRespondBean>
 */
- (void)cacheNetRespondBean:(id)netRespondBean withNetRequestBean:(id)netRequestBean;

/**
 * 是否有目标tag对应的缓存
 * <p/>
 * Homepage
 * TravelList
 * NewsPostsList
 * ImagesPostsList
 * StarPostsList
 * FansPostsList
 * MessageList
 * NoticeList
 * HotTopicListAll
 * HotTopicListNormal
 * HotTopicListAudio
 * UserFollowTopicList
 * TopicBannerList
 * WelfareBannerList
 * StarResourceCenterHomepage
 * StarResourceOfImage
 * StarResourceOfVideo
 * FootPrintList
 * WaveHomepagePostsList
 * WaveHomepage
 */
- (BOOL)isHasCacheByTag:(CacheTagEnum)cacheTag;

/**
 * 是否有目标tag对应的缓存
 * TopicPostsList  : itemId = 话题ID
 * FamilyPostsList : itemId = 家族ID
 */
- (BOOL)isHasCacheByTag:(CacheTagEnum)cacheTag itemId:(NSString *)itemId;

/**
 * 清理目标tag对应的缓存
 */
- (void)clearCacheByTag:(CacheTagEnum)cacheTag;

// 未提交的评论内容的缓存
- (NSString *)unSubmitCommentByPostsId:(NSString *)postsId;
- (void)setUnSubmitComment:(NSString *)unSubmitComment postsId:(NSString *)postsId;

/**
 * 获取本地缓存的 列表类型数据 的 "锚点ID", 注意列表类数据的 item 模型, 都必须从 ListItemBase 继承
 */
- (NSString *)listAnchorIdByTag:(CacheTagEnum)cacheTag listRequestDirection:(ListRequestDirectionEnum)direction;


- (NSString *)listAnchorIdByTag:(CacheTagEnum)cacheTag listRequestDirection:(ListRequestDirectionEnum)direction itemId:(NSString *)itemId;


// 当切换账号的时候, 需要清理掉相关缓存
- (void) changeAccountClear;

@end
