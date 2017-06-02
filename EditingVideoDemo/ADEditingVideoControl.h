//
//  ADEditingVideoControl.h
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADEditingVideoControl : NSObject

+ (instancetype)sharedInstance;

- (void)showVideoPickerController;

@end
