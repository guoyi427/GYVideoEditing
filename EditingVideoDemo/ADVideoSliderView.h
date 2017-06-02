//
//  ADVideoSliderView.h
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADVideoSliderView;
@protocol ADVideoSliderViewDelegate <NSObject>

@optional
/**
 更新 开始和结束时间
 
 @param view 滑块视图
 @param startTime 开始时间
 @param endTime 结束时间
 */
- (void)videoSliderView:(ADVideoSliderView *)view updateStartTime:(CGFloat)startTime endTime:(CGFloat)endTime;

/**
 结束更新，通常需要在这个代理播放视频

 @param view 滑动视图
 */
- (void)videoSliderViewDidUpdateTime:(ADVideoSliderView *)view;

@end

@interface ADVideoSliderView : UIView

@property (nonatomic, weak) id<ADVideoSliderViewDelegate> delegate;

- (void)updateWithVideoURL:(NSURL *)videoURL;

@end
