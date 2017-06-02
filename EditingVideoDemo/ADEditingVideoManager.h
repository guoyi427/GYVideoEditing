//
//  ADEditingVideoManager.h
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 视频截图的时间长度
static CGFloat ADVideoFragmentDuration = 1;
/// 最小时间间隔  单位：秒
static CGFloat ADVideoMinDuration = 3;
/// 最大时间间隔  单位：秒
static CGFloat ADVideoMaxDuration = 10;

@interface ADEditingVideoManager : NSObject

+ (instancetype)sharedInstance;

/**
 计算视频长度

 @param videoURL 视频本地url
 @return 视频长度
 */
- (CGFloat)calculateVideoDuration:(NSURL *)videoURL;

/**
 计算视频截图个数，固定单个片段时间(ADVideoFragmentDuration)

 @param videoURL 视频本地url
 @return 视频截图个数
 */
- (NSInteger)calculateVideoFramgentCount:(NSURL *)videoURL;

/**
 获取视频片段的截图

 @param videoURL 视频本地url
 @param index 视频截图的下表，按固定片段时间(ADVideoFragmentDuration)划分片段
 @param complete 完成回调
 */
- (void)videoFragmentCoverImageWithURL:(NSURL *)videoURL andIndex:(NSInteger)index complete:(void (^)(UIImage *result, NSInteger index))complete;

@end
