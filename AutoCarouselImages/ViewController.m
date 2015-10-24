//
//  ViewController.m
//  AutoCarouselImages
//
//  Created by long on 15/10/24.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ViewController.h"
#import "AutoCarouselView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageNames = [NSMutableArray array];
    
    NSArray *arr = @[@"http://www0.autoimg.cn/zx/newspic/2015/10/20/640x320_0_2015102023400100502.jpg", @"http://www0.autoimg.cn/zx/newspic/2015/10/23/640x320_0_2015102313241616517.jpg", @"http://www0.autoimg.cn/zx/newspic/2015/10/23/640x320_0_2015102311223147298.jpg", @"http://www0.autoimg.cn/zx/newspic/2015/10/22/640x320_0_2015102218370655334.jpg", @"http://www0.autoimg.cn/zx/newspic/2015/10/24/640x320_0_2015102413173176284.jpg", @"http://www0.autoimg.cn/zx/newspic/2015/10/20/640x320_0_2015102015132381968.jpg"];
    for (NSString *str in arr) {
        [imageNames addObject:[NSURL URLWithString:str]];
    }
    
    //Assets.xcassets中提供了6张图片，显示本地图片的例子不在提供
    
    AutoCarouselView *carouselView = [[AutoCarouselView alloc] initWithFrame:CGRectMake(0, 0, 320, 160) previewMode:AutoCarouseViewModeDefault];
    //显示文本
    NSMutableArray *showTexts = [NSMutableArray arrayWithObjects:@"第一张", @"第二张", @"第三张", @"第四张", @"第五张", @"第六张", nil];
    //点击回调
    [carouselView setCallBackBlock:^(NSString *imageName) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"点击的图片名字:%@", imageName]];
    }];
    //开始轮播图片
    [carouselView startCarouselWithImageArrays:imageNames showTexts:showTexts placeholderImage:[UIImage imageNamed:@"ic_default_photo"] stopDuration:4 scrollDuration:1];
    
    carouselView.center = self.view.center;
    [self.view addSubview:carouselView];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
