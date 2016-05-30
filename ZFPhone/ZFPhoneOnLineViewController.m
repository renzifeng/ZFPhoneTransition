//
//  ZFPhoneOnLineViewController.m
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

#import "ZFPhoneOnLineViewController.h"
#import "ZFPhoneTransition.h"

@interface ZFPhoneOnLineViewController ()<UIViewControllerTransitioningDelegate>
/** 波浪图层 */
@property(nonatomic,strong) CAShapeLayer * layer;
/** 波浪图层 */
@property(nonatomic,strong) CAShapeLayer * layer1;
/** 波浪图层 */
@property(nonatomic,strong) CAShapeLayer * layer2;

@end

@implementation ZFPhoneOnLineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"1452499220565.jpg"].CGImage;
    
    // 设置第一次电话图标的位置
    self.lastDismissPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height - 90);
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.viewBottom];
    
    CGFloat topHeight = 280.0 / SCALE;
    CGFloat bottomHeight = 160.0 / SCALE;
    
    self.viewTop.frame = CGRectMake(0, 0, self.view.bounds.size.width, topHeight);
    self.viewBottom.frame = CGRectMake(0, self.view.bounds.size.height - bottomHeight, self.view.bounds.size.width, bottomHeight);
    
    
    self.layer = [CAShapeLayer layer];
    self.layer.fillColor = [UIColor clearColor].CGColor;
    self.layer.strokeColor = [UIColor whiteColor].CGColor;
    self.layer.lineCap = kCALineCapRound;
    
    self.layer1 = [CAShapeLayer layer];
    self.layer1.fillColor = [UIColor clearColor].CGColor;
    self.layer1.strokeColor = [UIColor whiteColor].CGColor;
    self.layer1.lineCap = kCALineCapRound;
    
    self.layer2 = [CAShapeLayer layer];
    self.layer2.fillColor = [UIColor clearColor].CGColor;
    self.layer2.strokeColor = [UIColor whiteColor].CGColor;
    self.layer2.lineCap = kCALineCapRound;
    
    
    CGFloat width = WIDTH;
    
    CGFloat width1 = 40;
    CGFloat width2 = 70;
    
    CGFloat centerY = 360.0 / SCALE;
    
    UIBezierPath *shapePath = [[UIBezierPath alloc] init];
    [shapePath moveToPoint:CGPointMake(-width, centerY)];
    
    UIBezierPath *shapePath1 = [[UIBezierPath alloc] init];
    [shapePath1 moveToPoint:CGPointMake(-width - width1, centerY)];
    
    UIBezierPath *shapePath2 = [[UIBezierPath alloc] init];
    [shapePath2 moveToPoint:CGPointMake(-width - width2, centerY)];
    
    
    CGFloat  x = 0;
    for (int i =0 ; i < 6; i++) {
        
        [shapePath addQuadCurveToPoint:CGPointMake(x - WIDTH / 2.0, centerY) controlPoint:CGPointMake(x - WIDTH + WIDTH/4.0, centerY - 8)];
        
        [shapePath addQuadCurveToPoint:CGPointMake(x, centerY) controlPoint:CGPointMake(x - WIDTH/4.0, centerY + 8)];
        
        [shapePath1 addQuadCurveToPoint:CGPointMake(x - width1 - WIDTH / 2.0, centerY) controlPoint:CGPointMake(x - width1 - WIDTH + WIDTH/4.0, centerY - 14)];
        [shapePath1 addQuadCurveToPoint:CGPointMake(x - width1, centerY) controlPoint:CGPointMake(x - width1 - WIDTH/4.0, centerY + 14)];
        
        
        [shapePath2 addQuadCurveToPoint:CGPointMake(x - width2 - WIDTH / 2.0, centerY) controlPoint:CGPointMake(x - width2 - WIDTH + WIDTH/4.0, centerY - 20)];
        [shapePath2 addQuadCurveToPoint:CGPointMake(x - width2, centerY) controlPoint:CGPointMake(x - width2 - WIDTH/4.0, centerY + 20)];
        x += width;
    }
    
    self.layer.path = shapePath.CGPath;
    self.layer1.path = shapePath1.CGPath;
    self.layer2.path = shapePath2.CGPath;
    
    
    [self.view.layer addSublayer:self.layer];
    [self.view.layer addSublayer:self.layer1];
    [self.view.layer addSublayer:self.layer2];

}

#pragma mark - Event

- (void)starLayerAnimation
{
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.duration = 1.0;
    animation1.repeatCount = INFINITY;
    animation1.keyPath = @"transform";
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(WIDTH, 0, 0)];
    
    [self.layer addAnimation:animation1 forKey:nil];
    [self.layer1 addAnimation:animation1 forKey:nil];
    [self.layer2 addAnimation:animation1 forKey:nil];
}

- (void)stopLayerAnimation
{
    [self.layer removeAllAnimations];
    [self.layer1 removeAllAnimations];
    [self.layer2 removeAllAnimations];
}


- (void)hangUpThePhone
{
    self.pressentType = ZFPhoneTransitionPressentTypeNormal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)packUpThePhone
{
    self.pressentType = ZFPhoneTransitionPressentTypeMask;
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [ZFPhoneTransition transitionWithQSTransitionType:ZFTransitionTypeDismiss presentType:self.pressentType];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [ZFPhoneTransition transitionWithQSTransitionType:ZFTransitionTypePresent presentType:self.pressentType];
}




#pragma mark - getter
- (UIView *)viewTop
{
    if (!_viewTop) {
        _viewTop = [[UIView alloc] init];
        
        _viewTop.backgroundColor = [UIColor clearColor];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        lbl.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 240.0/SCALE);
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"紫枫";
        
        [_viewTop addSubview:lbl];
        
        [_viewTop addSubview:self.imgIconView];
        self.imgIconView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 160.0/SCALE);
        
    }
    return _viewTop;
}

- (UIImageView *)imgIconView
{
    if (!_imgIconView) {
        _imgIconView = [[UIImageView alloc] init];
        _imgIconView.frame = CGRectMake(0, 0, 140, 140);
        _imgIconView.image = [UIImage imageNamed:@"avatar"];
        _imgIconView.contentMode = UIViewContentModeScaleAspectFill;
        _imgIconView.layer.cornerRadius = 70;
        _imgIconView.layer.masksToBounds = YES;
        _imgIconView.backgroundColor = [UIColor cyanColor];
    }
    return _imgIconView;
}

- (UIView *)viewBottom
{
    if (!_viewBottom) {
        _viewBottom = [[UIView alloc] init];
        
        _viewBottom.backgroundColor = [UIColor clearColor];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 60);
        btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0 - 60, 64);
        btn.layer.cornerRadius = 30;
        btn.layer.masksToBounds = YES;
        [btn setImage:[UIImage imageNamed:@"AV_red_normal"]  forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"AV_red_pressed"]  forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(hangUpThePhone) forControlEvents:UIControlEventTouchUpInside];
        [_viewBottom addSubview:btn];
        
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 60);
        btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0 + 60, 64);
        btn.layer.cornerRadius = 30;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor cyanColor];
        [btn setImage:[UIImage imageNamed:@"AV_scale"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"AV_scale_press"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(packUpThePhone) forControlEvents:UIControlEventTouchUpInside];
        [_viewBottom addSubview:btn];
        
        
    }
    return _viewBottom;
}

@end
