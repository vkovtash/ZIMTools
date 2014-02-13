//
//  UIAlertView+ZIMBlocks.m
//  ZIMTools
//
//  Created by Vlad Kovtash on 01.11.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "UIAlertView+ZIMBlocks.h"
#import <objc/runtime.h>

static void *ZIMAlertViewKey = "ZIMAlertViewKey";

@implementation UIAlertView (ZIMBlocks)

- (id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)aCancelTitle otherButtonTitles:(NSString *)otherTitles,... {
    __weak __typeof(&*self) weakSelf = self;
    self = [self initWithTitle:aTitle message:aMessage delegate:weakSelf cancelButtonTitle:aCancelTitle otherButtonTitles:nil];
    if (self) {
        if (otherTitles != nil) {
            [self addButtonWithTitle:otherTitles];
            va_list args;
            va_start(args, otherTitles);
            NSString * title = nil;
            while((title = va_arg(args, NSString*))) {
                [self addButtonWithTitle:title];
            }
            va_end(args);
        }
    }
    return self;
}

- (void) showWithDismissHandler:(ZIMAlertDismissedHandler)handler {
    objc_setAssociatedObject(self, ZIMAlertViewKey, handler, OBJC_ASSOCIATION_COPY);
    [self show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ZIMAlertDismissedHandler handler = objc_getAssociatedObject(self, ZIMAlertViewKey);
    handler ? handler(buttonIndex, buttonIndex == alertView.cancelButtonIndex) : nil;
}

@end
