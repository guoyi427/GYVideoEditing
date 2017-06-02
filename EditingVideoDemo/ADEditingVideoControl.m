//
//  ADEditingVideoControl.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/6/1.
//  Copyright © 2017年 guoyi. All rights reserved.
//
//  所有剪辑视频的视图控制器管理

#import "ADEditingVideoControl.h"

#import "ADVideoPickerViewController.h"

@implementation ADEditingVideoControl

+ (instancetype)sharedInstance {
    static ADEditingVideoControl *c_editingVideo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        c_editingVideo = [[ADEditingVideoControl alloc] init];
    });
    return c_editingVideo;
}

#pragma mark - Public Methods

- (void)showVideoPickerController {
    ADVideoPickerViewController *pickerController = [[ADVideoPickerViewController alloc] init];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:pickerController];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviController animated:true completion:nil];
}

@end
