//
//  MKLoadingHUD.m
//  testMBProgressHUD
//
//  Created by ykh on 15/9/21.
//  Copyright (c) 2015年 MK. All rights reserved.
//

#import "MKLoadingYILogo.h"

@interface MKLoadingYILogo()

@property (nonatomic,strong) UIImageView *loadingCircleView;

@end

@implementation MKLoadingYILogo{

    BOOL _isAnimating;
}

+(instancetype)loadingView
{
    MKLoadingYILogo *loadingView = [[MKLoadingYILogo alloc] initWithFrame:CGRectZero];
    [loadingView addAnimationImageView];
    return loadingView;
}

+ (instancetype)loadingViewWithAnimating
{
    MKLoadingYILogo *loadingView = [self loadingView];
    [loadingView startAnimating];
    return loadingView;
}

-(void)addAnimationImageView
{
    UIImage *circleImg = [UIImage imageNamed:@"loading_circle"];
    UIImage *yImg = [UIImage imageNamed:@"loading_y"];
    
    //圈圆
    _loadingCircleView = [[UIImageView alloc] initWithImage:circleImg];
    [self addSubview:_loadingCircleView];
    
    //Y
    UIImageView *yImgView = [[UIImageView alloc] initWithImage:yImg];
    [self addSubview:yImgView];
    
    self.mk_width = MAX(_loadingCircleView.mk_width, yImgView.mk_width);
    self.mk_height = MAX(_loadingCircleView.mk_height, yImgView.mk_height);
    _loadingCircleView.center = CGPointMake(self.mk_width*0.5, self.mk_height*0.5);
    yImgView.center = _loadingCircleView.center;
    yImgView.mk_y += 3;
}

- (void)startAnimating
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 1.0;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 99999;
    [_loadingCircleView.layer addAnimation:animation forKey:@"rotation"];
    _isAnimating = YES;
}

-(void)stopAnimating
{
    _isAnimating = NO;
    [_loadingCircleView.layer removeAnimationForKey:@"rotation"];
}

-(BOOL)isAnimating
{
    return _isAnimating;
}

@end