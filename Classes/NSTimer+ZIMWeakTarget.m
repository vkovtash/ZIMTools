//
//  NSTimer+ZIMWeakTarget.m
//  ZIMTools
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "NSTimer+ZIMWeakTarget.h"

static NSString *const ZIMTimersBackgroundThreadName = @"ZIMTimersBackgroundThread";

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

+ (NSTimer *)scheduledBackgroundTimerWithTimeInterval:(NSTimeInterval)seconds
                                 weakTarget:(id)target
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    ZIMWeakTimerTarget *weakTarget = [[ZIMWeakTimerTarget alloc] initWithTarget:target selector:aSelector];
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds
                                             target:weakTarget
                                           selector:@selector(timerFireMethod:)
                                           userInfo:userInfo
                                            repeats:repeats];
    
    [[self class] performSelector:@selector(sheduleBackgroundTimer:)
                         onThread:[[self class] backgroundThread]
                       withObject:timer
                    waitUntilDone:YES];
    
    return timer;
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

+ (NSThread *) backgroundThread {
	static dispatch_once_t predicate;
    __strong static NSThread *_sharedObject = nil;
	dispatch_once(&predicate, ^{
		_sharedObject = [[NSThread alloc] initWithTarget:[self class]
		                                         selector:@selector(configureThread)
		                                           object:nil];
		[_sharedObject start];
	});
    return _sharedObject;
}

+ (void) configureThread {
	@autoreleasepool {
		[[NSThread currentThread] setName:ZIMTimersBackgroundThreadName];
		// We can't run the run loop unless it has an associated input source or a timer.
		// So we'll just create a timer that will never fire - unless the server runs for a decades.
		[NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]
		                                 target:[self class]
		                               selector:@selector(ignore:)
		                               userInfo:nil
		                                repeats:YES];
		
		[[NSRunLoop currentRunLoop] run];
	}
}

+ (void) ignore:(NSTimer *) timer {
}

+ (void) sheduleBackgroundTimer:(NSTimer *) timer {
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

@end












