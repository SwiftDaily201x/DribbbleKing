//
//  NotiHandle.m
//  DribbbleKing
//
//  Created by Fnoz on 16/9/15.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "NotiHandle.h"
#import "CRToast.h"

@implementation NotiHandle

+ (void)showNoti:(NSString *)text isSuccess:(BOOL)isSuccess {
    UIColor *color;
    if (isSuccess) {
        color = [UIColor greenColor];
    }else
    {
        color = [UIColor redColor];
    }
    NSDictionary *options = @{
                              kCRToastTextKey : text,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : color,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey: [UIApplication sharedApplication].isStatusBarHidden?@(CRToastTypeNavigationBar):@(CRToastTypeStatusBar)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

@end
