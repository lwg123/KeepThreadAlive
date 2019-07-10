//
//  MDPermenantThread.m
//  KeepThreadAlive
//
//  Created by weiguang on 2019/7/10.
//  Copyright © 2019 duia. All rights reserved.
//

#import "MDPermenantThread.h"

/** MJThread 为了测试用，实际可以用NSThread代替**/
@interface MDThread : NSThread
@end
@implementation MDThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end


@interface MDPermenantThread()

@property (strong, nonatomic) MDThread *innerThread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end

@implementation MDPermenantThread

#pragma mark - public methods
- (instancetype)init
{
    if (self = [super init]) {
        self.stopped = NO;
        
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[MDThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        [self.innerThread start];
    }
    
    return self;
}

//- (void)run
//{
//    if (!self.innerThread) return;
//
//    [self.innerThread start];
//}

- (void)executeTask:(MDPermenantThreadTask)task {
    if (!self.innerThread || !task) {
        return;
    }
    
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark - private methods
- (void)__stop
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(MDPermenantThreadTask)task
{
    task();
}


@end
