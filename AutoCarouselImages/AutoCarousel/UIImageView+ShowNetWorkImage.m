//
//  UIImageView+ShowNetWorkImage.m
//  AutoCarouselImages
//
//  Created by long on 15/10/24.
//  Copyright © 2015年 long. All rights reserved.
//

#import "UIImageView+ShowNetWorkImage.h"

@implementation UIImageView (ShowNetWorkImage)

- (void)showNetWorkImageWithURL:(NSURL *)url placehodlerImage:(UIImage *)image
{
    self.image = image;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            UIImage *im = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = im;
            });
        }
    }];
    [dataTask resume];
}

@end
