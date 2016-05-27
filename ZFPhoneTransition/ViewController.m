//
//  ViewController.m
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

#import "ViewController.h"
#import "ZFPhoneShared.h"
#import "ZFPhoneOnLineViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"qq_portrait"].CGImage;
    
    ZFPhoneShared *phone = [ZFPhoneShared sharedPhone];
    [[UIApplication sharedApplication].keyWindow addSubview:phone.btnOnLinePhone];
    
    [phone.btnOnLinePhone addTarget:self action:@selector(btnOnLinePhonePressed:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnOnLinePhonePressed:(UIButton *)btn
{
    ZFPhoneOnLineViewController *qqOnlineVC = [[ZFPhoneOnLineViewController alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
