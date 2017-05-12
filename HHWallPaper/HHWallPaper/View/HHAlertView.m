//
//  HHAlertView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHAlertView.h"

@interface HHAlertView ()<FUIAlertViewDelegate>

@property (nonatomic, copy) void(^textFieldCallback)(NSString *textString);

@end

@implementation HHAlertView

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle textFieldCallback:(void(^)(NSString *textString))textFieldCallback
{
    self = [super initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self)
    {
        self.textFieldCallback = textFieldCallback;
        [self setupWithTitle:title cancelButtonTitle:cancelButtonTitle];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.alertViewStyle = FUIAlertViewStylePlainTextInput;
    [@[[self textFieldAtIndex:0], [self textFieldAtIndex:1]] enumerateObjectsUsingBlock:^(FUITextField *textField, NSUInteger idx, BOOL *stop) {
        [textField setTextFieldColor:[UIColor cloudsColor]];
        [textField setBorderColor:[UIColor asbestosColor]];
        [textField setCornerRadius:4];
        [textField setFont:[UIFont flatFontOfSize:14]];
        [textField setTextColor:[UIColor midnightBlueColor]];
    }];
    [[self textFieldAtIndex:0] setPlaceholder:@"6"];
    
    self.titleLabel.textColor = [UIColor cloudsColor];
    self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    self.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    self.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    self.defaultButtonColor = [UIColor cloudsColor];
    self.defaultButtonShadowColor = [UIColor asbestosColor];
    self.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    self.defaultButtonTitleColor = [UIColor asbestosColor];
}

#pragma mark - FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = [alertView textFieldAtIndex:0].text.length>0 ? [alertView textFieldAtIndex:0].text : @"6";
    if (self.textFieldCallback)
    {
        self.textFieldCallback(text);
    }
}

@end
