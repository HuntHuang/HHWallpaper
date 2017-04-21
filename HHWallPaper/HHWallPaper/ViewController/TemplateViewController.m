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
#import "QMUICollectionViewPagingLayout.h"
#import "QDCollectionViewDemoCell.h"

@interface TemplateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
        UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
        pickCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickCtl.delegate = self;
        [self presentViewController:pickCtl animated:YES completion:nil];
    }
    else if (indexPath.item == 1)
    {
        SquareViewController *vc = [[SquareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    UIImage *mainImage = [UIImage imageWithData:data];
    if (_selectItem == 0)
    {
        if (mainImage.size.height > mainImage.size.width)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择横向图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        GaussianBlurViewController *vc = [[GaussianBlurViewController alloc] initWithImage:mainImage];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (mainImage.size.height < mainImage.size.width)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择纵向图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        MaskLayerViewController *vc = [[MaskLayerViewController alloc] initWithImage:mainImage];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)sampleArray
{
    if (!_sampleArray)
    {
        _sampleArray = @[@"Sample1", @"Sample2", @"Sample3"];
    }
    return _sampleArray;
}
@end
