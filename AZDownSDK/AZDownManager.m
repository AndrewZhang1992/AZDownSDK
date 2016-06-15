//
//  AZDownManager.m
//  down
//
//  Created by Andrew on 15/5/15.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "AZDownManager.h"
#import <CommonCrypto/CommonDigest.h>
/** 下载缓存文件所在目录 */
#define X_AZ_DOWN_TEMP_PATH  [NSString stringWithFormat:@"%@/tmp/AZDownTemp",NSHomeDirectory()]

@interface AZDownManager ()

@property (strong, nonatomic) NSMutableArray *downloadArray;

@end


@implementation AZDownManager
-(NSMutableArray *)downloadArray
{
    if (!_downloadArray) {
        _downloadArray=[NSMutableArray array];
    }
    return _downloadArray;
}

+(instancetype)shareDownManager
{
    static AZDownManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[AZDownManager new];
    });
    
    // 默认最大并发操作数 为2
    manager.maxQueneNumber=2;
    
    //创建下载缓存目录
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:X_AZ_DOWN_TEMP_PATH]) {
        BOOL flag=[[NSFileManager defaultManager] createDirectoryAtPath:X_AZ_DOWN_TEMP_PATH withIntermediateDirectories:YES attributes:nil error:nil];
        if (flag) {
            AZLog(@"创建AZDownTemp目录成功");
        }else{
            AZLog(@"创建AZDownTemp目录失败");
        }
    }
    
    return manager;
}

- (void)addDownloadTaskToQueueandDownURL:(NSString *)downURL toSaveFilePath:(NSString *)saveFilePath onDownloadProgress:(AZDownProcess) downProcess onCompletion:(MKNKResponseBlock) responseBlock onError:(MKNKResponseErrorBlock)errorBlock
{
    BOOL isHave=NO;
    NSArray *tempArray = [NSArray arrayWithArray:self.downloadArray];
    for (AZDownOperation *oper in tempArray) {
        if ([oper.url isEqualToString:downURL]) {
            isHave=YES;
            break;
        }
    }
    if (isHave) {
        AZLog(@"down task has exist!");
        return;
    }
    NSString *tempDownURL=[downURL copy];
 
    const char *cStr = [tempDownURL UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSString *md5Str=[NSString stringWithString:hash];
    
    NSString *cacheFilePath=[NSString stringWithFormat:@"%@/%@",X_AZ_DOWN_TEMP_PATH,md5Str];
    
    AZDownOperation * operation=[AZDownOperation operationWithDownURL:downURL andParams:nil andCacheFilePath:cacheFilePath andSaveFilePath:saveFilePath];
    
    if (!operation) {
        return;
    }
    
    // 放入到下载队列中
    [self enqueueOperation:operation];
    [self.downloadArray addObject:operation];
    
    __weak AZDownOperation *weekOperation=operation;
    [operation onDownloadProgressChanged:^(double progress) {
        downProcess(progress,weekOperation.totalSize);
    }];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        // 下载完成以后 先删除之前的文件 然后mv新的文件
        if ([fileManager fileExistsAtPath:saveFilePath]) {
            [fileManager removeItemAtPath:saveFilePath error:&error];
            if (error) {
                NSLog(@"remove %@ file failed!\nError:%@", saveFilePath, error);
                exit(-1);
            }
        }
        [fileManager moveItemAtPath:cacheFilePath toPath:saveFilePath error:&error];
        if (error) {
            NSLog(@"move %@ file to %@ file is failed!\nError:%@", cacheFilePath, saveFilePath, error);
            exit(-1);
        }

        [self.downloadArray removeObject:weekOperation];

        
        responseBlock(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self.downloadArray removeObject:weekOperation];
        errorBlock(completedOperation,error);
    }];
}

-(void)cancelDownloadTaskByDownURL:(NSString *)downURL
{
    AZDownOperation *cancenOper=nil;
    for (AZDownOperation *oper in self.downloadArray) {
        if ([oper.url isEqualToString:downURL]) {
            cancenOper=oper;
            break;
        }
    }
    if (cancenOper) {
        [cancenOper cancel];
    }
    [self.downloadArray removeObject:cancenOper];
}
-(void)cancelAllDownloadTask
{
    for (AZDownOperation *oper in self.downloadArray) {
        [oper cancel];
    }
    [self.downloadArray removeAllObjects];
}



@end
