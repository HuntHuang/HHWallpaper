//
//  HHAlertView.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <FlatUIKit/FlatUIKit.h>

@interface HHAlertView : FUIAlertView

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle textFieldCallback:(void(^)(NSString *textString))textFieldCallback;

@end
