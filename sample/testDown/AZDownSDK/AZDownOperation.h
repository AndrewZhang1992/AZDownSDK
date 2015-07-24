//
//  AZDownOperarion.h
//  down
//
//  Created by Andrew on 15/5/15.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZDownSDK.h"
#import "MKNetworkOperation.h"

/**
 *   下载操作,继承自 MKNetworkOperation
 *   结合MKNetworkOperation，内部已经自动实现断点续传
 */
@interface AZDownOperation : MKNetworkOperation
@property (nonatomic,copy)NSString *cacheFilePath;
@property (nonatomic,copy)NSString *saveFilePath;

#pragma mark -- 对外接口

/**
 *   返回一个下载操作
 *
 *   @param DownURL : 下载资源的url
 *   @param Params : 请求参数
 *   @param cacheFilePath : 下载中，缓存文件的路径 (!!! 是文件的路径，而不是文件夹的路径 eg. : /Data/Application/temp/abc.dumg)
 *   @param saveFilePath : 下载完成后，保存文件的路径 (!!! 是文件的路径，而不是文件夹的路径 eg. : /Data/Application/Documents/abc.dumg)
 *
 */
+(instancetype) operationWithDownURL:(NSString *)downURL andParams:(NSMutableDictionary *)paramDic andCacheFilePath:(NSString *)cacheFilePath andSaveFilePath:(NSString *)saveFilePath;



@end
