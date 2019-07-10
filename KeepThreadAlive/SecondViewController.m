//
//  SecondViewController.m
//  KeepThreadAlive
//
//  Created by weiguang on 2019/7/10.
//  Copyright © 2019 duia. All rights reserved.
//
// 使用自己封装的线程
#import "SecondViewController.h"
#import "MDPermenantThread.h"

@interface SecondViewController ()
@property (nonatomic,strong) MDPermenantThread *thread;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thread = [[MDPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
    
}

- (void)stop {
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}


@end
