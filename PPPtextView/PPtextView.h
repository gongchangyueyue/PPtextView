//
//  PPtextView.h
//  biketest
//
//  Created by 张朋 on 16/9/14.
//  Copyright © 2016年 张朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPtextView : UIView

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;
- (void)setTextFont:(UIFont *)font;
//计算frame
+(CGRect)getStringFrameWithString:(NSString *)text xValue:(CGFloat)x yValue:(CGFloat)y widthVaule:(CGFloat)width useFont:(UIFont *)font;
@end
