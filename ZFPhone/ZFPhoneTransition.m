//
//  ZFPhoneTransition.m
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

#import "ZFPhoneTransition.h"
#import "ZFPhoneShared.h"

#define ZFPhoneShared               [ZFPhoneShared sharedPhone]
#define ScreenWidth                 [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                [UIScreen mainScreen].bounds.size.height

#define CallPhoneWidthAndHeight     CGRectGetWidth(ZFPhoneShared.btnOnLinePhone.frame)
#define GroupAnimDuration           1.0
#define RadiusDuration              0.8

@interface ZFPhoneTransition ()

/** transitionContext */
@property(nonatomic, strong) id <UIViewControllerContextTransitioning> zfContext;
/** 消失的试图控制器 */
@property (nonatomic, strong) UIViewController *fromVC;
/** 显示的视图控制器 */
@property (nonatomic, strong) UIViewController *toVC;
/** 界面消失的位置 */
@property (nonatomic, assign) CGRect           endRect;
/** UIWindow中点位置 */
@property (nonatomic, assign) CGPoint          centerPoint;
/** 电话按钮在UIWindow的中心位置 */
@property (nonatomic, assign) CGRect           centerRect;
/** 按钮悬停位置 */
@property (nonatomic, assign) CGPoint          lastPoint;
/** 控制点 */
@property (nonatomic, assign) CGPoint          controlPoint;

@end

@implementation ZFPhoneTransition


+ (instancetype)transitionWithQSTransitionType:(ZFTransitionType)transitionType
{
    ZFPhoneTransition *transiton = [[self alloc] init];
    if (transiton) {
        transiton.transitionType = transitionType;
    }
    return transiton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endRect = CGRectMake(ScreenWidth/2, ScreenHeight/2, 100, 100);
        self.centerPoint = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        self.lastPoint = ZFPhoneShared.btnOnLinePhone.center;
        self.controlPoint = CGPointMake(self.lastPoint.x , self.endRect.origin.y);
        self.centerRect = CGRectMake((ScreenWidth-CallPhoneWidthAndHeight)/2, (ScreenHeight-CallPhoneWidthAndHeight)/2, CallPhoneWidthAndHeight, CallPhoneWidthAndHeight);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    switch (self.transitionType) {
        case ZFTransitionTypeDismiss:
        {
            [self animateDismissTransition:transitionContext];
        }
            break;
        case ZFTransitionTypePresent:
        {
            [self animatePresentTransition:transitionContext];
        }
            break;
            
        default:
            break;
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    switch (self.transitionType) {
            
        case ZFTransitionTypeDismiss:
        {
            [self animationDismissDidStop:anim finished:flag];
        }
            break;
        case ZFTransitionTypePresent:
        {
            [self animationPresentDidStop:anim finished:flag];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 显示和消失动画

- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.zfContext = transitionContext;
    
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UINavigationController *fromNav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    self.fromVC = fromNav.viewControllers.lastObject;
    
    // 把新的试图控制器试图添加
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:_toVC.view];
    
    // 先隐藏新试图
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, 0, 0);
    self.toVC.view.layer.mask = maskLayer;
    
    CGPoint starPoint = self.lastPoint;
    CGPoint endPoint  = _toVC.view.center;
    UIBezierPath *animPath = [[UIBezierPath alloc] init];
    [animPath moveToPoint:starPoint];
    [animPath addQuadCurveToPoint:endPoint controlPoint:self.controlPoint];
    
    CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(3, 3, 1) duratio:GroupAnimDuration];
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [groupAnim setValue:self.zfContext forKey:@"transitionContext"];
    [ZFPhoneShared.btnOnLinePhone.layer addAnimation:groupAnim forKey:@"keyAnim"];
    
}


- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.zfContext = transitionContext;
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toNav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toVC = toNav.viewControllers.lastObject;
    
    UIView *containerView = [transitionContext containerView];
    
    // 画两个圆路径
    // 对角线的一半作为半径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:self.centerRect];
    
    // 创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer     = [CAShapeLayer layer];
    maskLayer.fillColor         = [UIColor greenColor].CGColor;
    maskLayer.path              = endCycle.CGPath;
    self.fromVC.view.layer.mask = maskLayer;
    
    // 创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue         = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue           = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration          = RadiusDuration;
    maskLayerAnimation.delegate          = self;
    maskLayerAnimation.timingFunction    = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

#pragma mark - 显示和消失状态 动画结束

- (void)animationPresentDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    // 如果是第一段动画
    if ([anim valueForKey:@"transitionContext"] == self.zfContext) {
        
        ZFPhoneShared.btnOnLinePhone.layer.transform =  CATransform3DMakeScale(3, 3, 1);
        ZFPhoneShared.btnOnLinePhone.center = ZFPhoneShared.btnOnLinePhone.center;
        [ZFPhoneShared.btnOnLinePhone.layer removeAllAnimations];
        
        UIView *containerView = [self.zfContext containerView];
        
        /**
         * 画两个圆路径
         */
        // 对角线的一半作为半径
        CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
        
        UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        UIBezierPath *starCycle =  [UIBezierPath bezierPathWithOvalInRect:self.centerRect];
        
        //创建CAShapeLayer进行遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor greenColor].CGColor;
        maskLayer.path = endCycle.CGPath;
        self.toVC.view.layer.mask = maskLayer;
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration          = RadiusDuration;
        animation.fromValue         = (__bridge id)starCycle.CGPath;
        animation.toValue           = (__bridge id)endCycle.CGPath;
        animation.delegate          = self;
        
        [maskLayer addAnimation:animation forKey:@"path"];
        
        ZFPhoneShared.btnOnLinePhone.hidden = YES;
    }else {
        
        [self.zfContext completeTransition:YES];
        self.toVC.view.layer.mask = nil;
        
    }
    
}

- (void)animationDismissDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 如果是第一段动画
    if ([anim valueForKey:@"transitionContext"] == self.zfContext) {
        
        [self.zfContext completeTransition:YES];
        [self.zfContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        
        CGPoint starPoint = self.centerPoint;
        
        UIBezierPath *animPath = [[UIBezierPath alloc] init];
        [animPath moveToPoint:starPoint];
        [animPath addQuadCurveToPoint:self.lastPoint controlPoint:self.controlPoint];
        
        CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(1.0, 1.0, 1) duratio:GroupAnimDuration];
        
        groupAnim.removedOnCompletion = NO;
        groupAnim.fillMode = kCAFillModeForwards;
        
        [ZFPhoneShared.btnOnLinePhone.layer addAnimation:groupAnim forKey:@"keyAnim"];
        ZFPhoneShared.btnOnLinePhone.hidden = NO;
        
    }else {
        
        [ZFPhoneShared.btnOnLinePhone.layer removeAllAnimations];
        ZFPhoneShared.btnOnLinePhone.center = self.lastPoint;
        ZFPhoneShared.btnOnLinePhone.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
        
    }
}

#pragma mark - 动画组

- (CAAnimationGroup *)groupAnimationWithPath:(UIBezierPath *)path transform:(CATransform3D)transform duratio:(CFTimeInterval)duration
{
    // 关键路径动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = path.CGPath;

    // 尺寸动画
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnim.toValue = [NSValue valueWithCATransform3D:transform];
    
    
    // 动画组
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.animations = @[keyAnimation,rotationAnim];
    
    groupAnim.delegate = self;
    groupAnim.duration = duration;
    
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    return groupAnim;
}

@end
