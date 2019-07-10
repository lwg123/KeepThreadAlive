//
//  MDPermenantThread.h
//  KeepThreadAlive
//
//  Created by weiguang on 2019/7/10.
//  Copyright © 2019 duia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MDPermenantThreadTask)(void);

@interface MDPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;


/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(MDPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
