//
//  UIApplication+ZIMPushToken.h
//  ZIMTools
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ZIMPushToken)
@property (readwrite, copy, nonatomic) NSString *pushToken;
@end
