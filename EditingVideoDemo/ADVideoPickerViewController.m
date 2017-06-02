//
//  ADVideoPickerViewController.m
//  EditingVideoDemo
//
//  Created by kokozu on 2017/5/31.
//  Copyright © 2017年 guoyi. All rights reserved.
//

#import "ADVideoPickerViewController.h"

#import "ADVideoPickerCell.h"
#import <Photos/Photos.h>
#import "ADEditingVideoViewController.h"

@interface ADVideoPickerViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    
    //  Data
    PHFetchResult<PHAsset *> *_videoAssetList;
}
@end

static NSString *Identifier_Cell = @"video_picker_cell";

@implementation ADVideoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width / 3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(photoWidth, photoWidth);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ADVideoPickerCell class] forCellWithReuseIdentifier:Identifier_Cell];
    [self.view addSubview:_collectionView];
    
    [self _prepareData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    
    _videoAssetList = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    
    [_collectionView reloadData];
}

#pragma mark - Button - Action

- (void)leftBarButtonAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - CollectionView - Datasource & Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADVideoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier_Cell forIndexPath:indexPath];
    
    if (_videoAssetList.count > indexPath.row) {
        PHAsset *videoAsset = [_videoAssetList objectAtIndex:indexPath.row];
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:videoAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *coverImage = [UIImage imageWithData:imageData];
            [cell update:coverImage];
        }];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videoAssetList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_videoAssetList.count > indexPath.row) {
        PHAsset *videoAsset = [_videoAssetList objectAtIndex:indexPath.row];
        [[PHCachingImageManager defaultManager] requestAVAssetForVideo:videoAsset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSURL *videoURL = ((AVURLAsset *)asset).URL;
            ADEditingVideoViewController *editingController = [[ADEditingVideoViewController alloc] init];
            editingController.url = videoURL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:editingController animated:true];
            });
        }];
    }
}

@end
