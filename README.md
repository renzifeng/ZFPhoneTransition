# ZFPhoneTransition
<p align="left">
<a href="https://travis-ci.org/renzifeng/ZFPhoneTransition"><img src="https://travis-ci.org/renzifeng/ZFPhoneTransition.svg?branch=master"></a>
<a href="https://img.shields.io/cocoapods/v/ZFPhoneTransition.svg"><img src="https://img.shields.io/cocoapods/v/ZFPhoneTransition.svg"></a>
<a href="https://img.shields.io/cocoapods/v/ZFPhoneTransition.svg"><img src="https://img.shields.io/github/license/renzifeng/ZFPhoneTransition.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/ZFPhoneTransition"><img src="https://img.shields.io/cocoapods/p/ZFPhoneTransition.svg?style=flat"></a>
<a href="http://weibo.com/zifeng1300"><img src="https://img.shields.io/badge/weibo-@%E4%BB%BB%E5%AD%90%E4%B8%B0-yellow.svg?style=flat"></a>
</p>
## 特性
* 仿qq电话转场动画

## 要求
* iOS 7+
* Xcode 6+

## 效果图

![图片效果演示](https://github.com/renzifeng/ZFPhoneTransition/raw/master/ZFPhoneTransition.gif)


## 使用
```objc
ZFPhoneShared *phone = [ZFPhoneShared sharedPhone];
[[UIApplication sharedApplication].keyWindow addSubview:phone.btnOnLinePhone];
    
[phone.btnOnLinePhone addTarget:self action:@selector(btnOnLinePhonePressed:) forControlEvents:UIControlEventTouchUpInside];

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
```

# 联系我
- 微博: [@任子丰](https://weibo.com/zifeng1300)
- 邮箱: zifeng1300@gmail.com
- QQ群：213376937

# License

ZFPhoneTransition is available under the MIT license. See the LICENSE file for more info.