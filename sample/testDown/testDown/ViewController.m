//
//  ViewController.m
//  testDown
//
//  Created by TopSageMacMini on 15/7/22.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "AZDownSDK.h"

NSString *urlOne = @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg";
NSString *urlTwo = @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V1.4.1.dmg";

@interface ViewController ()
@property (strong, nonatomic) AZDownManager *downManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _downManager=[AZDownManager shareDownManager];
    //http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V1.4.1.dmg
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"2.1.dmg"];
    
    
    [_downManager addDownloadTaskToQueueandDownURL:urlOne toSaveFilePath:downloadPath onDownloadProgress:^(double process, unsigned long long totalSize) {
         NSLog(@"%f--%.2fMb",process,(float)totalSize/1024/1024);
    } onCompletion:^(MKNetworkOperation *completedOperation) {
         NSLog(@"下载完成，文件大小为%.2fMb",(float)completedOperation.totalSize/1024/1024);
    } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
