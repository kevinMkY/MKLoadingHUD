//
//  ViewController.m
//  MKLoadingHUD
//
//  Created by ykh on 16/2/22.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "ViewController.h"
#import "MKLoadingHUD.h"
#import "MKLoadingYILogo.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tab1 = [[UITableView alloc] init];
    tab1.frame = self.view.bounds;
    tab1.delegate = self;
    tab1.dataSource = self;
    [self.view addSubview:tab1];
    
    self.array = @[@"show YIDaoLogo",@"show img && 可滚动",@"show Black",@"show garden",@"show toast",@"show success",@"show error",@"show custom && 导航栏可点击"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"113123"]];
    switch (indexPath.row) {
        case 0:
            [MKLoadingHUD setConfig:^(MKLoadingHUD *hud) {
                hud.minimumSize = CGSizeMake(90, 90);
            }];
            [MKLoadingHUD showStatus:@"加载中" andCustomView:[MKLoadingYILogo loadingViewWithAnimating] inView:self.view];;
            [MKLoadingHUD hideDelay:2.0];
            
            break;
        case 1:
            
            [MKLoadingHUD setConfig:^(MKLoadingHUD *hud) {
                hud.defaultMaskType = MKLoadingHUDMaskTypeNone;
            }];
            [MKLoadingHUD showStatus:nil andCustomView:imgv inView:nil];
            [MKLoadingHUD hideDelay:2.0];
            
            break;
            
        case 2:
            
            [MKLoadingHUD setConfig:^(MKLoadingHUD *hud) {
                hud.defaultMaskType = MKLoadingHUDMaskTypeBlack;
                hud.customViewTintColor = [UIColor orangeColor];
            }];
            [MKLoadingHUD showToast:@"阿西吧"];
            [MKLoadingHUD hideDelay:2.0];
            
            break;
            
        case 3:
            
            [MKLoadingHUD setConfig:^(MKLoadingHUD *hud) {
                hud.defaultMaskType = MKLoadingHUDMaskTypeGradient;
            }];
            
            [MKLoadingHUD showSuccessWithStatus:@"哇,渐变色!"];
            
            break;
            
        case 4:
            
            [MKLoadingHUD showToast:@"Hello world! We are 伐木累!"];
            break;
        case 5:
            [MKLoadingHUD showSuccessWithStatus:@"成功了!"];
            break;
        case 6:
            [MKLoadingHUD showErrorWithStatus:@"出错了"];
            break;
        case 7:
            [MKLoadingHUD showStatus:@"111"  andCustomView:imgv inView:self.view];
            break;
        default:
            break;
    }
    
    
}

- (IBAction)left:(id)sender {
    
    NSLog(@"left");
    
}

- (IBAction)right:(id)sender {
    
    [MKLoadingHUD showToast:@"666666"];
    
}

@end
