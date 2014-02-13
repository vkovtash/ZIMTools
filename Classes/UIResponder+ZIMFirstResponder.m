//
//  UIResponder+ZIMFirstResponder.m
//  ZIMTools
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

//
//  Based on VJK on Stack Overflow: http://stackoverflow.com/a/10358135/790036
//

#import "UIResponder+ZIMFirstResponder.h"
#import <objc/runtime.h>

static char *kFirstResponderKey = "ZIMFirstResponderKey";

@implementation UIResponder (ZIMFirstResponder)

- (id)currentFirstResponder {
  [UIApplication.sharedApplication sendAction:@selector(findFirstResponder:)
      to:nil from:self forEvent:nil];
  id obj = objc_getAssociatedObject(self, kFirstResponderKey);
  objc_setAssociatedObject(self, kFirstResponderKey, nil, OBJC_ASSOCIATION_ASSIGN);
  return obj;
}

- (void)setCurrentFirstResponder:(id)responder {
  objc_setAssociatedObject(self, kFirstResponderKey, responder,
      OBJC_ASSOCIATION_ASSIGN);
}

- (void)findFirstResponder:(id)sender {
  [sender setCurrentFirstResponder:self];
}

@end
