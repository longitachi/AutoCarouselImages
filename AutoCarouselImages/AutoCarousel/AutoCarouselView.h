//
//  AutoCarouselView.h
//  AutoCarouselImages
//
//  Created by long on 15/10/24.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultStopDuration   4.0f
#define kDefaultScrollDuration 1.0f

typedef NS_ENUM(NSInteger, AutoCarouseViewMode) {
    //默认样式
    AutoCarouseViewModeDefault,
    //底部带部分文字的样式
    AutoCarouseViewModeText
};

@interface AutoCarouselView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UILabel *labText;
@property (nonatomic, assign) AutoCarouseViewMode carouseMode;
//默认占位图片
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 * 若要轮播本地图片，则数据源内为本地图片名字
 * 若要轮播网络图片，则数据源内为该图片的网络URL
 * (支持混合播放)
 */
@property (nonatomic, strong) NSMutableArray *dataSources;

/**
 * AutoCarouseViewModeText模式下，每个图片下方所显示的文本信息，数量必须和要显示的图片数量一致
 */
@property (nonatomic, strong) NSMutableArray *showTexts;

//每张图片所停留的时间
@property (nonatomic, assign) CGFloat stopDuration;
//每次滚动所需时间
@property (nonatomic, assign) CGFloat scrollDuration;
//回调
@property (nonatomic, copy) void (^CallBackBlock)(NSString *);


/**
 * @brief 初始化轮播图片控件
 */
- (instancetype)initWithFrame:(CGRect)frame previewMode:(AutoCarouseViewMode)mode;

/**
 * @brief 开始播放
 * @param imageArray        需要显示的图片数组，若要轮播本地图片，则数据源内为本地图片名字   若要轮播网络图片，则数据源内为该图片的网络URL
 * @param showTexts         需要显示的文本数组，mode为AutoCarouseViewModeText时候会显示
 * @param placeholderImage  占位图片
 * @param stopDuraiton      每张图片显示时间
 * @param scrollDuration    图片之间切换所需时间
 */
- (void)startCarouselWithImageArrays:(NSMutableArray *)imageArray
                           showTexts:(NSMutableArray *)showTexts
                    placeholderImage:(UIImage *)placeholderImage
                        stopDuration:(NSTimeInterval)stopDuraiton
                      scrollDuration:(NSTimeInterval)scrollDuration;

@end
