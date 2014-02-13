//
//  UIAlertView+ZIMBlocks.h
//  ZIMTools
//
//  Created by Vlad Kovtash on 01.11.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZIMAlertDismissedHandler) (NSInteger selectedIndex, BOOL didCancel);

@interface UIAlertView (ZIMBlocks)
- (id) initWithTitle:(NSString *)aTitle
             message:(NSString *)aMessage
   cancelButtonTitle:(NSString *)aCancelTitle
   otherButtonTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION;
- (void) showWithDismissHandler:(ZIMAlertDismissedHandler)handler;
@end
