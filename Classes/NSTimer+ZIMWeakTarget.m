//
//  NSTimer+ZIMWeakTarget.m
//  ZIMTools
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "NSTimer+ZIMWeakTarget.h"

@interface ZIMWeakTimerTarget : NSObject
@property (weak, nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL selector;

- (instancetype) initWithTarget:(id) target selector:(SEL) selector;
- (void)timerFireMethod:(NSTimer *)timer;
@end

@implementation ZIMWeakTimerTarget

- (instancetype) initWithTarget:(id) target selector:(SEL) selector {
    self = [super init];
    if (self) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void) timerFireMethod:(NSTimer *)timer {
    if (_target && _selector) {
        void (*func)(id, SEL, NSTimer *) = (void *)[_target methodForSelector:_selector];
        func(_target, _selector, timer);
    }
}

@end

@implementation NSTimer (ZIMWeakTarget)

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)seconds
            weakTarget:(id)target
              selector:(SEL)aSelector
              userInfo:(id)userInfo
               repeats:(BOOL)repeats {
    ZIMWeakTimerTarget *weakTarget = [[ZIMWeakTimerTarget alloc] initWithTarget:target selector:aSelector];
    self = [self initWithFireDate:date
                         interval:seconds
                           target:weakTarget
                         selector:@selector(timerFireMethod:)
                         userInfo:userInfo
                          repeats:repeats];
    return  self;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                 weakTarget:(id)target
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    ZIMWeakTimerTarget *weakTarget = [[ZIMWeakTimerTarget alloc] initWithTarget:target selector:aSelector];
    return [NSTimer scheduledTimerWithTimeInterval:seconds
                                            target:weakTarget
                                          selector:@selector(timerFireMethod:)
                                          userInfo:userInfo
                                           repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                        weakTarget:(id)target
                          selector:(SEL)aSelector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats {
    ZIMWeakTimerTarget *weakTarget = [[ZIMWeakTimerTarget alloc] initWithTarget:target selector:aSelector];
    return [NSTimer timerWithTimeInterval:seconds
                                   target:weakTarget
                                 selector:@selector(timerFireMethod:)
                                 userInfo:userInfo
                                  repeats:repeats];
}

@end












