//
//  ZFPhoneTransition.h
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

#define PHONE_VIEW_TAG                      100
#define WIDTH                               240
#define SCALE                               (568.0/[UIScreen mainScreen].bounds.size.height)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZFPhoneOnLineViewController.h"
#import "ZFPhoneView.h"

typedef NS_ENUM(NSInteger,ZFTransitionType) {
    ZFTransitionTypePresent = 0,
    ZFTransitionTypeDismiss  = 1
};

@interface ZFPhoneTransition : NSObject <UIViewControllerAnimatedTransitioning>

/** 过渡类型 */
@property (nonatomic ,assign) ZFTransitionType transitionType;
/** 跳转类型 */
@property (nonatomic ,assign) ZFPhonePressentType pressetTyp;
/** 界面消失的位置 */
@property (nonatomic ,assign) CGRect endRect;

/** 按钮悬停位置 */
@property(nonatomic,assign)CGPoint lastPoint;

/** 控制点 */
@property (nonatomic ,assign) CGPoint controlPoint;


+ (instancetype)transitionWithQSTransitionType:(ZFTransitionType)transitionType presentType:(ZFPhonePressentType)presentType;

@end
