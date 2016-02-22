//
//  MKLoadingHUD.h
//  testMBProgressHUD
//
//  Created by ykh on 15/9/21.
//  Copyright (c) 2015年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MKUIViewFrame.h"

@interface MKLoadingYILogo : UIView

+(instancetype)loadingView;
+(instancetype)loadingViewWithAnimating;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
