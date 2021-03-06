//
//  TemplateViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/6.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "TemplateViewController.h"
#import "GaussianBlurViewController.h"
#import "SquareViewController.h"
#import "MaskLayerViewController.h"
#import "CustomViewController.h"
#import "QMUICollectionViewPagingLayout.h"
#import "QDCollectionViewDemoCell.h"
#import "LDImagePicker.h"

@interface TemplateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LDImagePickerDelegate>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) QMUICollectionViewPagingLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *sampleArray;
@property (nonatomic, assign) NSInteger selectItem;

@end

@implementation TemplateViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleRotation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"模板选择";
    [self setupCollectionView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!CGSizeEqualToSize(self.collectionView.bounds.size, self.view.bounds.size))
    {
        self.collectionView.frame = self.view.bounds;
        self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(36, 36, 36, 36);
        [self.collectionViewLayout invalidateLayout];
    }
}

- (void)setupCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QDCollectionViewDemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(36, 36, 36, 36);
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sampleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.sampleImage = self.sampleArray[indexPath.item];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.item == 0 || indexPath.item == 2)
    {
        _selectItem = indexPath.item;
        LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
        imagePicker.delegate = self;
        CGFloat height = (indexPath.item == 0) ? 260 : IPhoneHeight;
        [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:self cropSize:CGSizeMake(IPhoneWidth, height)];
    }
    else if (indexPath.item == 1)
    {
        SquareViewController *vc = [[SquareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 3)
    {
        CustomViewController *vc = [[CustomViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - LDImagePickerDelegate
- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage
{
    if (_selectItem == 0)
    {
        GaussianBlurViewController *vc = [[GaussianBlurViewController alloc] initWithImage:editedImage];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        MaskLayerViewController *vc = [[MaskLayerViewController alloc] initWithImage:editedImage];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)sampleArray
{
    if (!_sampleArray)
    {
        _sampleArray = @[@"Sample1", @"Sample2", @"Sample3", @"Sample4"];
    }
    return _sampleArray;
}
@end
