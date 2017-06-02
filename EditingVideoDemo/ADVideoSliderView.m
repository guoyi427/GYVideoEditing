//
//  ADVideoSliderView.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ADVideoSliderView.h"

#import "ADVideoSliderCell.h"
#import "ADEditingVideoManager.h"

@interface ADVideoSliderView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    //  UI
    UICollectionView *_fragmentView;
    UIImageView *_leftSliderView;
    UIImageView *_rightSliderView;
    
    
    //  Data
    NSInteger _fragmentCount;
    
    NSURL *_videoAssetURL;
    
    CGFloat _startTime;
    CGFloat _endTime;
    CGFloat _videoDuration;
}
@end

static NSString *Identifier_Cell = @"fragment_cell";
/// 滑块宽度
static CGFloat Slider_Width = 20;
static CGFloat Slider_Padding = 30;

@implementation ADVideoSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _prepareFragmentView];
        [self _prepareSliderView];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareFragmentView {
    
    CGFloat cellHeight = CGRectGetHeight(self.frame) - 30;
    CGFloat cellWidth = (CGRectGetWidth(self.frame) - Slider_Padding * 2) / 10.0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _fragmentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), cellHeight) collectionViewLayout:flowLayout];
    _fragmentView.backgroundColor = [UIColor whiteColor];
    _fragmentView.delegate = self;
    _fragmentView.dataSource = self;
    _fragmentView.contentInset = UIEdgeInsetsMake(0, Slider_Padding, 0, Slider_Padding);
    [_fragmentView registerClass:[ADVideoSliderCell class] forCellWithReuseIdentifier:Identifier_Cell];
    _fragmentView.showsHorizontalScrollIndicator = false;
    [self addSubview:_fragmentView];
    
    UIView *leftShadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Slider_Padding, cellHeight)];
    leftShadeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    leftShadeView.userInteractionEnabled = true;
    [self addSubview:leftShadeView];
    
    UIView *rightShadeView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - Slider_Padding, 0, Slider_Padding, cellHeight)];
    rightShadeView.backgroundColor = leftShadeView.backgroundColor;
    rightShadeView.userInteractionEnabled = true;
    [self addSubview:rightShadeView];
}

- (void)_prepareSliderView {
    _leftSliderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Slider_Width, CGRectGetHeight(self.frame))];
    _leftSliderView.backgroundColor = [UIColor yellowColor];
    _leftSliderView.userInteractionEnabled = true;
    [self _updateSliderView:_leftSliderView centerX:CGRectGetWidth(_leftSliderView.frame)/2 + Slider_Width];
    [self addSubview:_leftSliderView];
    
    _rightSliderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Slider_Width, CGRectGetHeight(self.frame))];
    _rightSliderView.backgroundColor = [UIColor redColor];
    _rightSliderView.userInteractionEnabled = true;
    [self _updateSliderView:_rightSliderView centerX:CGRectGetWidth(self.frame) - Slider_Width - CGRectGetWidth(_rightSliderView.frame)/2];
    [self addSubview:_rightSliderView];
}

#pragma mark - Private - Methods

- (void)_updateSliderView:(UIView *)sliderView centerX:(CGFloat)x {
    sliderView.center = CGPointMake(x, sliderView.center.y);
}

#pragma mark - Public - Methods

- (void)updateWithVideoURL:(NSURL *)videoURL {
    _videoAssetURL = videoURL;
    
    //  计算视频总长度，用户计算 startTime 和 endTime
    _videoDuration = [[ADEditingVideoManager sharedInstance] calculateVideoDuration:_videoAssetURL];
    
    //  片段个数，用来计算collectionView的数据占位个数
    _fragmentCount = _videoDuration < ADVideoMaxDuration ? ADVideoMaxDuration : [[ADEditingVideoManager sharedInstance] calculateVideoFramgentCount:videoURL];
    
    [_fragmentView reloadData];
    
    //  初始化 startTime
    _startTime = 0;
    //  初始化 endTime
    _endTime = _videoDuration < ADVideoMaxDuration ? _videoDuration : ADVideoMaxDuration;
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderView:updateStartTime:endTime:)]) {
        [_delegate videoSliderView:self updateStartTime:_startTime endTime:_endTime];
    }
}

#pragma mark - CollectoinView - Delegate & Datasoucre

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADVideoSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier_Cell forIndexPath:indexPath];
    
    [cell updateWithIndexPath:indexPath andVideoURL:_videoAssetURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fragmentCount;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _fragmentView) {
        _startTime = (_leftSliderView.center.x + _fragmentView.contentOffset.x) / _fragmentView.contentSize.width * _videoDuration;
        _endTime = (_rightSliderView.center.x + _fragmentView.contentOffset.x) / _fragmentView.contentSize.width * _videoDuration;
        if (_delegate && [_delegate respondsToSelector:@selector(videoSliderView:updateStartTime:endTime:)]) {
            [_delegate videoSliderView:self updateStartTime:_startTime endTime:_endTime];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _fragmentView) {
        if (_delegate && [_delegate respondsToSelector:@selector(videoSliderViewDidUpdateTime:)]) {
            [_delegate videoSliderViewDidUpdateTime:self];
        }
    }
}

#pragma mark - Touch - Action

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchView = touches.anyObject.view;
    if (touchView == _leftSliderView || touchView == _rightSliderView) {
        CGPoint touchPoint = [touches.anyObject locationInView:self];
        
        CGFloat point_x = touchPoint.x;
        
        if (touchView == _leftSliderView) {
            //  最小位置 不能小于屏幕左边
            point_x = point_x < Slider_Padding ? Slider_Padding : point_x;
            _startTime = (point_x + _fragmentView.contentOffset.x) / _fragmentView.contentSize.width * _videoDuration;
            //  startTime 不能大于 endTime - 最小时间间隔
            if (_endTime - _startTime < ADVideoMinDuration) {
                _startTime = _endTime - ADVideoMinDuration;
                //  contentSize.width / videoDuration = 每秒多少像素， 再乘以结束时间减最小间隔时间，就是最大开始时间
                point_x = (_fragmentView.contentSize.width) / _videoDuration * (_endTime - ADVideoMinDuration) - _fragmentView.contentOffset.x;
            }
        } else if (touchView == _rightSliderView) {
            //  最大位置 不能大于屏幕右边
            point_x = point_x > CGRectGetWidth(self.frame) - Slider_Padding ? CGRectGetWidth(self.frame) - Slider_Padding : point_x;
            _endTime = (point_x + _fragmentView.contentOffset.x) / _fragmentView.contentSize.width * _videoDuration;
            // endTime 不能小于 start + 最小时间间隔
            if (_startTime + ADVideoMinDuration > _endTime) {
                _endTime = _startTime + ADVideoMinDuration;
                //  contentSize.width / videoDuration = 每秒多少像素，再乘以开始时间加上最短时间间隔，就是最小结束时间
                point_x = (_fragmentView.contentSize.width) / _videoDuration * (_startTime + ADVideoMinDuration) - _fragmentView.contentOffset.x;
            }
        }
        [self _updateSliderView:touchView centerX:point_x];
        
        if (_delegate && [_delegate respondsToSelector:@selector(videoSliderView:updateStartTime:endTime:)]) {
            [_delegate videoSliderView:self updateStartTime:_startTime endTime:_endTime];
        }
        
        NSLog(@"start time = %f, end time = %f", _startTime, _endTime);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.anyObject.view == _leftSliderView || touches.anyObject.view == _rightSliderView) {
        if (_delegate && [_delegate respondsToSelector:@selector(videoSliderViewDidUpdateTime:)]) {
            [_delegate videoSliderViewDidUpdateTime:self];
        }
    }
}

@end
