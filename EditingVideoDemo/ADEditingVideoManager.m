//
//  ADEditingVideoManager.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//
//  所有剪辑视频的数据管理

#import "ADEditingVideoManager.h"

#import <AVFoundation/AVFoundation.h>

@implementation ADEditingVideoManager

+ (instancetype)sharedInstance {
    static ADEditingVideoManager *m_editingVideo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_editingVideo = [[ADEditingVideoManager alloc] init];
    });
    return m_editingVideo;
}

#pragma mark - Public Methods

/**
 计算视频长度
 
 @param videoURL 视频本地url
 @return 视频长度
 */
- (CGFloat)calculateVideoDuration:(NSURL *)videoURL {
    if (!videoURL) {
        return 0;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    if (!asset) {
        return 0;
    }
    
    return asset.duration.value / asset.duration.timescale; // CMTime 为了保持精度， 用整形结构体保存浮点型，使用时用 value / timescale
}

/**
 计算视频截图个数，固定单个片段时间(ADVideoFragmentDuration)
 
 @param videoURL 视频本地url
 @return 视频截图个数
 */
- (NSInteger)calculateVideoFramgentCount:(NSURL *)videoURL {
    CGFloat videoDuration = [self calculateVideoDuration:videoURL];
    
    return videoDuration / ADVideoFragmentDuration;
}

/**
 获取视频片段的截图
 
 @param videoURL 视频本地url
 @param index 视频截图的下表，按固定片段时间(ADVideoFragmentDuration)划分片段
 @param complete 完成回调
 */
- (void)videoFragmentCoverImageWithURL:(NSURL *)videoURL andIndex:(NSInteger)index complete:(void (^)(UIImage *, NSInteger))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
        if (!asset) {
            return;
        }
        
        CGFloat duration = asset.duration.value / asset.duration.timescale;
        
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.appliesPreferredTrackTransform = true;
        imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        imageGenerator.maximumSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/10.0, 75);

        //  截取时间
        CMTime fragmentTime = kCMTimeZero;
        if (duration <= ADVideoMaxDuration) {
            fragmentTime = CMTimeMake(index * duration / ADVideoMaxDuration, 1);
        } else {
            fragmentTime = CMTimeMake(index * ADVideoFragmentDuration, 1);
        }
        
        //  按时间截图图片
        CGImageRef coverImageRef = [imageGenerator copyCGImageAtTime:fragmentTime actualTime:nil error:nil];
        
        UIImage *resultImage = [UIImage imageWithCGImage:coverImageRef];
        
        CGImageRelease(coverImageRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(resultImage, index);
        });
    });
    
}

@end
