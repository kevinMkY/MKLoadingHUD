//
//  MKLoadingHUD.h
//  MKLoadingHUD
//
//  Created by ykh on 16/2/22.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MKLoadingHUDStyle) {
    /// 白底黑字
    MKLoadingHUDStyleLight,
    /// 黑底白字
    MKLoadingHUDStyleDark,
};

typedef NS_ENUM(NSUInteger, MKLoadingHUDMaskType) {
    /// 背景透明,允许事件穿透
    MKLoadingHUDMaskTypeNone = 1,
    /// 背景透明,不允许事件穿透
    MKLoadingHUDMaskTypeClear,
    /// 背景半黑,不允许事件穿透
    MKLoadingHUDMaskTypeBlack,
    /// 背景渐变,不允许事件穿透
    MKLoadingHUDMaskTypeGradient
};
@interface MKLoadingHUD : UIImageView

#pragma mark custom - property

@property (nonatomic, assign) CGSize minimumSize;
@property (nonatomic, assign) UIFont *statusFont;
@property (nonatomic, strong) UIColor *customViewTintColor;             

@property (nonatomic, assign) MKLoadingHUDStyle defaultStyle;           //默认是:MKLoadingHUDStyleDark
@property (nonatomic, assign) MKLoadingHUDMaskType defaultMaskType;     //默认是:MKLoadingHUDMaskTypeClear

/// 在 block 内自定义属性,在后面接着调用 show 方法即可,生效一次
+ (void)setConfig:(void(^)(MKLoadingHUD *hud))configSetup;

#pragma mark Show - Methods

//需要手动 隐藏
+ (void)showCustomView:(UIView *)customView;
+ (void)showCustomView:(UIView *)customView andStatus:(NSString *)status;
+ (void)showStatus:(NSString *)status andCustomView:(UIView *)customView inView:(UIView *)view;

//以下三个方法,2.0 秒后自动隐藏
+ (void)showToast:(NSString *)status;
+ (void)showImage:(UIImage *)image;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status;

+ (void)hide;
+ (void)hideDelay:(NSTimeInterval)seconds;

@end
