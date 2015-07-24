//
//  AZDownSDK.h
//  AZDownSDK
//
//  Created by Andrew on 15/5/15.
//  Copyright (c) 2015年 Andrew. All rights reserved.

#import <Foundation/Foundation.h>

#if DEBUG
    #define AZLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#elif
    #define AZLog(...)
#endif

#import "AZDownManager.h"


