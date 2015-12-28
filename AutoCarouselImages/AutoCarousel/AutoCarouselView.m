//
//  AutoCarouselView.m
//  AutoCarouselImages
//
//  Created by long on 15/10/24.
//  Copyright © 2015年 long. All rights reserved.
//

#import "AutoCarouselView.h"
#import "UIImageView+ShowNetWorkImage.h"

#define kWidth          self.frame.size.width
#define kHeight         self.frame.size.height
#define kImageView_tag  100

@interface AutoCarouselView () <UIScrollViewDelegate>
{
    AutoCarouseViewMode _mode;
    NSTimer *_timer;
}

@end

@implementation AutoCarouselView

- (instancetype)initWithFrame:(CGRect)frame previewMode:(AutoCarouseViewMode)mode
{
    if (mode == AutoCarouseViewModeDefault) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AutoCarouselViewModeDefault" owner:self options:nil] lastObject];
    } else if (mode == AutoCarouseViewModeText) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AutoCarouselViewModeText" owner:self options:nil] lastObject];
    }
    
    if (self) {
        self.frame = frame;
        //打开用户交互权限
        self.userInteractionEnabled = YES;
        self.scrollDuration = .0;
        self.stopDuration = .0;
        _mode = mode;
        self.textBgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    }
    return self;
}

- (void)startCarouselWithImageArrays:(NSMutableArray *)imageArray showTexts:(NSMutableArray *)showTexts placeholderImage:(UIImage *)placeholderImage stopDuration:(NSTimeInterval)stopDuraiton scrollDuration:(NSTimeInterval)scrollDuration
{
    if (_mode == AutoCarouseViewModeText && showTexts.count > 0) {
        NSAssert(imageArray.count == showTexts.count, @"显示文本模式下，图片数量必须和文本数量相同");
    }
    
    self.dataSources = imageArray;
    self.showTexts = showTexts;
    self.placeholderImage = placeholderImage;
    self.stopDuration = stopDuraiton;
    self.scrollDuration = scrollDuration;
    
    [self ProcessingDataSources];
    
    if (self.dataSources.count > 1) {
        self.scrollView.contentSize = CGSizeMake(kWidth * self.dataSources.count, kHeight);
        self.pageController.numberOfPages = self.dataSources.count - 2;
        
        for (int i = 0; i < self.dataSources.count; i++) {
            [self.scrollView addSubview:[self getImageView:self.dataSources[i] index:i]];
        }
        
        if (_mode == AutoCarouseViewModeText) {
            self.labText.text = self.showTexts[1];
        }
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
        //启动定时器
        [self startTimer];
    } else {
        self.pageController.numberOfPages = 1;
        [self.scrollView addSubview:[self getImageView:self.dataSources[0] index:0]];
        if (_mode == AutoCarouseViewModeText) {
            self.labText.text = self.showTexts[0];
        }
    }
    
    self.pageController.currentPage = 0;
}

#pragma mark - private
#pragma mark - 处理数据
- (void)ProcessingDataSources
{
    if (self.dataSources.count > 1) {
        [self addObjInArray:self.dataSources];
    }
    if (self.showTexts.count > 1) {
        [self addObjInArray:self.showTexts];
    }
}

- (void)addObjInArray:(NSMutableArray *)arr
{
    id first = [arr firstObject];
    id last = [arr lastObject];
    [arr insertObject:last atIndex:0];
    [arr addObject:first];
}

- (UIImageView *)getImageView:(NSString *)imageName index:(int)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*kWidth, 0, kWidth, kHeight)];
    imageView.tag = kImageView_tag + index;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    if ([self.dataSources[index] isKindOfClass:[NSString class]]) {
        imageView.image = [UIImage imageNamed:self.dataSources[index]];
    } else {
        [imageView showNetWorkImageWithURL:self.dataSources[index] placehodlerImage:self.placeholderImage];
    }
    [self addGestureRecognizerOnImageView:imageView];
    return imageView;
}

- (void)addGestureRecognizerOnImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImageView *im = (UIImageView *)tap.view;
    if (self.CallBackBlock) {
        id obj = self.dataSources[im.tag - kImageView_tag];
        if ([obj isKindOfClass:[NSString class]]) {
            self.CallBackBlock(obj);
        } else {
            self.CallBackBlock([(NSURL *)obj absoluteString]);
        }
    }
}

#pragma mark - 启动定时器
- (void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:self.stopDuration>0?self.stopDuration:kDefaultStopDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction:(NSTimer *)timer
{
    CGPoint currentOffset = self.scrollView.contentOffset;
    NSInteger currentPage = currentOffset.x / kWidth;
    
    CGFloat animationDuraiton = self.scrollDuration > 0 ? self.scrollDuration : kDefaultScrollDuration;
    
    if (currentPage == self.dataSources.count - 2) {
        //当将要到最后一页时  需要在动画完成后 返回第一张
        [UIView animateWithDuration:animationDuraiton animations:^{
            [_scrollView setContentOffset:CGPointMake((self.dataSources.count-1)*kWidth, 0)];
            self.pageController.currentPage = 0;
        } completion:^(BOOL finished) {
            [_scrollView setContentOffset:CGPointMake(kWidth, 0)];
            if (_mode == AutoCarouseViewModeText) {
                self.labText.text = self.showTexts[1];
            }
        }];
    } else {
        [UIView animateWithDuration:animationDuraiton animations:^{
            self.pageController.currentPage = currentPage;
            [_scrollView setContentOffset:CGPointMake((currentPage+1)*kWidth, 0)];
        } completion:^(BOOL finished) {
            if (_mode == AutoCarouseViewModeText) {
                self.labText.text = self.showTexts[currentPage + 1];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffset = self.scrollView.contentOffset;
    NSInteger currentPage = currentOffset.x / kWidth;
    
    self.pageController.currentPage = currentPage - 1;
    if (_mode == AutoCarouseViewModeText) {
        self.labText.text = self.showTexts[currentPage];
    }
    
    if (currentPage == self.dataSources.count - 1) {
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
        self.pageController.currentPage = 0;
        if (_mode == AutoCarouseViewModeText) {
            self.labText.text = self.showTexts[1];
        }
    }
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((self.dataSources.count-2)*kWidth, 0)];
        self.pageController.currentPage = self.dataSources.count - 2;
        if (_mode == AutoCarouseViewModeText) {
            self.labText.text = self.showTexts[self.showTexts.count - 1];
        }
    }
}

@end
