//
//  NSTimer+ZIMWeakTarget.h
//  ZIMTools
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZIMWeakTarget)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                 weakTarget:(id)target
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                        weakTarget:(id)target
                          selector:(SEL)aSelector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats;

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)seconds
            weakTarget:(id)target
              selector:(SEL)aSelector
              userInfo:(id)userInfo
               repeats:(BOOL)repeats;
@end
