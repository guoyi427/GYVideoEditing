//
//  ViewController.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ViewController.h"

#import "ADEditingVideoControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = CGRectMake(10, 100, 50, 30);
    pBtn.backgroundColor = [UIColor redColor];
    [pBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAction {
    [[ADEditingVideoControl sharedInstance] showVideoPickerController];
}

@end
