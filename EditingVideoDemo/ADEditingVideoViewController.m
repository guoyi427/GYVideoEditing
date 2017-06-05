//
//  ADEditingVideoViewController.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ADEditingVideoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "ADVideoSliderView.h"

@interface ADEditingVideoViewController () <ADVideoSliderViewDelegate>
{
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
    
    ADVideoSliderView *_sliderView;
    
    UILabel *_startTimeLabel;
    UILabel *_endTimeLabel;
    
    
    CGFloat _startTime;
    CGFloat _endTime;
    
    NSTimer *_endTimer;
    
}
@end

@implementation ADEditingVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self _preparePlayerView];
    [self _prepareStartEndLabel];
    [self _prepareSliderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    [_player pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Prepare

/**
 准备播放器视图
 */
- (void)_preparePlayerView {
    _player = [AVPlayer playerWithURL:_url];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    CGFloat width = CGRectGetWidth(self.view.bounds) - 140;
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds) / CGRectGetWidth([UIScreen mainScreen].bounds) * width;
    _playerLayer.frame = CGRectMake(70, 64, CGRectGetWidth(self.view.bounds) - 140, height);
    [self.view.layer addSublayer:_playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinishedNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/**
 准备滑块视图
 */
- (void)_prepareSliderView {
    self.automaticallyAdjustsScrollViewInsets = false;
    _sliderView = [[ADVideoSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerLayer.frame) + 60,
                                                                      CGRectGetWidth(self.view.bounds), 75)];
    _sliderView.delegate = self;
    [self.view addSubview:_sliderView];
    [_sliderView updateWithVideoURL:_url];
    [self _playVideo];
}


- (void)_prepareStartEndLabel {
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(self.view.bounds) - 50, 30, 20)];
    _startTimeLabel.font = [UIFont systemFontOfSize:13];
    _startTimeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_startTimeLabel];
    
    _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 30 - 30, CGRectGetMinY(_startTimeLabel.frame), 30, 20)];
    _endTimeLabel.font = _startTimeLabel.font;
    _endTimeLabel.textColor = _startTimeLabel.textColor;
    [self.view addSubview:_endTimeLabel];
}

#pragma mark - Private - Methods

- (void)_updateStartEndLabel {
    _startTimeLabel.text = [NSString stringWithFormat:@"%.1f", _startTime];
    _endTimeLabel.text = [NSString stringWithFormat:@"%.1f", _endTime];
}

- (void)_playVideo {
    [_player pause];
//    _player = nil;
//    _player = [AVPlayer playerWithURL:_url];
//    _playerLayer.player = _player;
    
    [_player seekToTime:CMTimeMake(_startTime, 1)];
    [_player play];
    CGFloat duration = _endTime - _startTime;

    
    if (_endTimer) {
        [_endTimer invalidate];
    }
    _endTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(_stopVideo) userInfo:nil repeats:false];
}

- (void)_stopVideo {
    [self _playVideo];
}

#pragma mark - VideoSliderView - Delegate

- (void)videoSliderView:(ADVideoSliderView *)view updateStartTime:(CGFloat)startTime endTime:(CGFloat)endTime {
    _startTime = startTime;
    _endTime = endTime;
    [self _updateStartEndLabel];
}

- (void)videoSliderViewDidUpdateTime:(ADVideoSliderView *)view {
   
    [self _playVideo];
}

#pragma mark - Notification Center - Action

- (void)playDidFinishedNotification {
    if (_player.timeControlStatus != AVPlayerTimeControlStatusPlaying) {

    }
}

@end
