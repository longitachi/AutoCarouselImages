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

####默认样式效果图
![image](https://github.com/longitachi/AutoCarouselImages/blob/master/效果图/默认样式.gif)
####带文本的效果图
![image](https://github.com/longitachi/AutoCarouselImages/blob/master/效果图/带文本样式.gif)
