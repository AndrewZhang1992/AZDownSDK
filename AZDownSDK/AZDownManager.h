//
//  AZDownManager.h
//  down
//
//  Created by Andrew on 15/5/15.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
#import "AZDownOperation.h"


typedef enum
{
    STAR_ERROR,//下载开始的错误
    COMMPLATE_ERROR //下载完成之后的错误
}AZDOWNERROR;

@interface AZError : NSObject

@property (nonatomic,assign)AZDOWNERROR stateCode;

@property (nonatomic,copy)NSString *errorStr;

@end


// define blocks

typedef void (^AZErrorBlock)(AZError *error);
typedef void (^AZDownProcess)(double process,unsigned long long totalSize);

/*!
 *   下载管理类
 */
@interface AZDownManager : MKNetworkEngine

/*!
 *   返回单例下载管理实例
 *
 *  默认并发线程最大数目为2。外界可以通过 setMaxQueneNumber：重新设置
 *
 */
+(instancetype)shareDownManager;

/*!
 *  添加下载任务，一经添加，则会立即下载
 *
 *  @param downURL : 下载资源的url（NSString）
 *  @param saveFilePath : 下载资源文件后保存的路径（NSString） !!! 是文件路径，而不是文件夹路径
 *
 */
- (void)addDownloadTaskToQueueandDownURL:(NSString *)downURL toSaveFilePath:(NSString *)saveFilePath onDownloadProgress:(AZDownProcess) downProcess onCompletion:(MKNKResponseBlock) responseBlock onError:(MKNKResponseErrorBlock)errorBlock;

/**
 *   取消一个下载
 */
-(void)cancelDownloadTaskByDownURL:(NSString *)downURL;

/**
 *   取消所有下载任务
 */
-(void)cancelAllDownloadTask;

@end
