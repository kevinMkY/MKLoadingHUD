# MKLoadingHUD

我想很多同学和我一样,在手里捏着 MB 和 SV 的好牌,却因为需要高度自定义 UI 而放弃了.
所以,我们需要这款 Loading HUD 来进行深度自定义

效果展示:
![]() 

# 使用方法:
## 导入头文件
```oc
#import "MKLoadingHUD.h"
```

## 显示 HUD
----
普通的 HUD
```oc
//以下三个方法,2.0 秒后自动隐藏
+ (void)showToast:(NSString *)status;
+ (void)showImage:(UIImage *)image;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status;
```
----
自定义的 HUD,需要手动 `+hide`
```oc
+ (void)showCustomView:(UIView *)customView;
+ (void)showCustomView:(UIView *)customView andStatus:(NSString *)status;
+ (void)showStatus:(NSString *)status andCustomView:(UIView *)customView inView:(UIView *)view;

+ (void)hide;
+ (void)hideDelay:(NSTimeInterval)seconds;
```

----
自定义的代码先用`+setConfig`,再调喜欢的`+show`方法就可以了
```oc
[MKLoadingHUD setConfig:^(MKLoadingHUD *hud) {
  hud.defaultMaskType = MKLoadingHUDMaskTypeGradient;
}];

[MKLoadingHUD showSuccessWithStatus:@"哇,渐变色!"];
```

----
目前支持的自定义属性如下:
```oc
minimumSize - 限制 HUD 的最小显示尺寸
statusFont  - HUD 的文字 font
customViewTintColor - HUD 的自定义 view 的 tintclor

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
```

# 后续会不断添加新的动画效果,希望同各位多交流

PS:素材来自网络,此处谨做学习使用,如有侵权,请告知我,我会尽快删除~
