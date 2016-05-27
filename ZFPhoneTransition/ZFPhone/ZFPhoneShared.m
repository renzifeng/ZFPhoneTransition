//
//  ZFPhoneShared.m
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

#import "ZFPhoneShared.h"
#define ScreenWidth                         [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                        [UIScreen mainScreen].bounds.size.height

@implementation ZFPhoneShared
+ (instancetype)sharedPhone
{
    static ZFPhoneShared *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZFPhoneShared alloc] init];
    });
    return instance;
}

- (UIButton *)btnOnLinePhone
{
    if (!_btnOnLinePhone) {
        _btnOnLinePhone             = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnOnLinePhone.frame       = CGRectMake(0, 0, 50, 50);
        _btnOnLinePhone.center      = CGPointMake(ScreenWidth - 50, ScreenHeight - 90);
        [_btnOnLinePhone setImage:[UIImage imageNamed:@"dial_phone_number_icon"] forState:UIControlStateNormal];
        [_btnOnLinePhone setImage:[UIImage imageNamed:@"dial_phone_number_icon"] forState:UIControlStateHighlighted];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_btnOnLinePhone addGestureRecognizer:pan];
    }
    return _btnOnLinePhone;
}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat padding = CGRectGetWidth(self.btnOnLinePhone.frame)/2;
    // 超出屏幕可视范围的直接return
    if (locationPoint.x < padding || locationPoint.y < padding || locationPoint.x > ScreenWidth-padding || locationPoint.y > ScreenHeight-padding) return;

    self.btnOnLinePhone.center = locationPoint;
}

@end
