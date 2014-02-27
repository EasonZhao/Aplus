//
//  MeLabel.m
//  EBooks
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MeLabel.h"
#import "MeParser.h"
#import "NSAttributedString.h"

@implementation MeLabel

//对其转换
static CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) {
	switch (alignment) {
		case UITextAlignmentLeft: return kCTLeftTextAlignment;
		case UITextAlignmentCenter: return kCTCenterTextAlignment;
		case UITextAlignmentRight: return kCTRightTextAlignment;
		case UITextAlignmentJustify: return kCTJustifiedTextAlignment; /* special OOB value if we decide to use it even if it's not really standard... */
		default: return kCTNaturalTextAlignment;
	}
}
static CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode) {
	switch (lineBreakMode) {
		case UILineBreakModeWordWrap: return kCTLineBreakByWordWrapping;
		case UILineBreakModeCharacterWrap: return kCTLineBreakByCharWrapping;
		case UILineBreakModeClip: return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation: return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation: return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation: return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}

//重置AttributedStringRef
- (void)resetAttributedText
{
    //释放attributedText_
    if(attributedText_){
        [attributedText_ release];
        attributedText_ = NULL;
    }
    
    NSMutableArray *attAry;
    NSString *txt = [[MeParser parser] htmlParser:[self text] AttAry:&attAry];
    
    //创建NSMutableAttributedString
    attributedText_ = [[NSMutableAttributedString alloc] initWithString:txt];
	[attributedText_ setFont:self.font];
	[attributedText_ setTextColor:self.textColor];
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
	[attributedText_ setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
    
    NSRange rang;
    NSDictionary *attDic;
    //设置属性
    for (attDic in attAry) {
        rang = [[attDic objectForKey:ATT_KEY_RANG] rangeValue];
        NSArray *keys = [attDic allKeys];
        UIFont *font = self.font;
        for(NSString *key in keys){
            if(key==ATT_KEY_SIZE){
                font = [UIFont fontWithName:font.fontName size:[[attDic valueForKey:key] floatValue]];
                [attributedText_ setFont:font range:rang];
            }else if(key==ATT_KEY_COLOR){
                [attributedText_ setTextColor:[attDic objectForKey:key] range:rang];
            }
        }
    }
}

//重置CTFrameRef
- (void)resetTextFrame
{
    if (textFrame_) {
		CFRelease(textFrame_);
		textFrame_ = NULL;
	}
}

//释放对象
- (void)dealloc
{
    [attributedText_ release];
    [self resetTextFrame];
    [super dealloc];
}

//自定义重绘
- (void)drawTextInRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
    
    if (self.shadowColor) {
        CGContextSetShadowWithColor(ctx, self.shadowOffset, 0.0, self.shadowColor.CGColor);
    }
    
    if (textFrame_ == NULL) {
        if(attributedText_ == NULL){
            [self resetAttributedText];
        }
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText_);
        CGRect drawingRect = self.bounds;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, drawingRect);
        textFrame_ = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
    }
    
    CTFrameDraw(textFrame_, ctx);
    
    CGContextRestoreGState(ctx);
}

//默认属性修改
-(void)setText:(NSString *)text
{
	[super setText:text];
	[self resetAttributedText];
}
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
	[attributedText_ setFont:font];
}
-(void)setTextColor:(UIColor *)color
{
    [super setTextColor:color];
	[attributedText_ setTextColor:color];
}
-(void)setTextAlignment:(UITextAlignment)alignment
{
    [super setTextAlignment:alignment];
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(alignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
	[attributedText_ setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
}
-(void)setLineBreakMode:(UILineBreakMode)lineBreakMode
{
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(lineBreakMode);
	[attributedText_ setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
	[super setLineBreakMode:lineBreakMode];
}

//重置Display
-(void)setNeedsDisplay
{
	[self resetTextFrame];
	[super setNeedsDisplay];
}

@end
