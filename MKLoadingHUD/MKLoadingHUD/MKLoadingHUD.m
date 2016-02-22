//
//  MKLoadingHUD.m
//  MKLoadingHUD
//
//  Created by ykh on 16/2/22.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKLoadingHUD.h"

const CGFloat MKLoadingHUDAnimationDuration     = 0.15;     //动画持续时间
const CGFloat MKLoadingHUDRadiusScale           = 1/10.0f;  //圆角占宽度比例
const CGFloat MKLoadingHUDStatusLableFontSize   = 13.0f;    //字体默认 size
const CGFloat MKLoadingHUDCustomPadding         = 20;       //hudContent 边距
const CGFloat MKLoadingHUDStatusOnlyPadding     = 10;       //hudContent 边距 - 只包含 status 的情况 ,调整该值可调整只包含文字时,文字距黑框上下左右的边距
const CGFloat MKLoadingHUDAutoHideDuration      = 2.0f;     //自动隐藏HUD的延迟时间

NSString * const mk_successImageName = @"commentSuccessed";
NSString * const mk_errorImageName = @"error";

#pragma mark UIView+MKUIViewFrame

@interface UIView (MKUIViewFrame)

@property (assign, nonatomic) CGFloat mk_x;
@property (assign, nonatomic) CGFloat mk_y;
@property (assign, nonatomic) CGFloat mk_width;
@property (assign, nonatomic) CGFloat mk_height;
@property (assign, nonatomic) CGFloat mk_left;
@property (assign, nonatomic) CGFloat mk_right;
@property (assign, nonatomic) CGFloat mk_top;
@property (assign, nonatomic) CGFloat mk_bottom;
@property (assign, nonatomic) CGFloat mk_centerX;
@property (assign, nonatomic) CGFloat mk_centerY;

@end

@implementation UIView (MKUIViewFrame)

- (void)setMk_x:(CGFloat)mk_x
{
    CGRect frame = self.frame;
    frame.origin.x = mk_x;
    self.frame = frame;
}

- (CGFloat)mk_x
{
    return self.frame.origin.x;
}

- (void)setMk_y:(CGFloat)mk_y
{
    CGRect frame = self.frame;
    frame.origin.y = mk_y;
    self.frame = frame;
}

- (CGFloat)mk_y
{
    return self.frame.origin.y;
}

- (void)setMk_width:(CGFloat)mk_w
{
    CGRect frame = self.frame;
    frame.size.width = mk_w;
    self.frame = frame;
}

- (CGFloat)mk_width
{
    return self.frame.size.width;
}

- (void)setMk_height:(CGFloat)mk_h
{
    CGRect frame = self.frame;
    frame.size.height = mk_h;
    self.frame = frame;
}

- (CGFloat)mk_height
{
    return self.frame.size.height;
}

- (CGFloat)mk_left {
    return self.frame.origin.x;
}

- (void)setMk_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)mk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mk_top {
    return self.frame.origin.y;
}

- (void)setMk_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)mk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mk_centerX {
    return self.center.x;
}

- (void)setMk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)mk_centerY {
    return self.center.y;
}

- (void)setMk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


@end

#pragma mark MKRadialGradientLayer

@interface MKRadialGradientLayer : CALayer

@property (nonatomic) CGPoint gradientCenter;

@end

@implementation MKRadialGradientLayer

- (void)drawInContext:(CGContextRef)context {
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    float radius = MIN(self.bounds.size.width , self.bounds.size.height);
    CGContextDrawRadialGradient (context, gradient, self.gradientCenter, 0, self.gradientCenter, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end

#pragma mark MKLoadingHUD

@interface MKLoadingHUD()

@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, weak) UIView *fatherView;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *hudView;           //包含 hudContentView
@property (nonatomic, strong) UIView *hudContentView;    //包含 status && custom

@end

@implementation MKLoadingHUD

#pragma mark Init

+ (MKLoadingHUD *)sharedView {
    static dispatch_once_t once;
    static MKLoadingHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        
        [self resetDefaultConfig];
        
        self.alpha = 0.0f;
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityIdentifier = @"MKLoadingHUD";
        self.accessibilityLabel = @"MKLoadingHUD";
        self.isAccessibilityElement = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"MKLoadingHUD 销毁了");
}

#pragma mark UI - Create

- (UIView*)hudView
{
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.layer.masksToBounds = YES;
    }
    if(!_hudView.superview) {
        [self addSubview:_hudView];
    }
    
    return _hudView;
}

- (UIView *)hudContentView
{
    if (!_hudContentView) {
        _hudContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudContentView.accessibilityIdentifier = @"MKLoadingHUD_hudContent";
        _hudContentView.accessibilityLabel = @"MKLoadingHUD_hudContent";
        _hudContentView.isAccessibilityElement = YES;
    }
    if(!_hudContentView.superview) {
        [self.hudView addSubview:_hudContentView];
    }
    
    return _hudContentView;
}

- (UILabel*)statusLabel
{
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        _statusLabel.accessibilityIdentifier = @"MKLoadingHUD_statusLable";
        _statusLabel.accessibilityLabel = @"MKLoadingHUD_statusLable";
        _statusLabel.isAccessibilityElement = YES;
    }
    if(!_statusLabel.superview) {
        [self.hudContentView addSubview:_statusLabel];
    }
    
    return _statusLabel;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView == customView) {
        return;
    }
    
    [_customView removeFromSuperview];
    _customView = customView;
    if (_customView && !_customView.superview) {
        [self.hudContentView addSubview:self.customView];
    }
}


#pragma mark Process

- (void)showStatus:(NSString*)status andCustomView:(UIView *)view
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if(self){

            self.statusLabel.text = status;
            self.customView = view;
            
            [self updateHUD];
            [self resetDefaultConfig];
        }
    }];
}

- (void)updateHUD
{
    [self updateHUDHierachy];
    [self updateHUDConfig];
    [self updateHUDFrame];
    [self updateHUDMask];
    [self updateHUDUserInteractionEnabled];
    [self showHudWithAnimation];
}

- (void)updateHUDHierachy
{
    if(!self.superview || self.superview != [self lookView]) {
        [self removeFromSuperview];
        [[self lookView] addSubview:self];
        
    } else {
        [self.superview bringSubviewToFront:self];
    }
}

- (UIView *)lookView
{
    if (self.fatherView) {
        return self.fatherView;
    }else{
    
        UIWindow *targetView;
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                targetView = window;
                break;
            }
        }
        return targetView;
    }
}

- (void)updateHUDFrame
{
    CGRect labelRect = CGRectZero;
    
    NSString *statusString = self.statusLabel.text;
    BOOL customViewUsed = (self.customView) && !(self.customView.hidden);
    BOOL statusLableUsed = statusString.length > 0;
    
    if(statusLableUsed) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        CGRect stringRect;
        if([statusString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            stringRect = [statusString boundingRectWithSize:constraintSize
                                              options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{NSFontAttributeName: self.statusLabel.font}
                                              context:NULL];
        } else {
            CGSize stringSize = [statusString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.statusLabel.font.fontName size:self.statusLabel.font.pointSize]}];
            stringRect = CGRectMake(0.0f, 0.0f, stringSize.width, stringSize.height);
        }
        
        labelRect = CGRectMake(0.0f, self.customView.mk_bottom,stringRect.size.width,ceilf(stringRect.size.height));
    }
    
    CGFloat statusTopPadding = statusLableUsed && customViewUsed? MKLoadingHUDCustomPadding * 0.5 : 0;
    CGFloat statusOnlyPadding = statusLableUsed && !customViewUsed ? MKLoadingHUDStatusOnlyPadding * 2 : MKLoadingHUDCustomPadding * 2;
    
    //frame
    self.statusLabel.frame = labelRect;
    self.hudContentView.mk_width = MAX(self.customView.mk_width, self.statusLabel.mk_width);
    self.hudContentView.mk_height = self.customView.mk_height + self.statusLabel.mk_height + statusTopPadding;
    self.hudView.bounds = CGRectMake(0.0f, 0.0f, MAX(self.minimumSize.width,self.hudContentView.mk_width + statusOnlyPadding), MAX(self.minimumSize.height, self.hudContentView.mk_height + statusOnlyPadding));
    
    //x,y
    self.statusLabel.mk_top = self.customView.mk_bottom + statusTopPadding;
    self.customView.mk_centerX = self.hudContentView.mk_width*0.5;
    self.statusLabel.mk_centerX = self.hudContentView.mk_width*0.5;
    self.hudContentView.center = CGPointMake(self.hudView.mk_width * 0.5, self.hudView.mk_height * 0.5);
    self.hudView.center = CGPointMake(self.mk_width*0.5, self.mk_height*0.5);
}

- (void)updateHUDConfig
{
    self.hudView.backgroundColor = self.backgroundColorForStyle;
    self.hudContentView.backgroundColor = self.backgroundColorForStyle;
    self.statusLabel.textColor = self.foregroundColorForStyle;
    self.customView.tintColor = self.customViewTintColor ? self.customViewTintColor : self.customView.tintColor;
    self.hudView.layer.cornerRadius = ceilf(MAX(MIN(_hudView.mk_width, _hudView.mk_height) * MKLoadingHUDRadiusScale, 8.0f));
    self.statusLabel.font = self.statusFont;
}

- (void)updateHUDUserInteractionEnabled
{
    self.userInteractionEnabled = self.defaultMaskType != MKLoadingHUDMaskTypeNone? YES : NO;
}

- (void)showHudWithAnimation
{
    if(self.alpha != 1.0f) {
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        
        [UIView animateWithDuration:MKLoadingHUDAnimationDuration
                              delay:0
                            options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             if(self) {
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3f, 1/1.3f);
                                 self.alpha = 1.0f;
                             }
                         } completion:^(BOOL finished) {

                         }];
        [self setNeedsDisplay];
    }
}

- (void)updateHUDMask
{
    if(self.backgroundLayer) {
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
    }
    switch (self.defaultMaskType) {
        case MKLoadingHUDMaskTypeBlack:{
            
            self.backgroundLayer = [CALayer layer];
            self.backgroundLayer.frame = self.bounds;
            self.backgroundLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            [self.backgroundLayer setNeedsDisplay];
            
            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }
            
        case MKLoadingHUDMaskTypeGradient:{
            MKRadialGradientLayer *layer = [MKRadialGradientLayer layer];
            self.backgroundLayer = layer;
            self.backgroundLayer.frame = self.bounds;
            CGPoint gradientCenter = self.center;
            gradientCenter.y = self.mk_height *0.5;
            layer.gradientCenter = gradientCenter;
            [self.backgroundLayer setNeedsDisplay];
            
            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }
        default:
            break;
    }
}

#pragma mark Setup - Config

- (void)resetDefaultConfig
{
    self.defaultStyle = MKLoadingHUDStyleDark;
    self.defaultMaskType = MKLoadingHUDMaskTypeClear;
    self.statusFont = [UIFont systemFontOfSize:MKLoadingHUDStatusLableFontSize];
    self.minimumSize = CGSizeZero;
    self.customViewTintColor = nil;
    self.fatherView = nil;
}

- (UIColor *)foregroundColorForStyle {
    if(self.defaultStyle == MKLoadingHUDStyleLight) {
        return [UIColor blackColor];
    } else{
        return [UIColor whiteColor];
    }
}

- (UIColor *)backgroundColorForStyle
{
    if(self.defaultStyle == MKLoadingHUDStyleLight) {
        return [UIColor whiteColor];
    } else{
        return [UIColor blackColor];
    }
}

- (void)setFadeOutTimer:(NSTimer*)timer {
    if(_fadeOutTimer) {
        [_fadeOutTimer invalidate], _fadeOutTimer = nil;
    }
    if(timer) {
        _fadeOutTimer = timer;
    }
}

+ (void)setConfig:(void(^)(MKLoadingHUD *hud))configSetup
{
    if (configSetup) {
        configSetup([self sharedView]);
    }
}

#pragma mark Show - Methods

+ (void)showCustomView:(UIView *)customView
{
    [[self sharedView] showStatus:nil andCustomView:customView];
}

+ (void)showCustomView:(UIView *)customView andStatus:(NSString *)status
{
    [[self sharedView] showStatus:status andCustomView:customView];
}

+ (void)showStatus:(NSString *)status andCustomView:(UIView *)customView inView:(UIView *)view
{
    [self setConfig:^(MKLoadingHUD *hud) {
        hud.fatherView = view;
    }];
    [[self sharedView] showStatus:status andCustomView:customView];
}


+ (void)showToast:(NSString *)status
{
    [[self sharedView] showStatus:status andCustomView:nil];
    [self hideDelay:MKLoadingHUDAutoHideDuration];
}

+ (void)showImage:(UIImage *)image
{
    [self showStatus:nil andCustomView:[[UIImageView alloc] initWithImage:image] inView:nil];
    [self hideDelay:MKLoadingHUDAutoHideDuration];
}

+ (void)showToast:(NSString *)status setConfig:(void (^)(MKLoadingHUD *))configSetup
{
    [self setConfig:configSetup];
    [self showToast:status];
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [self setConfig:^(MKLoadingHUD *hud) {
        hud.customViewTintColor = [UIColor whiteColor];
        hud.minimumSize = CGSizeMake(100, 50);
    }];
    [[self sharedView] showStatus:status andCustomView:[[UIImageView alloc]initWithImage:[[UIImage imageNamed:mk_successImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]]];
    [self hideDelay:MKLoadingHUDAutoHideDuration];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [self setConfig:^(MKLoadingHUD *hud) {
        hud.customViewTintColor = [UIColor whiteColor];
        hud.minimumSize = CGSizeMake(100, 50);
    }];
    [[self sharedView] showStatus:status andCustomView:[[UIImageView alloc]initWithImage:[[UIImage imageNamed:mk_errorImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]]];
    [self hideDelay:MKLoadingHUDAutoHideDuration];
}

#pragma mark Hide - Methods

+ (void)hide
{
    [[MKLoadingHUD sharedView] hide];
}

+ (void)hideDelay:(NSTimeInterval)duration
{
    [MKLoadingHUD sharedView].fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:[MKLoadingHUD sharedView] selector:@selector(hide) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:[MKLoadingHUD sharedView].fadeOutTimer forMode:NSRunLoopCommonModes];
}

- (void)hide
{
    [self hideWithDuration:MKLoadingHUDAnimationDuration delay:0];
}

- (void)hideWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    if(self.alpha != 0.0f){
        
        void (^animationsBlock)(void) = ^{
            if(self){
                self.alpha = 0.0f;
                self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
            }
        };
        
        void (^completionBlock)(void) = ^{
            if(self) {
                
                self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3,1/1.3);
                
                [self.customView removeFromSuperview];
                [self.hudView removeFromSuperview];
                [self removeFromSuperview];
                
                UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                if([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                    [rootController setNeedsStatusBarAppearanceUpdate];
                }
            }
        };
        
        if (duration > 0) {
            [UIView animateWithDuration:duration
                                  delay:delay
                                options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                             animations:^{
                                 animationsBlock();
                             } completion:^(BOOL finished) {
                                 completionBlock();
                             }];
        } else {
            animationsBlock();
            completionBlock();
        }
    }
}

@end
