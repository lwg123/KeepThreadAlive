//
//  ViewController.m
//  KeepThreadAlive
//
//  Created by weiguang on 2019/7/9.
//  Copyright © 2019 duia. All rights reserved.
//

#import "ViewController.h"
#import "MDThread.h"

@interface ViewController ()

@property (nonatomic,strong) MDThread *thread;
@property (assign, nonatomic, getter=isStoped) BOOL stopped;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stopped = NO;
    __weak typeof(self) weakSelf = self;
    self.thread = [[MDThread alloc] initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);
        
        // 往RunLoop里面添加Source\Timer\Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        
        while (weakSelf && !weakSelf.stopped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"%@----end----", [NSThread currentThread]);
    }];
    
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.thread) return;
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}


- (IBAction)stop {
    if (!self.thread) return;
    
    // 在子线程调用stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopThread {
    
    // 设置标记为YES
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 清空线程
    self.thread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

@end
