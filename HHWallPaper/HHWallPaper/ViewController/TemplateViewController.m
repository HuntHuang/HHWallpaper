//
//  TemplateViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/6.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "TemplateViewController.h"
#import "EditViewController.h"

@interface TemplateViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TemplateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"模板选择";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, 300, 100, 50)];
    [button setTitle:@"Choose" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onClickedChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onClickedChoose
{
    UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickCtl.delegate = self;
    [self presentViewController:pickCtl animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    UIImage *mainImage = [UIImage imageWithData:data];
    if (mainImage.size.height > mainImage.size.width)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择横向图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    EditViewController *vc = [[EditViewController alloc] initWithImage:mainImage];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
