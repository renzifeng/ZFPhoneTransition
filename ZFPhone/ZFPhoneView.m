//
//  ZFPhoneView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPhoneView.h"
#import "ZFPhoneOnLineViewController.h"

@implementation ZFPhoneView

- (void)tap:(UITapGestureRecognizer *)tap
{
    ZFPhoneOnLineViewController *qqOnlineVC = [[ZFPhoneOnLineViewController alloc] init];
    
    qqOnlineVC.pressentType = ZFPhoneTransitionPressentTypeMask;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id vc = window.rootViewController;
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        [nav.topViewController presentViewController:qqOnlineVC animated:YES completion:nil];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        [tab presentViewController:qqOnlineVC animated:YES completion:nil];
    } else if ([vc isKindOfClass:[UIViewController class]]) {
        [vc presentViewController:qqOnlineVC animated:YES completion:nil];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    ZFPhoneView *view = (ZFPhoneView *)pan.view;
    
    CGFloat distance = 40;  // 离四周的最小边距
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        
        if (point.y <= distance) {
            
            point.y = distance;
            
        }else if (point.y >= [UIScreen mainScreen].bounds.size.height - distance){
            
            point.y = [UIScreen mainScreen].bounds.size.height - distance;
        }else if (point.x <= [UIScreen mainScreen].bounds.size.width/2.0) {
            
            point.x = distance;
            
        }else {
            
            point.x = [UIScreen mainScreen].bounds.size.width - distance;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            view.center = point;
        }];
        
    }else {
        
        view.center = point;
    }
    
}

@end
