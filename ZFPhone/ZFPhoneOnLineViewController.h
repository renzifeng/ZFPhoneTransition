//
//  ZFPhoneOnLineViewController.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZFPhonePressentType) {
    
    ZFPhoneTransitionPressentTypeNormal = 0,
    ZFPhoneTransitionPressentTypeMask = 1,
};

@interface ZFPhoneOnLineViewController : UIViewController
/** 上部分试图 */
@property(nonatomic,strong)UIView *viewTop;

/** 头像试图，一般封装在viewTop */
@property(nonatomic,strong)UIImageView *imgIconView;

/** 下部分试图 */
@property(nonatomic,strong)UIView *viewBottom;

/** 跳转类型 */
@property (nonatomic ,assign) ZFPhonePressentType pressentType;

/** 电话试图展开前的位置 */
@property (nonatomic ,assign) CGPoint lastDismissPoint;


/** 开始波浪动画 */
- (void)starLayerAnimation;

/** 停止波浪动画 */
- (void)stopLayerAnimation;

@end
