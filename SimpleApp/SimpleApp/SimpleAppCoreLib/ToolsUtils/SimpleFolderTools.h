//
//  SimpleFolderTools.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SimpleFolderTools : NSObject {
  
}

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long)fileSizeAtPath1:(NSString *) filePath;
// 方法1：使用unix c函数来实现获取文件大小
+ (long long)fileSizeAtPath2:(NSString *) filePath;


// 方法1：循环调用fileSizeAtPath1
+ (long long)folderSizeAtPath1:(NSString *) folderPath;
// 方法2：循环调用fileSizeAtPath2
+ (long long)folderSizeAtPath2:(NSString *) folderPath;
// 方法3：完全使用unix c函数(在folderSizeAtPath2基础之上，去除文件路径相关的字符串拼接工作)
+ (long long)folderSizeAtPath3:(NSString *) folderPath;

/**
 * 删除一个文件夹下面所有的文件
 *
 * @param folderPath         文件夹路径
 * @param isDeleteRootFolder 是否删除根文件夹
 */
+ (void)deleteFolderAtPath:(NSString *)folderPath isDeleteRootFolder:(BOOL)isDeleteRootFolder;

@end
