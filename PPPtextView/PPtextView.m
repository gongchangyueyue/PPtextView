//
//  PPtextView.m
//  biketest
//
//  Created by 张朋 on 16/9/14.
//  Copyright © 2016年 张朋. All rights reserved.
//

#import "PPtextView.h"
#import <CoreText/CoreText.h>

@interface PPtextView(){
    NSMutableAttributedString *_string;
    UIFont *_font;
    UIColor *_textColor;
}

@end

@implementation PPtextView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _string = [[NSMutableAttributedString alloc] initWithString:text];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}

- (void)setTextFont:(UIFont *)font{
    _font = font;
}

- (void)drawRect:(CGRect)rect{
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    
    CGFloat paragraphSpacing = 11.0;
    CGFloat paragraphSpacingBefore = 0.0;
    CGFloat firstLineHeadIndent = 0.0;
    CGFloat headIndent = 0.0;
    
    CTParagraphStyleSetting settings[] =
    {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
        {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
    };
    
    CTParagraphStyleRef style;
    style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(CTParagraphStyleSetting));
    
    if (NULL == style) {
        // error...
        return;
    }
    
    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)style, (NSString*)kCTParagraphStyleAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];
    
    CFRelease(style);
    
    if (nil == _font) {
        _font = [UIFont boldSystemFontOfSize:12.0];
    }
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)_font.fontName, _font.pointSize, NULL);
    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)fontRef, (NSString*)kCTFontAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];
    
    CGColorRef colorRef = _textColor.CGColor;
    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)colorRef,(NSString*)kCTForegroundColorAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(ctx,0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_string);
    
    CGRect bounds = self.bounds;
    bounds.origin.x = bounds.origin.x;
    bounds.size.width = bounds.size.width;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [_string length]), path, NULL);
    CFRelease(path);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
    CFRelease(frameSetter);
}

+(CGRect)getStringFrameWithString:(NSString *)text xValue:(CGFloat)x yValue:(CGFloat)y widthVaule:(CGFloat)width useFont:(UIFont *)font{
    int total_height = 0;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)fontRef, (NSString*)kCTFontAttributeName, nil]
                    range:NSMakeRange(0, [string length])];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGRect drawingRect = CGRectMake(0, 0, width, 2000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 2000 - line_y + (int) descent +1;
    
    CFRelease(textFrame);
    
    return CGRectMake(x, y, width, total_height);
}
@end
