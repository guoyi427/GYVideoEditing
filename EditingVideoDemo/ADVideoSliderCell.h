//
//  ADVideoSliderCell.h
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADVideoSliderCell : UICollectionViewCell

- (void)updateWithIndexPath:(NSIndexPath *)indexPath andVideoURL:(NSURL *)videoURL;

@end
