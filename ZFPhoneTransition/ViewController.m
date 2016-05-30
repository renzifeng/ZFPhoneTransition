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
#import "ZFPhoneTransition.h"

@interface ViewController ()
/** 电话按钮 */
@property(nonatomic,strong)UIButton *btnPhone;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"qq_portrait"].CGImage;
    
    self.navigationItem.title = @"QQ电话";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnPhone];
    
}

- (void)btnOnLinePhonePressed
{
    ZFPhoneOnLineViewController *qqOnlineVC = [[ZFPhoneOnLineViewController alloc] init];
    
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:PHONE_VIEW_TAG]) {
        
        qqOnlineVC.pressentType = ZFPhoneTransitionPressentTypeMask;
        
    }else {
        
        qqOnlineVC.pressentType = ZFPhoneTransitionPressentTypeNormal;
    }
    
    [self presentViewController:qqOnlineVC animated:YES completion:nil];

}

#pragma mark - Getter/Setter

- (UIButton *)btnPhone
{
    if (!_btnPhone) {
        
        _btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPhone.frame = CGRectMake(0, 0, 30, 30);
        [_btnPhone setImage:[UIImage imageNamed:@"aio_icons_freeaudio"] forState:UIControlStateNormal];
        [_btnPhone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnPhone addTarget:self action:@selector(btnOnLinePhonePressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPhone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
