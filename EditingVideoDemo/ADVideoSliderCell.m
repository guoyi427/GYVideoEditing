//
//  ADVideoSliderCell.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ADVideoSliderCell.h"

#import "ADEditingVideoManager.h"

@interface ADVideoSliderCell ()
{
    UIImageView *_coverImageView;
}
@end

@implementation ADVideoSliderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = true;
        [self.contentView addSubview:_coverImageView];
    }
    return self;
}

- (void)updateWithIndexPath:(NSIndexPath *)indexPath andVideoURL:(NSURL *)videoURL {
    NSInteger row = indexPath.row;
    [[ADEditingVideoManager sharedInstance] videoFragmentCoverImageWithURL:videoURL andIndex:indexPath.row complete:^(UIImage *result, NSInteger index) {
        if (index == row) {
            [UIView transitionWithView:_coverImageView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _coverImageView.image = result;
            } completion:nil];
        }
    }];
}

@end
