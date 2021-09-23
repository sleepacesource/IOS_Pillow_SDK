//
//  BaseViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "BaseViewController.h"
#import "SLPLoadingBlockView.h"
#import "Theme.h"
#import "Utils.h"

#define kNavigationBarHeight (44.0)
#define kStatusBarHeight (20.0)

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) SLPLoadingBlockView *loadingView;
@end

@implementation BaseViewController

- (void)dealloc {
    [self unshowLoadingView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseViewControllerSetUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignEdit)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)resignEdit
{
    [self.view endEditing:YES];
}

- (void)baseViewControllerSetUI {
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.line setBackgroundColor:Theme.normalLineColor];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:Theme.T1];
    [self.titleLabel setTextColor:Theme.C10];
    CGFloat shellHeight = kNavigationBarHeight + 1;
    if ([Utils areaInsets].top > 0) {
        shellHeight += [Utils areaInsets].top;
    }else{
        shellHeight += kStatusBarHeight;
    }
    [self.navigationShellHeight setConstant:shellHeight];

}

- (void)back{
    [self unshowLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (SLPLoadingBlockView *)showLoadingView {
    if (self.loadingView == nil) {
        self.loadingView= [SLPLoadingBlockView showInViewController:self topEdge:0 animated:YES];
    }
    return self.loadingView;
}

- (void)unshowLoadingView {
    [self.loadingView unshowAnimated:YES];
    self.loadingView = nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        
        return NO;
        
    }
    
    return YES;
    
}

@end
