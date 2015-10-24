# AutoCarouselImages

####使用方法
```objc
AutoCarouselView *carouselView = [[AutoCarouselView alloc] initWithFrame:CGRectMake(0, 0, 320, 160) previewMode:AutoCarouseViewModeDefault];
    //显示文本
    //点击回调
    [carouselView setCallBackBlock:^(NSString *imageName) {
        //点击回调
    }];
    //开始轮播图片
    [carouselView startCarouselWithImageArrays:imageNames showTexts:showTexts placeholderImage:placeholderImage stopDuration:4 scrollDuration:1];
    [self.view addSubview:carouselView];
```

####效果图
![image]()
