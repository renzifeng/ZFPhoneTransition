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

#define GroupAnimDuration           0.8
#define RadiusDuration              0.8

#import "ZFPhoneTransition.h"

@interface ZFPhoneTransition ()

/** transitionContext */
@property(nonatomic, strong) id <UIViewControllerContextTransitioning> zfContext;
/** 消失的试图控制器 */
@property (nonatomic, strong) UIViewController *fromVC;
/** 显示的视图控制器 */
@property (nonatomic, strong) UIViewController *toVC;

@end

@implementation ZFPhoneTransition

+ (instancetype)transitionWithQSTransitionType:(ZFTransitionType)transitionType presentType:(ZFPhonePressentType)presentType
{
    ZFPhoneTransition *transiton = [[self alloc] init];
    if (transiton) {
        transiton.transitionType = transitionType;
        transiton.pressetTyp = presentType;
    }
    return transiton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endRect = CGRectMake(100, 100, 100, 100);
        self.lastPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height - 90);
        self.controlPoint = CGPointMake(self.lastPoint.x , self.endRect.origin.y + self.endRect.size.height);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

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
    
    ZFPhoneOnLineViewController *onlineVC = (ZFPhoneOnLineViewController *)self.toVC;
    
    switch (self.pressetTyp) {
        case ZFPhoneTransitionPressentTypeNormal:
        {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = RadiusDuration;
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -onlineVC.viewTop.bounds.size.height, 0)];
            animation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
            animation.delegate = self;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [animation setValue:self.zfContext forKey:@"transitionContext"];
            [onlineVC.viewTop.layer addAnimation:animation forKey:nil];
            
            
            CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation1.duration = RadiusDuration;
            animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,onlineVC.viewBottom.bounds.size.height , 0)];
            animation1.byValue  = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, - onlineVC.viewBottom.bounds.size.height, 0)];
            animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [onlineVC.viewBottom.layer addAnimation:animation1 forKey:nil];
            
        }
            break;
        case ZFPhoneTransitionPressentTypeMask:
        {
            
            ZFPhoneView *phoneView = [[UIApplication sharedApplication].keyWindow viewWithTag:PHONE_VIEW_TAG];
            // 设置头像图
            phoneView.image = onlineVC.imgIconView.image;
            
            // 先隐藏新试图
            CALayer *maskLayer = [CALayer layer];
            maskLayer.frame = CGRectMake(0, 0, 0, 0);
            onlineVC.view.layer.mask = maskLayer;
            
            CGPoint starPoint = phoneView.center;
            CGPoint endPoint  = phoneView.firstCenter;
            
            CGPoint ancholPoint = CGPointMake(endPoint.x + (starPoint.x - endPoint.x)/2.0, endPoint.y);
            
            UIBezierPath *animPath = [[UIBezierPath alloc] init];
            [animPath moveToPoint:starPoint];
            [animPath addQuadCurveToPoint:endPoint controlPoint:ancholPoint];
            
            
            // 记录下phoneView消失的位置
            onlineVC.lastDismissPoint = starPoint;
            
            CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(1.0, 1.0, 1) duratio:GroupAnimDuration];
            
            groupAnim.removedOnCompletion = NO;
            groupAnim.fillMode = kCAFillModeForwards;
            groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [groupAnim setValue:self.zfContext forKey:@"transitionContext"];
            
            [phoneView.layer addAnimation:groupAnim forKey:@"keyAnim"];
        }
            break;
            
        default:
            break;
    }
    
    // 启动波浪动画
    [onlineVC starLayerAnimation];
}

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.zfContext = transitionContext;
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toNav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toVC = toNav.viewControllers.lastObject;
    
    ZFPhoneOnLineViewController *onlineVC = (ZFPhoneOnLineViewController *)self.fromVC;
    
    // 获取keyWindow
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect currentRect = [window convertRect:onlineVC.imgIconView.frame fromWindow:window];
    self.endRect = currentRect;
    
    
    switch (self.pressetTyp) {
        case ZFPhoneTransitionPressentTypeNormal:
        {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = RadiusDuration;
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
            animation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -onlineVC.viewTop.bounds.size.height, 0)];
            animation.delegate = self;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [animation setValue:self.zfContext forKey:@"transitionContext"];
            [onlineVC.viewTop.layer addAnimation:animation forKey:nil];
            
            
            CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation1.duration = RadiusDuration;
            animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,0, 0)];
            animation1.byValue  = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,onlineVC.viewBottom.bounds.size.height, 0)];
            animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation1.removedOnCompletion = NO;
            animation1.fillMode = kCAFillModeForwards;
            
            
            [onlineVC.viewBottom.layer addAnimation:animation1 forKey:nil];
            
            
            [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                onlineVC.view.alpha = 0;
            } completion:nil];
            
        }
            break;
            
        case ZFPhoneTransitionPressentTypeMask:
        {
            
            /**
             * 画两个圆路径
             */
            
            UIView *containerView = [transitionContext containerView];
            containerView.backgroundColor = [UIColor clearColor];
            // 对角线的一半作为半径
            CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
            
            UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:self.endRect];
            
            //创建CAShapeLayer进行遮盖
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.fillColor = [UIColor greenColor].CGColor;
            maskLayer.path = endCycle.CGPath;
            self.fromVC.view.layer.mask = maskLayer;
            
            //创建路径动画
            CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
            maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
            maskLayerAnimation.duration = RadiusDuration;
            maskLayerAnimation.delegate = self;
            maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
            [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 显示和消失状态 动画结束

- (void)animationPresentDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 如果是第一段动画
    if ([anim valueForKey:@"transitionContext"] == self.zfContext) {
        
        switch (self.pressetTyp) {
            case ZFPhoneTransitionPressentTypeNormal:
            {
                [self.zfContext completeTransition:YES];
            }
                break;
            case ZFPhoneTransitionPressentTypeMask:
            {
                ZFPhoneView *phoneView = [[UIApplication sharedApplication].keyWindow viewWithTag:PHONE_VIEW_TAG];
                
                phoneView.layer.transform =  CATransform3DMakeScale(1, 1, 1);
                phoneView.center = phoneView.firstCenter;
                [phoneView.layer removeAllAnimations];
                
                UIView *containerView = [self.zfContext containerView];
                
                /**
                 * 画两个圆路径
                 */
                // 对角线的一半作为半径
                CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
                
                UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                
                UIBezierPath *starCycle =  [UIBezierPath bezierPathWithOvalInRect:phoneView.frame];
                
                //创建CAShapeLayer进行遮盖
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.fillColor = [UIColor greenColor].CGColor;
                maskLayer.path = endCycle.CGPath;
                self.toVC.view.layer.mask = maskLayer;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                animation.duration = RadiusDuration;
                animation.fromValue = (__bridge id)starCycle.CGPath;
                animation.toValue   = (__bridge id)endCycle.CGPath;
                animation.delegate = self;
                
                [maskLayer addAnimation:animation forKey:@"path"];
            }
                break;
                
            default:
                break;
        }
        
    }else {
        
        ZFPhoneView *phoneView = [[UIApplication sharedApplication].keyWindow viewWithTag:PHONE_VIEW_TAG];
        [phoneView.layer removeAllAnimations];
        [phoneView removeFromSuperview];
        
        [self.zfContext completeTransition:YES];
        
        self.toVC.view.layer.mask = nil;
    }
}

- (void)animationDismissDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    ZFPhoneOnLineViewController *onlineVC = (ZFPhoneOnLineViewController *)self.fromVC;
    
    switch (self.pressetTyp) {
        case ZFPhoneTransitionPressentTypeNormal:
        {
            
            [onlineVC.viewTop.layer removeAllAnimations];
            [onlineVC.viewBottom.layer removeAllAnimations];
            [self.zfContext completeTransition:YES];
            
        }
            break;
            
        case ZFPhoneTransitionPressentTypeMask:
        {
            // 如果是第一段动画
            if ([anim valueForKey:@"transitionContext"] == self.zfContext) {
                
                ZFPhoneView *imgPhotoView = [[ZFPhoneView alloc] initWithFrame:self.endRect];
                
                imgPhotoView.firstCenter = imgPhotoView.center;
                imgPhotoView.userInteractionEnabled = YES;
                imgPhotoView.layer.cornerRadius = self.endRect.size.width/2.0;
                imgPhotoView.layer.masksToBounds = YES;
                imgPhotoView.tag = PHONE_VIEW_TAG;
                imgPhotoView.image = [UIImage imageNamed:@"dial_phone_number_icon"];
                [[UIApplication sharedApplication].keyWindow addSubview:imgPhotoView];
                
                // 轻拍事件、拖动事件请在ZFPhoneView中查看
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:imgPhotoView action:@selector(pan:)];
                [imgPhotoView addGestureRecognizer:pan];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:imgPhotoView action:@selector(tap:)];
                [imgPhotoView addGestureRecognizer:tap];
                
                
                [self.zfContext completeTransition:YES];
                [self.zfContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
                
                CGPoint starPoint = CGPointMake(self.endRect.origin.x + self.endRect.size.width / 2.0, self.endRect.origin.y + self.endRect.size.height / 2.0);
                
                CGPoint endPoint = onlineVC.lastDismissPoint;
                
                CGPoint ancholPoint = CGPointMake(starPoint.x + (endPoint.x - starPoint.x)/2.0, starPoint.y);
                
                UIBezierPath *animPath = [[UIBezierPath alloc] init];
                [animPath moveToPoint:starPoint];
                [animPath addQuadCurveToPoint:endPoint controlPoint:ancholPoint];
                
                CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(0.4, 0.4, 1) duratio:GroupAnimDuration];
                groupAnim.removedOnCompletion = NO;
                groupAnim.fillMode = kCAFillModeForwards;
                
                [imgPhotoView.layer addAnimation:groupAnim forKey:@"keyAnim"];
                
            }else {
                
                UIImageView *imgView = [[UIApplication sharedApplication].keyWindow viewWithTag:PHONE_VIEW_TAG];
                [imgView.layer removeAllAnimations];
                imgView.center = onlineVC.lastDismissPoint;
                imgView.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1);
            }
            
        }
            break;
            
        default:
            break;
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
