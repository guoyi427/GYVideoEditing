//
//  ADVideoPickerCell.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ADVideoPickerCell.h"

@interface ADVideoPickerCell ()
{
    UIImageView *_coverImageView;
}

@end

@implementation ADVideoPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = true;
        [self.contentView addSubview:_coverImageView];
    }
    return self;
}

- (void)update:(UIImage *)coverImage {
    _coverImageView.image = coverImage;
}

@end
