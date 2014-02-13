//
//  UIActionSheet+ZIMBlocks.h
//  ZIMTools
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZIMActionSheetDismissedHandler) (NSInteger selectedIndex, BOOL didCancel, BOOL destructive);

@interface UIActionSheet (ZIMBlocks)
- (id) initWithTitle:(NSString *)aTitle
   cancelButtonTitle:(NSString *)aCancelTitle
destructiveButtonTitle:(NSString *) aDestructiveTitle
   otherButtonTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION;

- (void)showFromTabBar:(UITabBar *)view withDismissHandler:(ZIMActionSheetDismissedHandler)handler;
- (void)showFromToolbar:(UIToolbar *)view withDismissHandler:(ZIMActionSheetDismissedHandler)handler;
- (void)showInView:(UIView *)view withDismissHandler:(ZIMActionSheetDismissedHandler)handler;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withDismissHandler:(ZIMActionSheetDismissedHandler)handler;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withDismissHandler:(ZIMActionSheetDismissedHandler)handler;
@end
