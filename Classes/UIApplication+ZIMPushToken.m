//
//  UIApplication+ZIMPushToken.m
//  ZIMTools
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "UIApplication+ZIMPushToken.h"
#import <objc/runtime.h>

static void *kPushTokenStorageKey = "ZIMPushTokenStorageKey";

@implementation UIApplication (ZIMPushToken)

- (void) setPushToken:(NSString *)pushToken {
    objc_setAssociatedObject(self, kPushTokenStorageKey, pushToken, OBJC_ASSOCIATION_COPY);
}

- (NSString *) pushToken {
    return objc_getAssociatedObject(self, kPushTokenStorageKey);
}

@end
