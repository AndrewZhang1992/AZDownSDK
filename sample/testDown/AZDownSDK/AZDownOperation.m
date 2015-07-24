//
//  AZDownOperarion.m
//  down
//
//  Created by Andrew on 15/5/15.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "AZDownOperation.h"

@implementation AZDownOperation

+(instancetype) operationWithDownURL:(NSString *)downURL andParams:(NSMutableDictionary *)paramDic andCacheFilePath:(NSString *)cacheFilePath andSaveFilePath:(NSString *)saveFilePath
{
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:saveFilePath])
    {
        // set HTTP UA
        NSMutableDictionary *headDic=[NSMutableDictionary new];
        
        NSString *bundleNameStr = [NSString stringWithFormat:@"%@/%@",
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleNameKey],
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleVersionKey]];
        NSString *user_agent=[NSString stringWithFormat:@"andrew_down;iphone;system:iOS%@;%@",[UIDevice currentDevice].systemVersion,bundleNameStr];
        
        [headDic setObject:user_agent forKey:@"User-Agent"];

        
        
        // get have down data from cachePath
        if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
            
            NSError *error = nil;
           
            unsigned long long fileSize=[[[NSFileManager defaultManager] attributesOfItemAtPath:cacheFilePath error:&error] fileSize];
            
            if (error) {
                AZLog(@"get have down data failed!Error:%@", error);
            }
            
            NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
            [headDic setObject:headerRange forKey:@"Range"];
        }
        
        // default down use HTTPMETHOD : GET
        AZDownOperation *operation=[[AZDownOperation alloc] initWithURLString:downURL params:paramDic httpMethod:@"GET"];
        [operation addHeaders:headDic];
        
        [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:cacheFilePath append:YES]];
        
        operation.cacheFilePath=cacheFilePath;
        operation.saveFilePath=saveFilePath;
        return operation;
        
    }
    AZLog(@"file has exist %@",saveFilePath);
    return nil;
}

@end

