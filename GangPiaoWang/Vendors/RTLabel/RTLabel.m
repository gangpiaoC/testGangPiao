//
//  RTLabel.m
//  RTLabelProject
//
/**
 * Copyright (c) 2010 Muh Hon Cheng
 * Created by honcheng on 1/6/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "RTLabel.h"
@interface RTLabelButton : UIButton
@property (nonatomic, assign) int componentIndex;
@property (nonatomic) NSString *url;
@end

@implementation RTLabelButton
@end


@implementation RTLabelComponent

- (id)initWithString:(NSString*)aText tag:(NSString*)aTagLabel attributes:(NSMutableDictionary*)theAttributes
{
    self = [super init];
	if (self) {
		_text = aText;
		_tagLabel = aTagLabel;
		_attributes = theAttributes;
	}
	return self;
}

+ (id)componentWithString:(NSString*)aText tag:(NSString*)aTagLabel attributes:(NSMutableDictionary*)theAttributes
{
	return [[self alloc] initWithString:aText tag:aTagLabel attributes:theAttributes];
}

- (id)initWithTag:(NSString*)aTagLabel position:(int)aPosition attributes:(NSMutableDictionary*)theAttributes 
{
    self = [super init];
    if (self) {
        _tagLabel = aTagLabel;
		_position = aPosition;
		_attributes = theAttributes;
    }
    return self;
}

+(id)componentWithTag:(NSString*)aTagLabel position:(int)aPosition attributes:(NSMutableDictionary*)theAttributes
{
	return [[self alloc] initWithTag:aTagLabel position:aPosition attributes:theAttributes];
}

- (NSString*)description
{
	NSMutableString *desc = [NSMutableString string];
	[desc appendFormat:@"text: %@", self.text];
	[desc appendFormat:@", position: %i", self.position];
	if (self.tagLabel) [desc appendFormat:@", tag: %@", self.tagLabel];
	if (self.attributes) [desc appendFormat:@", attributes: %@", self.attributes];
	return desc;
}


@end

@implementation RTLabelExtractedComponent

+ (RTLabelExtractedComponent*)rtLabelExtractComponentsWithTextComponent:(NSMutableArray*)textComponents plainText:(NSString*)plainText
{
    RTLabelExtractedComponent *component = [[RTLabelExtractedComponent alloc] init];
    [component setTextComponents:textComponents];
    [component setPlainText:plainText];
    return component;
}

@end

@interface RTLabel()
- (CGFloat)frameHeight:(CTFrameRef)frame;
- (NSArray *)components;
- (void)parse:(NSString *)data valid_tags:(NSArray *)valid_tags;
- (NSArray*) colorForHex:(NSString *)hexColor;
- (void)render;

#pragma mark -
#pragma mark styling

- (void)applyItalicStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyBoldStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyBoldItalicStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyColor:(NSString*)value toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applySingleUnderlineText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyDoubleUnderlineText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyUnderlineColor:(NSString*)value toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyFontAttributes:(NSDictionary*)attributes toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length;
- (void)applyParagraphStyleToText:(CFMutableAttributedStringRef)text attributes:(NSMutableDictionary*)attributes atPosition:(int)position withLength:(int)length;
@end

@implementation RTLabel

- (id)initWithFrame:(CGRect)_frame
{
    self = [super initWithFrame:_frame];
    if (self)
	{
		[self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{    
    self = [super initWithCoder:aDecoder];
    if (self)
	{
		[self initialize];
    }
    return self;
}

- (void)initialize
{
	[self setBackgroundColor:[UIColor clearColor]];

	_font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
	_textColor = [UIColor blackColor];
	_text = @"";
	_textAlignment = RTTextAlignmentLeft;
	_lineBreakMode = RTTextLineBreakModeWordWrapping;
	_lineSpacing = 3;
	_currentSelectedButtonComponentIndex = -1;
	_paragraphReplacement = @"\n";

}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)setTextAlignment:(RTTextAlignment)textAlignment
{
	_textAlignment = textAlignment;
	[self setNeedsDisplay];
}

- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode
{
	_lineBreakMode = lineBreakMode;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
	[self render];
}

- (void)render
{
	if (self.currentSelectedButtonComponentIndex==-1)
	{
		for (id view in [self subviews])
		{
			if ([view isKindOfClass:[UIView class]])
			{
				[view removeFromSuperview];
			}
		}
	}
	
    if (!self.plainText) return;
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context != NULL)
    {
        // Drawing code.
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.frame.size.height);
        CGContextConcatCTM(context, flipVertical);
    }
	
	// Initialize an attributed string.
	CFStringRef string = (__bridge CFStringRef)self.plainText;
	CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), string);
	
	CFMutableDictionaryRef styleDict1 = ( CFDictionaryCreateMutable( (0), 0, (0), (0) ) );
	// Create a color and add it as an attribute to the string.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorSpaceRelease(rgbColorSpace);
	CFDictionaryAddValue( styleDict1, kCTForegroundColorAttributeName, [self.textColor CGColor] );
	CFAttributedStringSetAttributes( attrString, CFRangeMake( 0, CFAttributedStringGetLength(attrString) ), styleDict1, 0 ); 
	
	CFMutableDictionaryRef styleDict = ( CFDictionaryCreateMutable( (0), 0, (0), (0) ) );
	
	[self applyParagraphStyleToText:attrString attributes:nil atPosition:0 withLength:CFAttributedStringGetLength(attrString)];
	
	
	CTFontRef thisFont = CTFontCreateWithName ((__bridge CFStringRef)[self.font fontName], [self.font pointSize], NULL); 
	CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, thisFont);
	
	NSMutableArray *links = [NSMutableArray array];
	NSMutableArray *textComponents = nil;
    if (self.highlighted) textComponents = self.highlightedTextComponents;
    else textComponents = self.textComponents;
    
	for (RTLabelComponent *component in textComponents)
	{
		NSUInteger index = [textComponents indexOfObject:component];
		component.componentIndex = index;
		
		if ([component.tagLabel caseInsensitiveCompare:@"i"] == NSOrderedSame)
		{
			// make font italic
			[self applyItalicStyleToText:attrString atPosition:component.position withLength:[component.text length]];
		}
		else if ([component.tagLabel caseInsensitiveCompare:@"b"] == NSOrderedSame)
		{
			// make font bold
			[self applyBoldStyleToText:attrString atPosition:component.position withLength:[component.text length]];
		}
        else if ([component.tagLabel caseInsensitiveCompare:@"bi"] == NSOrderedSame)
        {
            [self applyBoldItalicStyleToText:attrString atPosition:component.position withLength:[component.text length]];
        }
		else if ([component.tagLabel caseInsensitiveCompare:@"a"] == NSOrderedSame)
		{
			if (self.currentSelectedButtonComponentIndex==index)
			{
				if (self.selectedLinkAttributes)
				{
					[self applyFontAttributes:self.selectedLinkAttributes toText:attrString atPosition:component.position withLength:[component.text length]];
				}
				else
				{
					[self applyBoldStyleToText:attrString atPosition:component.position withLength:[component.text length]];
					[self applyColor:@"#FF0000" toText:attrString atPosition:component.position withLength:[component.text length]];
				}
			}
			else
			{
				if (self.linkAttributes)
				{
					[self applyFontAttributes:self.linkAttributes toText:attrString atPosition:component.position withLength:[component.text length]];
				}
				else
				{
					[self applyBoldStyleToText:attrString atPosition:component.position withLength:[component.text length]];
					[self applySingleUnderlineText:attrString atPosition:component.position withLength:[component.text length]];
				}
			}
			
			NSString *value = [component.attributes objectForKey:@"href"];
			value = [value stringByReplacingOccurrencesOfString:@"'" withString:@""];
			[component.attributes setObject:value forKey:@"href"];
			
			[links addObject:component];
		}
		else if ([component.tagLabel caseInsensitiveCompare:@"u"] == NSOrderedSame || [component.tagLabel caseInsensitiveCompare:@"uu"] == NSOrderedSame)
		{
			// underline
			if ([component.tagLabel caseInsensitiveCompare:@"u"] == NSOrderedSame)
			{
				[self applySingleUnderlineText:attrString atPosition:component.position withLength:[component.text length]];
			}
			else if ([component.tagLabel caseInsensitiveCompare:@"uu"] == NSOrderedSame)
			{
				[self applyDoubleUnderlineText:attrString atPosition:component.position withLength:[component.text length]];
			}
			
			if ([component.attributes objectForKey:@"color"])
			{
				NSString *value = [component.attributes objectForKey:@"color"];
				[self applyUnderlineColor:value toText:attrString atPosition:component.position withLength:[component.text length]];
			}
		}
		else if ([component.tagLabel caseInsensitiveCompare:@"font"] == NSOrderedSame)
		{
			[self applyFontAttributes:component.attributes toText:attrString atPosition:component.position withLength:[component.text length]];
		}
		else if ([component.tagLabel caseInsensitiveCompare:@"p"] == NSOrderedSame)
		{
			[self applyParagraphStyleToText:attrString attributes:component.attributes atPosition:component.position withLength:[component.text length]];
		}
		else if ([component.tagLabel caseInsensitiveCompare:@"center"] == NSOrderedSame)
		{
			[self applyCenterStyleToText:attrString attributes:component.attributes atPosition:component.position withLength:[component.text length]];
		}
	}
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
	
    // Initialize a rectangular path.
	CGMutablePathRef path = CGPathCreateMutable();
	CGRect bounds = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
	CGPathAddRect(path, NULL, bounds);
	
	// Create the frame and draw it into the graphics context
	//CTFrameRef 
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), path, NULL);
	
	CFRange range;
	CGSize constraint = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
	self.optimumSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self.plainText length]), nil, constraint, &range);
	
	
	if (self.currentSelectedButtonComponentIndex==-1)
	{
		// only check for linkable items the first time, not when it's being redrawn on button pressed
		
		for (RTLabelComponent *linkableComponents in links)
		{
			float height = 0.0;
			CFArrayRef frameLines = CTFrameGetLines(frame);
			for (CFIndex i=0; i<CFArrayGetCount(frameLines); i++)
			{
				CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(frameLines, i);
				CFRange lineRange = CTLineGetStringRange(line);
				CGFloat ascent;
				CGFloat descent;
				CGFloat leading;
				
				CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                CGPoint origin;
				CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &origin);
                
				if ( (linkableComponents.position<lineRange.location && linkableComponents.position+linkableComponents.text.length>(u_int16_t)(lineRange.location)) || (linkableComponents.position>=lineRange.location && linkableComponents.position<lineRange.location+lineRange.length))
				{
					CGFloat secondaryOffset;
					CGFloat primaryOffset = CTLineGetOffsetForStringIndex(CFArrayGetValueAtIndex(frameLines,i), linkableComponents.position, &secondaryOffset);
					CGFloat primaryOffset2 = CTLineGetOffsetForStringIndex(CFArrayGetValueAtIndex(frameLines,i), linkableComponents.position+linkableComponents.text.length, NULL);
					
					CGFloat button_width = primaryOffset2 - primaryOffset;
					
					RTLabelButton *button = [[RTLabelButton alloc] initWithFrame:CGRectMake(primaryOffset+origin.x, height, button_width, ascent+descent)];
					
					[button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
					[button setComponentIndex:linkableComponents.componentIndex];
					
					[button setUrl:[linkableComponents.attributes objectForKey:@"href"]];
					[button addTarget:self action:@selector(onButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
					[button addTarget:self action:@selector(onButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
					[button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
					
				}
				
				origin.y = self.frame.size.height - origin.y;
				height = origin.y + descent + _lineSpacing;
			}
		}
	}
	
	self.visibleRange = CTFrameGetVisibleStringRange(frame);

	CFRelease(thisFont);
	CFRelease(path);
	CFRelease(styleDict1);
	CFRelease(styleDict);
	CFRelease(framesetter);
	CTFrameDraw(frame, context);
    CFRelease(frame);
}

#pragma mark -
#pragma mark styling

- (void)applyParagraphStyleToText:(CFMutableAttributedStringRef)text attributes:(NSMutableDictionary*)attributes atPosition:(int)position withLength:(int)length
{
	CFMutableDictionaryRef styleDict = ( CFDictionaryCreateMutable( (0), 0, (0), (0) ) );
	
	// direction
	CTWritingDirection direction = kCTWritingDirectionLeftToRight; 
	// leading
	CGFloat firstLineIndent = 0.0; 
	CGFloat headIndent = 0.0; 
	CGFloat tailIndent = 0.0; 
	CGFloat lineHeightMultiple = 1.0; 
	CGFloat maxLineHeight = 0; 
	CGFloat minLineHeight = 0; 
	CGFloat paragraphSpacing = 0.0;
	CGFloat paragraphSpacingBefore = 0.0;
	CTTextAlignment textAlignment = (CTTextAlignment)_textAlignment;
	CTLineBreakMode lineBreakMode = (CTLineBreakMode)_lineBreakMode;
	CGFloat lineSpacing = _lineSpacing;
	
	for (NSUInteger i=0; i<[[attributes allKeys] count]; i++)
	{
		NSString *key = [[attributes allKeys] objectAtIndex:i];
		id value = [attributes objectForKey:key];
		if ([key caseInsensitiveCompare:@"align"] == NSOrderedSame)
		{
			if ([value caseInsensitiveCompare:@"left"] == NSOrderedSame)
			{
				textAlignment = kCTLeftTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"right"] == NSOrderedSame)
			{
				textAlignment = kCTRightTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"justify"] == NSOrderedSame)
			{
				textAlignment = kCTJustifiedTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"center"] == NSOrderedSame)
			{
				textAlignment = kCTCenterTextAlignment;
			}
		}
		else if ([key caseInsensitiveCompare:@"indent"] == NSOrderedSame)
		{
			firstLineIndent = [value floatValue];
		}
		else if ([key caseInsensitiveCompare:@"linebreakmode"] == NSOrderedSame)
		{
			if ([value caseInsensitiveCompare:@"wordwrap"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByWordWrapping;
			}
			else if ([value caseInsensitiveCompare:@"charwrap"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByCharWrapping;
			}
			else if ([value caseInsensitiveCompare:@"clipping"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByClipping;
			}
			else if ([value caseInsensitiveCompare:@"truncatinghead"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingHead;
			}
			else if ([value caseInsensitiveCompare:@"truncatingtail"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingTail;
			}
			else if ([value caseInsensitiveCompare:@"truncatingmiddle"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingMiddle;
			}
		}
	}
	
	CTParagraphStyleSetting theSettings[] =
	{
		{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode  },
		{ kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &direction }, 
		{ kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }, // leading
		{ kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing }, // leading
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineIndent },
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent }, 
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent }, 
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple }, 
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight }, 
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight }, 
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing }, 
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore }
	};
	
	
	CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, sizeof(theSettings) / sizeof(CTParagraphStyleSetting));
	CFDictionaryAddValue( styleDict, kCTParagraphStyleAttributeName, theParagraphRef );
	
	CFAttributedStringSetAttributes( text, CFRangeMake(position, length), styleDict, 0 ); 
	CFRelease(theParagraphRef);
    CFRelease(styleDict);
}

- (void)applyCenterStyleToText:(CFMutableAttributedStringRef)text attributes:(NSMutableDictionary*)attributes atPosition:(int)position withLength:(int)length
{
	CFMutableDictionaryRef styleDict = ( CFDictionaryCreateMutable( (0), 0, (0), (0) ) );
	
	// direction
	CTWritingDirection direction = kCTWritingDirectionLeftToRight;
	// leading
	CGFloat firstLineIndent = 0.0;
	CGFloat headIndent = 0.0;
	CGFloat tailIndent = 0.0;
	CGFloat lineHeightMultiple = 1.0;
	CGFloat maxLineHeight = 0;
	CGFloat minLineHeight = 0;
	CGFloat paragraphSpacing = 0.0;
	CGFloat paragraphSpacingBefore = 0.0;
	int textAlignment = _textAlignment;
	int lineBreakMode = _lineBreakMode;
	int lineSpacing = (int)_lineSpacing;

    textAlignment = kCTCenterTextAlignment;
	
	CTParagraphStyleSetting theSettings[] =
	{
		{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode  },
		{ kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &direction },
		{ kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing },
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineIndent },
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent },
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent },
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple },
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight },
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight },
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore }
	};
	
	CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, sizeof(theSettings) / sizeof(CTParagraphStyleSetting));
	CFDictionaryAddValue( styleDict, kCTParagraphStyleAttributeName, theParagraphRef );
	
	CFAttributedStringSetAttributes( text, CFRangeMake(position, length), styleDict, 0 );
	CFRelease(theParagraphRef);
    CFRelease(styleDict);
}

- (void)applySingleUnderlineText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
    if (_isUnderLine) {
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTUnderlineStyleAttributeName,  (__bridge CFNumberRef)[NSNumber numberWithInt:kCTUnderlineStyleSingle]);

    }
}

- (void)applyDoubleUnderlineText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
	CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTUnderlineStyleAttributeName,  (__bridge CFNumberRef)[NSNumber numberWithInt:kCTUnderlineStyleDouble]);
}

- (void)applyItalicStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef italicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontItalicTrait, kCTFontItalicTrait);
    if (!italicFontRef) {
        //fallback to system italic font
        UIFont *font = [UIFont systemFontOfSize :CTFontGetSize(actualFontRef) weight:UIFontWeightLight];
        italicFontRef = CTFontCreateWithName ((__bridge CFStringRef)[font fontName], [font pointSize], NULL);
    }
    CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, italicFontRef);
    CFRelease(italicFontRef);
}

- (void)applyFontAttributes:(NSDictionary*)attributes toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
	for (NSString *key in attributes)
	{
		NSString *value = [attributes objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"'" withString:@""];
		
		if ([key caseInsensitiveCompare:@"color"] == NSOrderedSame)
		{
			[self applyColor:value toText:text atPosition:position withLength:length];
		}
		else if ([key caseInsensitiveCompare:@"stroke"] == NSOrderedSame)
		{
			CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTStrokeWidthAttributeName, (__bridge CFTypeRef)([NSNumber numberWithFloat:[[attributes objectForKey:@"stroke"] intValue]]));
		}
		else if ([key caseInsensitiveCompare:@"kern"] == NSOrderedSame)
		{
			CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTKernAttributeName, (__bridge CFTypeRef)([NSNumber numberWithFloat:[[attributes objectForKey:@"kern"] intValue]]));
		}
		else if ([key caseInsensitiveCompare:@"underline"] == NSOrderedSame)
		{
			int numberOfLines = [value intValue];
			if (numberOfLines==1)
			{
				[self applySingleUnderlineText:text atPosition:position withLength:length];
			}
			else if (numberOfLines==2)
			{
				[self applyDoubleUnderlineText:text atPosition:position withLength:length];
			}
		}
		else if ([key caseInsensitiveCompare:@"style"] == NSOrderedSame)
		{
			if ([value caseInsensitiveCompare:@"bold"] == NSOrderedSame)
			{
				[self applyBoldStyleToText:text atPosition:position withLength:length];
			}
			else if ([value caseInsensitiveCompare:@"italic"] == NSOrderedSame)
			{
				[self applyItalicStyleToText:text atPosition:position withLength:length];
			}
		}
	}
	
	UIFont *font = nil;
	if ([attributes objectForKey:@"face"] && [attributes objectForKey:@"size"])
	{
		NSString *fontName = [attributes objectForKey:@"face"];
		fontName = [fontName stringByReplacingOccurrencesOfString:@"'" withString:@""];
		font = [UIFont fontWithName:fontName size:[[attributes objectForKey:@"size"] intValue]];
	}
	else if ([attributes objectForKey:@"face"] && ![attributes objectForKey:@"size"])
	{
		NSString *fontName = [attributes objectForKey:@"face"];
		fontName = [fontName stringByReplacingOccurrencesOfString:@"'" withString:@""];
		font = [UIFont fontWithName:fontName size:self.font.pointSize];
	}
	else if (![attributes objectForKey:@"face"] && [attributes objectForKey:@"size"])
	{
		font = [UIFont fontWithName:[self.font fontName] size:[[attributes objectForKey:@"size"] intValue]];
	}
	if (font)
	{
		CTFontRef customFont = CTFontCreateWithName ((__bridge CFStringRef)[font fontName], [font pointSize], NULL); 
		CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, customFont);
		CFRelease(customFont);
	}
}

- (void)applyBoldStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef boldItalicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontBoldTrait | kCTFontItalicTrait , kCTFontBoldTrait | kCTFontItalicTrait);
    if (!boldItalicFontRef) {
        //try fallback to system boldItalic font
        NSString *fontName = [NSString stringWithFormat:@"%@-BoldOblique", self.font.fontName];
        boldItalicFontRef = CTFontCreateWithName ((__bridge CFStringRef)fontName, [self.font pointSize], NULL);
    }

    if (boldItalicFontRef) {
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, boldItalicFontRef);
        CFRelease(boldItalicFontRef);
    }

}

- (void)applyBoldItalicStyleToText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef boldItalicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontBoldTrait | kCTFontItalicTrait , kCTFontBoldTrait | kCTFontItalicTrait);
    if (!boldItalicFontRef) {
        //try fallback to system boldItalic font
        NSString *fontName = [NSString stringWithFormat:@"%@-BoldOblique", self.font.fontName];
        boldItalicFontRef = CTFontCreateWithName ((__bridge CFStringRef)fontName, [self.font pointSize], NULL);
    }
    
    if (boldItalicFontRef) {
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, boldItalicFontRef);
        CFRelease(boldItalicFontRef);
    }

}

- (void)applyColor:(NSString*)value toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
	
	if ([value rangeOfString:@"#"].location==0)
	{
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
		value = [value stringByReplacingOccurrencesOfString:@"#" withString:@""];
		NSArray *colorComponents = [self colorForHex:value];
		CGFloat components[] = { [[colorComponents objectAtIndex:0] floatValue] , [[colorComponents objectAtIndex:1] floatValue] , [[colorComponents objectAtIndex:2] floatValue] , [[colorComponents objectAtIndex:3] floatValue] };
		CGColorRef color = CGColorCreate(rgbColorSpace, components);
		CFAttributedStringSetAttribute(text, CFRangeMake(position, length),kCTForegroundColorAttributeName, color);
		CFRelease(color);
        CGColorSpaceRelease(rgbColorSpace);
	} else {
		value = [value stringByAppendingString:@"Color"];
		SEL colorSel = NSSelectorFromString(value);
		UIColor *_color = nil;
		if ([UIColor respondsToSelector:colorSel]) {
			_color = [UIColor performSelector:colorSel];
			CGColorRef color = [_color CGColor];
			CFAttributedStringSetAttribute(text, CFRangeMake(position, length),kCTForegroundColorAttributeName, color);
		}				
	}
}

- (void)applyUnderlineColor:(NSString*)value toText:(CFMutableAttributedStringRef)text atPosition:(int)position withLength:(int)length
{
	
	value = [value stringByReplacingOccurrencesOfString:@"'" withString:@""];
	if ([value rangeOfString:@"#"].location==0) {
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
		value = [value stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
		NSArray *colorComponents = [self colorForHex:value];
		CGFloat components[] = { [[colorComponents objectAtIndex:0] floatValue] , [[colorComponents objectAtIndex:1] floatValue] , [[colorComponents objectAtIndex:2] floatValue] , [[colorComponents objectAtIndex:3] floatValue] };
		CGColorRef color = CGColorCreate(rgbColorSpace, components);
		CFAttributedStringSetAttribute(text, CFRangeMake(position, length),kCTUnderlineColorAttributeName, color);
		CGColorRelease(color);
        CGColorSpaceRelease(rgbColorSpace);
	}
	else
	{
		value = [value stringByAppendingString:@"Color"];
		SEL colorSel = NSSelectorFromString(value);
		if ([UIColor respondsToSelector:colorSel]) {
			UIColor *_color = [UIColor performSelector:colorSel];
			CGColorRef color = [_color CGColor];
			CFAttributedStringSetAttribute(text, CFRangeMake(position, length),kCTUnderlineColorAttributeName, color);
			//CGColorRelease(color);
		}				
	}
	
}

#pragma mark -
#pragma mark button 

- (void)onButtonTouchDown:(id)sender
{
	RTLabelButton *button = (RTLabelButton*)sender;
    [self setCurrentSelectedButtonComponentIndex:button.componentIndex];
	[self setNeedsDisplay];
}

- (void)onButtonTouchUpOutside:(id)sender
{
	[self setCurrentSelectedButtonComponentIndex:-1];
	[self setNeedsDisplay];
}

- (void)onButtonPressed:(id)sender
{
	RTLabelButton *button = (RTLabelButton*)sender;
	[self setCurrentSelectedButtonComponentIndex:-1];
	[self setNeedsDisplay];

	if ([self.delegate respondsToSelector:@selector(rtLabel:didSelectLinkWithURL:)])
	{
		[self.delegate rtLabel:self didSelectLinkWithURL:[NSString stringWithFormat:@"%@",button.url]];
	}
}

- (CGSize)optimumSize
{
	[self render];
	return _optimumSize;
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
	_lineSpacing = lineSpacing;
	[self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted!=_highlighted)
    {
        _highlighted = highlighted;
        [self setNeedsDisplay];
    }
}

- (void)setHighlightedText:(NSString *)text
{
	_highlightedText = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
	RTLabelExtractedComponent *component = [RTLabel extractTextStyleFromText:_highlightedText paragraphReplacement:self.paragraphReplacement];
    [self setHighlightedTextComponents:component.textComponents];
}

- (void)setText:(NSString *)text
{
	_text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
	RTLabelExtractedComponent *component = [RTLabel extractTextStyleFromText:_text paragraphReplacement:self.paragraphReplacement];
    [self setTextComponents:component.textComponents];
    [self setPlainText:component.plainText];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text extractedTextComponent:(RTLabelExtractedComponent*)extractedComponent
{
	_text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    [self setTextComponents:extractedComponent.textComponents];
    [self setPlainText:extractedComponent.plainText];
	[self setNeedsDisplay];
}

- (void)setHighlightedText:(NSString *)text extractedTextComponent:(RTLabelExtractedComponent*)extractedComponent
{
    _highlightedText = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    [self setHighlightedTextComponents:extractedComponent.textComponents];
}

// http://forums.macrumors.com/showthread.php?t=925312
// not accurate
- (CGFloat)frameHeight:(CTFrameRef)theFrame
{
	CFArrayRef lines = CTFrameGetLines(theFrame);
    CGFloat height = 0.0;
    CGFloat ascent, descent, leading;
    for (CFIndex index = 0; index < CFArrayGetCount(lines); index++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, index);
        CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        height += (ascent + fabsf(descent) + leading);
    }
    return ceilf(height);
}

- (void)dealloc 
{
    self.delegate = nil;
}

- (NSArray *)components
{
	NSScanner *scanner = [NSScanner scannerWithString:self.text];
	[scanner setCharactersToBeSkipped:nil]; 
	
	NSMutableArray *components = [NSMutableArray array];
	
	while (![scanner isAtEnd]) 
	{
		NSString *currentComponent;
		BOOL foundComponent = [scanner scanUpToString:@"http" intoString:&currentComponent];
		if (foundComponent) 
		{
			[components addObject:currentComponent];
			
			NSString *string;
			BOOL foundURLComponent = [scanner scanUpToString:@" " intoString:&string];
			if (foundURLComponent) 
			{
				// if last character of URL is punctuation, its probably not part of the URL
				NSCharacterSet *punctuationSet = [NSCharacterSet punctuationCharacterSet];
				NSInteger lastCharacterIndex = string.length - 1;
				if ([punctuationSet characterIsMember:[string characterAtIndex:lastCharacterIndex]]) 
				{
					// remove the punctuation from the URL string and move the scanner back
					string = [string substringToIndex:lastCharacterIndex];
					[scanner setScanLocation:scanner.scanLocation - 1];
				}        
				[components addObject:string];
			}
		} 
		else 
		{ // first string is a link
			NSString *string;
			BOOL foundURLComponent = [scanner scanUpToString:@" " intoString:&string];
			if (foundURLComponent) 
			{
				[components addObject:string];
			}
		}
	}
	return [components copy];
}
+ (RTLabelExtractedComponent*)extractTextStyleFromText:(NSString*)data paragraphReplacement:(NSString*)paragraphReplacement
{
	NSScanner *scanner = nil; 
	NSString *text = nil;
	NSString *tag = nil;
	
	NSMutableArray *components = [NSMutableArray array];
	
	int last_position = 0;
	scanner = [NSScanner scannerWithString:data];
	while (![scanner isAtEnd])
    {

		[scanner scanUpToString:@"<" intoString:NULL];
        NSString *tempText=nil;
        [scanner scanUpToString:@">" intoString:&tempText];
        //我改的
        while (tempText&&tempText.length>2&&!([tempText rangeOfString:@"</font"].location==0||[tempText rangeOfString:@"</a"].location==0||[tempText rangeOfString:@"</b"].location==0||[tempText rangeOfString:@"</i"].location==0||[tempText rangeOfString:@"</bi"].location==0||[tempText rangeOfString:@"<font"].location==0||[tempText rangeOfString:@"<a"].location==0||[tempText rangeOfString:@"<b"].location==0||[tempText rangeOfString:@"<i"].location==0||[tempText rangeOfString:@"<bi"].location==0||[tempText rangeOfString:@"<u"].location==0)) {
            tempText=[tempText substringFromIndex:1];
           // [scanner scanUpToString:@">" intoString:&tempText];
        }
        text=tempText;
		//[scanner scanUpToString:@">" intoString:&text];
		NSString *delimiter = [NSString stringWithFormat:@"%@>", text];
		NSUInteger position = [data rangeOfString:delimiter].location;
		if (position!=NSNotFound)
		{
			if ([delimiter rangeOfString:@"<p"].location==0)
			{
				data = [data stringByReplacingOccurrencesOfString:delimiter withString:paragraphReplacement options:NSCaseInsensitiveSearch range:NSMakeRange(last_position, position+delimiter.length-last_position)];
			}
			else
			{
				data = [data stringByReplacingOccurrencesOfString:delimiter withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(last_position, position+delimiter.length-last_position)];
			}
			
			data = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
			data = [data stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		}
		
		if ([text rangeOfString:@"</"].location==0)
		{
			// end of tag
			tag = [text substringFromIndex:2];
			if (position!=NSNotFound)
			{
				for (int i=(int)[components count]-1; i>=0; i--)
				{
					RTLabelComponent *component = [components objectAtIndex:i];
					if (component.text==nil && [component.tagLabel isEqualToString:tag])
					{
						NSString *text2 = [data substringWithRange:NSMakeRange(component.position, position-component.position)];
						component.text = text2;
						break;
					}
				}
			}
		}
		else
		{
			// start of tag
			NSArray *textComponents = [[text substringFromIndex:1] componentsSeparatedByString:@" "];
			tag = [textComponents objectAtIndex:0];
			NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
			for (NSUInteger i=1; i<[textComponents count]; i++)
			{
				NSArray *pair = [[textComponents objectAtIndex:i] componentsSeparatedByString:@"="];
				if ([pair count] > 0) {
					NSString *key = [[pair objectAtIndex:0] lowercaseString];
					
					if ([pair count]>=2) {
						// Trim " charactere
						NSString *value = [[pair subarrayWithRange:NSMakeRange(1, [pair count] - 1)] componentsJoinedByString:@"="];
						value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, 1)];
						value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange([value length]-1, 1)];
						
						[attributes setObject:value forKey:key];
					} else if ([pair count]==1) {
						[attributes setObject:key forKey:key];
					}
				}
			}
			RTLabelComponent *component = [RTLabelComponent componentWithString:nil tag:tag attributes:attributes];
			component.position = position;
			[components addObject:component];
		}
		last_position = position;
	}
	
    return [RTLabelExtractedComponent rtLabelExtractComponentsWithTextComponent:components plainText:data];
}


- (void)parse:(NSString *)data valid_tags:(NSArray *)valid_tags
{
	//use to strip the HTML tags from the data
	NSScanner *scanner = nil;
	NSString *text = nil;
	NSString *tag = nil;
	
	NSMutableArray *components = [NSMutableArray array];
	
	//set up the scanner
	scanner = [NSScanner scannerWithString:data];
	NSMutableDictionary *lastAttributes = nil;
	
	int last_position = 0;
	while([scanner isAtEnd] == NO) 
	{
		//find start of tag
		[scanner scanUpToString:@"<" intoString:NULL];
		
		//find end of tag
		[scanner scanUpToString:@">" intoString:&text];
		
		NSMutableDictionary *attributes = nil;
		//get the name of the tag
		if([text rangeOfString:@"</"].location != NSNotFound)
			tag = [text substringFromIndex:2]; //remove </
		else 
		{
			tag = [text substringFromIndex:1]; //remove <
			//find out if there is a space in the tag
			if([tag rangeOfString:@" "].location != NSNotFound)
			{
				attributes = [NSMutableDictionary dictionary];
				NSArray *rawAttributes = [tag componentsSeparatedByString:@" "];
				for (NSUInteger i=1; i<[rawAttributes count]; i++)
				{
					NSArray *pair = [[rawAttributes objectAtIndex:i] componentsSeparatedByString:@"="];
					if ([pair count]==2)
					{
						[attributes setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
					}
				}
				
				//remove text after a space
				tag = [tag substringToIndex:[tag rangeOfString:@" "].location];
			}
		}
		
		//if not a valid tag, replace the tag with a space
		if([valid_tags containsObject:tag] == NO)
		{
			NSString *delimiter = [NSString stringWithFormat:@"%@>", text];
			NSUInteger position = [data rangeOfString:delimiter].location;
			BOOL isEnd = [delimiter rangeOfString:@"</"].location!=NSNotFound;
			if (position!=NSNotFound)
			{
				NSString *text2 = [data substringWithRange:NSMakeRange(last_position, position-last_position)];
				if (isEnd)
				{
					// is inside a tag
					[components addObject:[RTLabelComponent componentWithString:text2 tag:tag attributes:lastAttributes]];
				}else{
					// is outside a tag
					[components addObject:[RTLabelComponent componentWithString:text2 tag:nil attributes:lastAttributes]];
				}
				data = [data stringByReplacingOccurrencesOfString:delimiter withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(last_position, position+delimiter.length-last_position)];
				
				last_position = position;
			}else{
				NSString *text2 = [data substringFromIndex:last_position];
				// is outside a tag
				[components addObject:[RTLabelComponent componentWithString:text2 tag:nil attributes:lastAttributes]];
			}
			lastAttributes = attributes;
		}
	}
    [self setTextComponents:components];
    [self setPlainText:data];
}

- (NSArray*)colorForHex:(NSString *)hexColor 
{
	hexColor = [[hexColor stringByTrimmingCharactersInSet:
				 [NSCharacterSet whitespaceAndNewlineCharacterSet]
				 ] uppercaseString];  
	
    NSRange range;  
    range.location = 0;  
    range.length = 2; 
	
    NSString *rString = [hexColor substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [hexColor substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [hexColor substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
	NSArray *components = [NSArray arrayWithObjects:[NSNumber numberWithFloat:((float) r / 255.0f)],[NSNumber numberWithFloat:((float) g / 255.0f)],[NSNumber numberWithFloat:((float) b / 255.0f)],[NSNumber numberWithFloat:1.0],nil];
	return components;
	
}

- (NSString*)visibleText
{
    [self render];
    NSString *text = [self.text substringWithRange:NSMakeRange(self.visibleRange.location, self.visibleRange.length)];
    return text;
}

#pragma mark deprecated methods

- (void)setText:(NSString *)text extractedTextStyle:(NSDictionary*)extractTextStyle
{
	_text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    [self setTextComponents:[extractTextStyle objectForKey:@"textComponents"]];
    [self setPlainText:[extractTextStyle objectForKey:@"plainText"]];
	[self setNeedsDisplay];
}

+ (NSDictionary*)preExtractTextStyle:(NSString*)data
{
    NSString* paragraphReplacement = @"\n";
	
    RTLabelExtractedComponent *component = [RTLabel extractTextStyleFromText:data paragraphReplacement:paragraphReplacement];
	return [NSDictionary dictionaryWithObjectsAndKeys:component.textComponents, @"textComponents", component.plainText, @"plainText", nil];
}
+ (NSString *)returnBankName:(NSString*) idCard{

    //"发卡行.卡种名称",
    NSArray* bankName = @[
                          @"中国邮政储蓄银行·绿卡通" , @"中国邮政储蓄银行·绿卡银联标准卡" , @"中国邮政储蓄银行·绿卡银联标准卡" , @"中国邮政储蓄银行·绿卡专用卡" , @"中国邮政储蓄银行·绿卡银联标准卡",
                          @"中国邮政储蓄银行·绿卡(银联卡)" , @"中国邮政储蓄银行·绿卡VIP卡" , @"中国邮政储蓄银行·银联标准卡" , @"中国邮政储蓄银行·中职学生资助卡" , @"中国邮政储蓄银行·IC绿卡通VIP卡",
                          @"中国邮政储蓄银行·IC绿卡通" , @"中国邮政储蓄银行·IC联名卡" , @"中国邮政储蓄银行·IC预付费卡" , @"中国邮政储蓄银行·绿卡银联标准卡" , @"中国邮政储蓄银行·绿卡通",
                          @"中国邮政储蓄银行·武警军人保障卡" ,@"中国邮政储蓄银行·中国旅游卡（金卡）" ,@"中国邮政储蓄银行·普通高中学生资助卡" ,@"中国邮政储蓄银行·中国旅游卡（普卡）",
                          @"中国邮政储蓄银行·福农卡" , @"中国工商银行·牡丹运通卡金卡" , @"中国工商银行·牡丹运通卡金卡" , @"中国工商银行·牡丹运通卡金卡" , @"中国工商银行·牡丹VISA卡(单位卡)",
                          @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·牡丹VISA卡(单位卡)" , @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·牡丹VISA信用卡",
                          @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·牡丹运通卡普通卡" , @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·牡丹VISA白金卡" , @"中国工商银行·牡丹(银联卡)",
                          @"中国工商银行·牡丹(银联卡)" , @"中国工商银行·牡丹(银联卡)" , @"中国工商银行·牡丹(银联卡)" , @"中国工商银行·牡丹欧元卡" , @"中国工商银行·牡丹欧元卡",
                          @"中国工商银行·牡丹欧元卡" , @"中国工商银行·牡丹万事达国际借记卡" , @"中国工商银行·牡丹VISA信用卡" , @"中国工商银行·海航信用卡" , @"中国工商银行·牡丹VISA信用卡",
                          @"中国工商银行·牡丹万事达信用卡" , @"中国工商银行·牡丹万事达信用卡" , @"中国工商银行·牡丹万事达信用卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹万事达白金卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·海航信用卡个人普卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡" , @"中国工商银行·牡丹灵通卡",
                          @"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·E时代卡" ,@"中国工商银行·E时代卡" ,@"中国工商银行·理财金卡" ,@"中国工商银行·准(个普)" , @"中国工商银行·准(个普)" , @"中国工商银行·准(个普)" , @"中国工商银行·准(个普)" , @"中国工商银行·准(个普)" , @"中国工商银行·牡丹灵通卡" ,@"中国工商银行·准(商普)" , @"中国工商银行·牡丹卡(商务卡)" , @"中国工商银行·准(商金)" , @"中国工商银行·牡丹卡(商务卡)" , @"中国工商银行·(个普)" , @"中国工商银行·牡丹卡(个人卡)" , @"中国工商银行·牡丹卡(个人卡)" , @"中国工商银行·牡丹卡(个人卡)" , @"中国工商银行·牡丹卡(个人卡)" , @"中国工商银行·(个金)" , @"中国工商银行·牡丹交通卡" ,@"中国工商银行·准(个金)" , @"中国工商银行·牡丹交通卡" ,@"中国工商银行·(商普)" , @"中国工商银行·(商金)" , @"中国工商银行·牡丹卡(商务卡)" , @"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹交通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·牡丹" ,@"中国工商银行·牡丹" ,@"中国工商银行·牡丹" ,@"中国工商银行·牡丹" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·中央预算单位公务卡" ,@"中国工商银行·牡丹灵通卡" ,@"中国工商银行·财政预算单位公务卡" ,@"中国工商银行·牡丹卡白金卡" ,@"中国工商银行·牡丹卡普卡" ,@"中国工商银行·国航知音牡丹信用卡" ,@"中国工商银行·国航知音牡丹信用卡" ,@"中国工商银行·国航知音牡丹信用卡" ,@"中国工商银行·国航知音牡丹信用卡" ,@"中国工商银行·银联标准卡" ,@"中国工商银行·中职学生资助卡" ,@"中国工商银行·专用信用消费卡" ,@"中国工商银行·牡丹社会保障卡" ,@"中国工商银行·牡丹东航联名卡" ,@"中国工商银行·牡丹东航联名卡" ,@"中国工商银行·牡丹运通白金卡" ,@"中国工商银行·福农灵通卡" ,@"中国工商银行·福农灵通卡" ,@"中国工商银行·灵通卡" ,@"中国工商银行·灵通卡" ,@"中国工商银行·中国旅行卡" ,@"中国工商银行·牡丹卡普卡" ,@"中国工商银行·国际借记卡" ,@"中国工商银行·国际借记卡" ,@"中国工商银行·国际借记卡" ,@"中国工商银行·国际借记卡" ,@"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹多币种卡" ,@"中国工商银行·武警军人保障卡" ,@"中国工商银行·预付芯片卡" ,@"中国工商银行·理财金账户金卡" ,@"中国工商银行·灵通卡" ,@"中国工商银行·牡丹宁波市民卡" ,@"中国工商银行·中国旅游卡" ,@"中国工商银行·中国旅游卡" ,@"中国工商银行·中国旅游卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·借贷合一卡" ,@"中国工商银行·普通高中学生资助卡" ,@"中国工商银行·牡丹多币种卡" ,@"中国工商银行·牡丹多币种卡" ,@"中国工商银行·牡丹百夫长信用卡" ,@"中国工商银行·牡丹百夫长信用卡" ,@"中国工商银行·工银财富卡" ,@"中国工商银行·中小商户采购卡" ,@"中国工商银行·中小商户采购卡" ,@"中国工商银行·环球旅行金卡" ,@"中国工商银行·环球旅行白金卡" ,@"中国工商银行·牡丹工银大来卡" ,@"中国工商银行·牡丹工银大莱卡" ,@"中国工商银行·IC金卡" ,@"中国工商银行·IC白金卡" ,@"中国工商银行·工行IC卡（红卡）" , @"中国工商银行·借记卡" , @"中国工商银行·预付卡" , @"中国工商银行·预付卡" , @"中国工商银行·借记卡" , @"中国工商银行·信用卡" , @"中国工商银行·借记卡" , @"中国工商银行·信用卡" , @"中国工商银行·借记卡" , @"中国工商银行·借记卡" , @"中国工商银行·预付卡" , @"中国工商银行·借记卡" , @"中国工商银行·借记卡" , @"中国工商银行·" , @"中国工商银行·" , @"中国工商银行·借记卡" , @"中国工商银行·" , @"中国工商银行·" , @"中国工商银行·借记卡" , @"中国工商银行·预付卡" , @"中国工商银行·预付卡" , @"中国工商银行·借记卡" , @"中国工商银行·信用卡" , @"中国工商银行·借记卡" , @"中国工商银行·预付卡" , @"中国工商银行·预付卡" , @"中国工商银行·借记卡" , @"中国工商银行·" , @"中国工商银行·借记卡" , @"中国工商银行·预付卡" , @"中国工商银行·借记卡" , @"中国工商银行·" , @"中国工商银行·借记卡" , @"中国工商银行·" , @"中国工商银行·E时代卡" , @"中国工商银行·E时代卡" , @"中国工商银行·E时代卡" , @"中国工商银行·理财金账户" , @"中国工商银行·理财金账户" , @"中国工商银行·理财金账户" , @"中国工商银行·预付卡" , @"中国工商银行·预付卡" , @"中国工商银行·工银闪付预付卡" , @"中国工商银行·工银银联公司卡" , @"中国工商银行·Diamond" ,@"中国工商银行·借记卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·" ,@"中国工商银行" ,@"中国工商银行" ,@"中国工商银行·借记卡" ,@"中国工商银行·预付卡" ,@"中国工商银行·预付卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·预付卡" ,@"中国工商银行·预付卡" ,@"中国工商银行·借记卡" ,@"中国工商银行·工银伦敦借记卡" , @"中国工商银行·借记卡" , @"中国农业银行·金穗" ,@"中国农业银行·中国旅游卡" ,@"中国农业银行·普通高中学生资助卡" ,@"中国农业银行·银联标准卡" ,@"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·VISA白金卡" ,@"中国农业银行·万事达白金卡" ,@"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗(银联卡)" , @"中国农业银行·金穗" ,@"中国农业银行·中职学生资助卡" ,@"中国农业银行·专用惠农卡" ,@"中国农业银行·武警军人保障卡" ,@"中国农业银行·金穗校园卡(银联卡)" , @"中国农业银行·金穗星座卡(银联卡)" , @"中国农业银行·金穗社保卡(银联卡)" , @"中国农业银行·金穗旅游卡(银联卡)" , @"中国农业银行·金穗青年卡(银联卡)" , @"中国农业银行·复合介质金穗通宝卡" , @"中国农业银行·金穗海通卡" ,@"中国农业银行·退役金卡" ,@"中国农业银行·金穗" ,@"中国农业银行·金穗" ,@"中国农业银行·金穗通宝卡(银联卡)" , @"中国农业银行·金穗惠农卡" ,@"中国农业银行·金穗通宝银卡" ,@"中国农业银行·金穗通宝卡(银联卡)" , @"中国农业银行·金穗通宝卡(银联卡)" , @"中国农业银行·金穗通宝卡" ,@"中国农业银行·金穗通宝卡(银联卡)" , @"中国农业银行·金穗通宝卡(银联卡)" , @"中国农业银行·金穗通宝钻石卡" ,@"中国农业银行·掌尚钱包" ,@"中国农业银行·银联IC卡金卡" , @"中国农业银行·银联预算单位公务卡金卡" , @"中国农业银行·银联IC卡白金卡" , @"中国农业银行·金穗公务卡" ,@"中国农业银行·IC普卡" ,@"中国农业银行·IC金卡" ,@"中国农业银行·澳元卡" ,@"中国农业银行·欧元卡" ,@"中国农业银行·金穗通商卡" ,@"中国农业银行·金穗通商卡" ,@"中国农业银行·银联白金卡" ,@"中国农业银行·中国旅游卡" ,@"中国农业银行·银联IC公务卡" , @"中国农业银行·市民卡B卡" , @"中国银行·联名卡" ,@"中国银行·个人普卡" ,@"中国银行·个人金卡" ,@"中国银行·员工普卡" ,@"中国银行·员工金卡" ,@"中国银行·理财普卡" ,@"中国银行·理财金卡" ,@"中国银行·理财银卡" ,@"中国银行·理财白金卡" ,@"中国银行·中行金融IC卡白金卡" , @"中国银行·中行金融IC卡普卡" , @"中国银行·中行金融IC卡金卡" , @"中国银行·中银JCB卡金卡" , @"中国银行·中银JCB卡普卡" , @"中国银行·员工普卡" ,@"中国银行·个人普卡" ,@"中国银行·中银威士信用卡员" ,@"中国银行·中银威士信用卡员" ,@"中国银行·个人白金卡" ,@"中国银行·中银威士信用卡" ,@"中国银行·长城公务卡" ,@"中国银行·长城电子借记卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银威士信用卡员" ,@"中国银行·长城万事达信用卡" ,@"中国银行·长城万事达信用卡" ,@"中国银行·长城万事达信用卡" ,@"中国银行·长城万事达信用卡" ,@"中国银行·长城万事达信用卡" ,@"中国银行·中银奥运信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城万事达信用卡" ,@"中国银行·长城公务卡" ,@"中国银行·长城公务卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·中银万事达信用卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·银联单币" ,@"中国银行·长城信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城信用卡" ,@"中国银行·长城电子借记卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·银联标准公务卡" ,@"中国银行·一卡双账户普卡" ,@"中国银行·财互通卡" ,@"中国银行·电子现金卡" ,@"中国银行·长城人民币信用卡" ,@"中国银行·长城单位信用卡普卡" ,@"中国银行·中银女性主题信用卡" ,@"中国银行·长城单位信用卡金卡" ,@"中国银行·白金卡" ,@"中国银行·中职学生资助卡" ,@"中国银行·银联标准卡" ,@"中国银行·金融IC卡" , @"中国银行·长城社会保障卡" ,@"中国银行·世界卡" ,@"中国银行·社保联名卡" ,@"中国银行·社保联名卡" ,@"中国银行·医保联名卡" ,@"中国银行·医保联名卡" ,@"中国银行·公司借记卡" ,@"中国银行·银联美运顶级卡" ,@"中国银行·长城福农借记卡金卡" ,@"中国银行·长城福农借记卡普卡" ,@"中国银行·中行金融IC卡普卡" , @"中国银行·中行金融IC卡金卡" , @"中国银行·中行金融IC卡白金卡" , @"中国银行·长城银联公务IC卡白金卡" , @"中国银行·中银旅游信用卡" ,@"中国银行·长城银联公务IC卡金卡" , @"中国银行·中国旅游卡" ,@"中国银行·武警军人保障卡" ,@"中国银行·社保联名借记IC卡" , @"中国银行·社保联名借记IC卡" , @"中国银行·医保联名借记IC卡" , @"中国银行·医保联名借记IC卡" , @"中国银行·借记IC个人普卡" , @"中国银行·借记IC个人金卡" , @"中国银行·借记IC个人普卡" , @"中国银行·借记IC白金卡" , @"中国银行·借记IC钻石卡" , @"中国银行·借记IC联名卡" , @"中国银行·普通高中学生资助卡" , @"中国银行·长城环球通港澳台旅游金卡" , @"中国银行·长城环球通港澳台旅游白金卡" , @"中国银行·中银福农信用卡" ,@"中国银行·借记卡" ,@"中国银行雅加达分行·借记卡" ,@"中国银行首尔分行·借记卡" ,@"中国银行·人民币信用卡" ,@"中国银行·人民币信用卡" ,@"中国银行·中银卡" ,@"中国银行·中银卡" ,@"中国银行·中银卡" ,@"中国银行·中银银联双币商务卡" , @"中国银行·预付卡" ,@"中国银行·澳门中国银行银联预付卡" , @"中国银行·澳门中国银行银联预付卡" , @"中国银行·熊猫卡" ,@"中国银行·财富卡" ,@"中国银行·银联港币卡" ,@"中国银行·银联澳门币卡" ,@"中国银行马尼拉分行·双币种借记卡" ,@"中国银行·借记卡" ,@"中国银行·借记卡" ,@"中国银行·长城信用卡环球通" , @"中国银行·借记卡" ,@"中国建设银行·龙卡准" ,@"中国建设银行·龙卡准金卡" ,@"中国建设银行·中职学生资助卡" ,@"中国建设银行·乐当家银卡VISA" ,@"中国建设银行·乐当家金卡VISA" ,@"中国建设银行·乐当家白金卡" ,@"中国建设银行·龙卡普通卡VISA" ,@"中国建设银行·龙卡储蓄卡" ,@"中国建设银行·VISA准(银联卡)" , @"中国建设银行·VISA准贷记金卡" , @"中国建设银行·乐当家" ,@"中国建设银行·乐当家" ,@"中国建设银行·准贷记金卡" ,@"中国建设银行·乐当家白金卡" ,@"中国建设银行·金融复合IC卡" , @"中国建设银行·银联标准卡" ,@"中国建设银行·银联理财钻石卡" ,@"中国建设银行·金融IC卡" , @"中国建设银行·理财白金卡" ,@"中国建设银行·社保IC卡" , @"中国建设银行·财富卡私人银行卡" ,@"中国建设银行·理财金卡" ,@"中国建设银行·福农卡" ,@"中国建设银行·武警军人保障卡" ,@"中国建设银行·龙卡通" ,@"中国建设银行·银联储蓄卡" ,@"中国建设银行·龙卡储蓄卡(银联卡)" , @"中国建设银行·准" ,@"中国建设银行·理财白金卡" ,@"中国建设银行·理财金卡" ,@"中国建设银行·准普卡" ,@"中国建设银行·准金卡" ,@"中国建设银行·龙卡信用卡" ,@"中国建设银行·建行陆港通龙卡" ,@"中国建设银行·普通高中学生资助卡" ,@"中国建设银行·中国旅游卡" ,@"中国建设银行·龙卡JCB金卡" , @"中国建设银行·龙卡JCB白金卡" , @"中国建设银行·龙卡JCB普卡" , @"中国建设银行·龙卡公司卡" , @"中国建设银行·龙卡" ,@"中国建设银行·龙卡国际普通卡VISA" , @"中国建设银行·龙卡国际金卡VISA" , @"中国建设银行·VISA白金信用卡" , @"中国建设银行·龙卡国际白金卡" , @"中国建设银行·龙卡国际普通卡MASTER" , @"中国建设银行·龙卡国际金卡MASTER" , @"中国建设银行·龙卡万事达金卡" , @"中国建设银行·龙卡" ,@"中国建设银行·龙卡万事达白金卡" ,@"中国建设银行·龙卡" ,@"中国建设银行·龙卡万事达信用卡" ,@"中国建设银行·龙卡人民币信用卡" ,@"中国建设银行·龙卡人民币信用金卡" ,@"中国建设银行·龙卡人民币白金卡" ,@"中国建设银行·龙卡IC信用卡普卡" , @"中国建设银行·龙卡IC信用卡金卡" , @"中国建设银行·龙卡IC信用卡白金卡" , @"中国建设银行·龙卡银联公务卡普卡" , @"中国建设银行·龙卡银联公务卡金卡" , @"中国建设银行·中国旅游卡" ,@"中国建设银行·中国旅游卡" ,@"中国建设银行·龙卡IC公务卡" , @"中国建设银行·龙卡IC公务卡" , @"交通银行·交行预付卡" ,@"交通银行·世博预付IC卡" , @"交通银行·太平洋互连卡" ,@"交通银行·太平洋万事顺卡" ,@"交通银行·太平洋互连卡(银联卡)" , @"交通银行·太平洋白金信用卡" ,@"交通银行·太平洋双币" ,@"交通银行·太平洋双币" ,@"交通银行·太平洋双币" ,@"交通银行·太平洋白金信用卡" ,@"交通银行·太平洋双币" ,@"交通银行·太平洋万事顺卡" ,@"交通银行·太平洋人民币" ,@"交通银行·太平洋人民币" ,@"交通银行·太平洋双币" ,@"交通银行·太平洋准" ,@"交通银行·太平洋准" ,@"交通银行·太平洋准" ,@"交通银行·太平洋准" ,@"交通银行·太平洋借记卡" ,@"交通银行·太平洋借记卡" ,@"交通银行·太平洋人民币" ,@"交通银行·太平洋借记卡" ,@"交通银行·太平洋MORE卡" , @"交通银行·白金卡" ,@"交通银行·交通银行公务卡普卡" ,@"交通银行·太平洋人民币" ,@"交通银行·太平洋互连卡" ,@"交通银行·太平洋借记卡" ,@"交通银行·太平洋万事顺卡" ,@"交通银行·太平洋(银联卡)" , @"交通银行·太平洋(银联卡)" , @"交通银行·太平洋(银联卡)" , @"交通银行·太平洋(银联卡)" , @"交通银行·交通银行公务卡金卡" , @"交通银行·交银IC卡" , @"交通银行香港分行·交通银行港币借记卡" , @"交通银行香港分行·港币礼物卡" , @"交通银行香港分行·双币种信用卡" , @"交通银行香港分行·双币种信用卡" , @"交通银行香港分行·双币卡" ,@"交通银行香港分行·银联人民币卡" ,@"交通银行·银联借记卡" ,@"中信银行·中信借记卡" ,@"中信银行·中信借记卡" ,@"中信银行·中信国际借记卡" ,@"中信银行·中信国际借记卡" ,@"中信银行·中国旅行卡" ,@"中信银行·中信借记卡(银联卡)" , @"中信银行·中信借记卡(银联卡)" , @"中信银行·中信贵宾卡(银联卡)" , @"中信银行·中信理财宝金卡" ,@"中信银行·中信理财宝白金卡" ,@"中信银行·中信钻石卡" ,@"中信银行·中信钻石卡" ,@"中信银行·中信借记卡" ,@"中信银行·中信理财宝(银联卡)" , @"中信银行·中信理财宝(银联卡)" , @"中信银行·中信理财宝(银联卡)" , @"中信银行·借记卡" ,@"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·主账户复合电子现金卡" , @"光大银行·阳光商旅信用卡" ,@"光大银行·阳光商旅信用卡" ,@"光大银行·阳光商旅信用卡" ,@"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·借记卡普卡" ,@"光大银行·社会保障IC卡" , @"光大银行·IC借记卡普卡" ,@"光大银行·手机支付卡" ,@"光大银行·联名IC卡普卡" , @"光大银行·借记IC卡白金卡" , @"光大银行·借记IC卡金卡" , @"光大银行·阳光旅行卡" ,@"光大银行·借记IC卡钻石卡" , @"光大银行·联名IC卡金卡" , @"光大银行·联名IC卡白金卡" , @"光大银行·联名IC卡钻石卡" , @"华夏银行·华夏卡(银联卡)" , @"华夏银行·华夏白金卡" ,@"华夏银行·华夏普卡" ,@"华夏银行·华夏金卡" ,@"华夏银行·华夏白金卡" ,@"华夏银行·华夏钻石卡" ,@"华夏银行·华夏卡(银联卡)" , @"华夏银行·华夏至尊金卡(银联卡)" , @"华夏银行·华夏丽人卡(银联卡)" , @"华夏银行·华夏万通卡" ,@"民生银行·民生借记卡(银联卡)" , @"民生银行·民生银联借记卡－金卡" , @"民生银行·钻石卡" ,@"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡" ,@"民生银行·民生国际卡" ,@"民生银行·民生国际卡(银卡)" , @"民生银行·民生国际卡(欧元卡)" , @"民生银行·民生国际卡(澳元卡)" , @"民生银行·民生国际卡" ,@"民生银行·民生国际卡" ,@"民生银行·薪资理财卡" ,@"民生银行·借记卡普卡" ,@"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生JCB信用卡" , @"民生银行·民生JCB金卡" , @"民生银行·民生(银联卡)" , @"民生银行·民生(银联卡)" , @"民生银行·民生(银联卡)" , @"民生银行·民生(银联卡)" , @"民生银行·民生(银联卡)" , @"民生银行·民生JCB普卡" , @"民生银行·民生(银联卡)" , @"民生银行·民生(银联卡)" , @"民生银行·民生信用卡(银联卡)" , @"民生银行·民生信用卡(银联卡)" , @"民生银行·民生银联白金信用卡" , @"民生银行·民生(银联卡)" , @"民生银行·民生银联个人白金卡" , @"民生银行·公务卡金卡" ,@"民生银行·民生(银联卡)" , @"民生银行·民生银联商务信用卡" , @"民生银行·民VISA无限卡" , @"民生银行·民生VISA商务白金卡" , @"民生银行·民生万事达钛金卡" ,@"民生银行·民生万事达世界卡" ,@"民生银行·民生万事达白金公务卡" ,@"民生银行·民生JCB白金卡" , @"民生银行·银联标准金卡" ,@"民生银行·银联芯片普卡" ,@"民生银行·民生运通双币信用卡普卡" ,@"民生银行·民生运通双币信用卡金卡" ,@"民生银行·民生运通双币信用卡钻石卡" , @"民生银行·民生运通双币标准信用卡白金卡" , @"民生银行·银联芯片金卡" ,@"民生银行·银联芯片白金卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·两地一卡通" ,@"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" ,@"招商银行·VISA商务信用卡" ,@"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招行国际卡(银联卡)" , @"招商银行·世纪金花联名信用卡" , @"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" ,@"招商银行·万事达信用卡" ,@"招商银行·万事达信用卡" ,@"招商银行·万事达信用卡" ,@"招商银行·万事达信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·一卡通(银联卡)" , @"招商银行·万事达信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·一卡通(银联卡)" , @"招商银行·公司卡(银联卡)" , @"招商银行·金卡" ,@"招商银行·招行一卡通" ,@"招商银行·招行一卡通" ,@"招商银行·万事达信用卡" ,@"招商银行·金葵花卡" ,@"招商银行·电子现金卡" ,@"招商银行·银联IC普卡" , @"招商银行·银联IC金卡" , @"招商银行·银联金葵花IC卡" , @"招商银行·IC公务卡" ,@"招商银行·招商银行信用卡" ,@"招商银行·美国运通绿卡" ,@"招商银行·美国运通金卡" ,@"招商银行·美国运通商务绿卡" , @"招商银行·美国运通商务金卡" , @"招商银行·VISA信用卡" , @"招商银行·MASTER信用卡" , @"招商银行·MASTER信用金卡" , @"招商银行·银联标准公务卡(金卡)" , @"招商银行·VISA信用卡" , @"招商银行·银联标准财政公务卡" , @"招商银行·芯片IC信用卡" , @"招商银行·芯片IC信用卡" , @"招商银行·香港一卡通" , @"兴业银行·兴业卡(银联卡)" , @"兴业银行·兴业卡(银联标准卡)" , @"兴业银行·兴业自然人生理财卡" , @"兴业银行·兴业智能卡(银联卡)" , @"兴业银行·兴业智能卡" ,@"兴业银行·visa标准双币个人普卡" , @"兴业银行·VISA商务普卡" ,@"兴业银行·VISA商务金卡" ,@"兴业银行·VISA运动白金信用卡" ,@"兴业银行·万事达信用卡(银联卡)" , @"兴业银行·VISA信用卡(银联卡)" , @"兴业银行·加菲猫信用卡" ,@"兴业银行·个人白金卡" ,@"兴业银行·银联信用卡(银联卡)" , @"兴业银行·银联信用卡(银联卡)" , @"兴业银行·银联白金信用卡" ,@"兴业银行·银联标准公务卡" ,@"兴业银行·VISA信用卡(银联卡)" , @"兴业银行·万事达信用卡(银联卡)" , @"兴业银行·银联标准贷记普卡" ,@"兴业银行·银联标准贷记金卡" ,@"兴业银行·银联标准贷记金卡" ,@"兴业银行·银联标准贷记金卡" ,@"兴业银行·兴业信用卡" ,@"兴业银行·兴业信用卡" ,@"兴业银行·兴业信用卡" ,@"兴业银行·银联标准贷记普卡" ,@"兴业银行·银联标准贷记普卡" ,@"兴业银行·兴业芯片普卡" ,@"兴业银行·兴业芯片金卡" ,@"兴业银行·兴业芯片白金卡" ,@"兴业银行·兴业芯片钻石卡" ,@"上海浦东发展银行·浦发JCB金卡" , @"上海浦东发展银行·浦发JCB白金卡" , @"上海浦东发展银行·信用卡VISA普通" , @"上海浦东发展银行·信用卡VISA金卡" , @"上海浦东发展银行·浦发银行VISA年青卡" , @"上海浦东发展银行·VISA白金信用卡" , @"上海浦东发展银行·浦发万事达白金卡" , @"上海浦东发展银行·浦发JCB普卡" , @"上海浦东发展银行·浦发万事达金卡" , @"上海浦东发展银行·浦发万事达普卡" , @"上海浦东发展银行·浦发单币卡" ,@"上海浦东发展银行·浦发银联单币麦兜普卡" , @"上海浦东发展银行·东方轻松理财卡" , @"上海浦东发展银行·东方-轻松理财卡普卡" , @"上海浦东发展银行·东方轻松理财卡" , @"上海浦东发展银行·东方轻松理财智业金卡" , @"上海浦东发展银行·东方卡(银联卡)" , @"上海浦东发展银行·东方卡(银联卡)" , @"上海浦东发展银行·东方卡(银联卡)" , @"上海浦东发展银行·公务卡金卡" ,@"上海浦东发展银行·公务卡普卡" ,@"上海浦东发展银行·东方卡" ,@"上海浦东发展银行·东方卡" ,@"上海浦东发展银行·浦发单币卡" ,@"上海浦东发展银行·浦发联名信用卡" ,@"上海浦东发展银行·浦发银联白金卡" ,@"上海浦东发展银行·轻松理财普卡" ,@"上海浦东发展银行·移动联名卡" ,@"上海浦东发展银行·轻松理财消贷易卡" ,@"上海浦东发展银行·轻松理财普卡（复合卡）" , @"上海浦东发展银行·" ,@"上海浦东发展银行·" ,@"上海浦东发展银行·东方借记卡（复合卡）" , @"上海浦东发展银行·电子现金卡（IC卡）" , @"上海浦东发展银行·移动浦发联名卡" , @"上海浦东发展银行·东方-标准准" , @"上海浦东发展银行·轻松理财金卡（复合卡）" , @"上海浦东发展银行·轻松理财白金卡（复合卡）" , @"上海浦东发展银行·轻松理财钻石卡（复合卡）" , @"上海浦东发展银行·东方卡" ,@"恒丰银行·九州IC卡" , @"恒丰银行·九州借记卡(银联卡)" , @"恒丰银行·九州借记卡(银联卡)" , @"天津市商业银行·银联卡(银联卡)" , @"烟台商业银行·金通卡" ,@"潍坊银行·鸢都卡(银联卡)" , @"潍坊银行·鸳都卡(银联卡)" , @"临沂商业银行·沂蒙卡(银联卡)" , @"临沂商业银行·沂蒙卡(银联卡)" , @"日照市商业银行·黄海卡" ,@"日照市商业银行·黄海卡(银联卡)" , @"浙商银行·商卡" ,@"浙商银行·商卡" ,@"渤海银行·浩瀚金卡" ,@"渤海银行·渤海银行借记卡" ,@"渤海银行·金融IC卡" , @"渤海银行·渤海银行公司借记卡" , @"星展银行·星展银行借记卡" ,@"星展银行·星展银行借记卡" ,@"恒生银行·恒生通财卡" ,@"恒生银行·恒生优越通财卡" ,@"新韩银行·新韩卡" ,@"上海银行·慧通钻石卡" ,@"上海银行·慧通金卡" ,@"上海银行·私人银行卡" ,@"上海银行·综合保险卡" ,@"上海银行·申卡社保副卡(有折)" , @"上海银行·申卡社保副卡(无折)" , @"上海银行·白金IC借记卡" , @"上海银行·慧通白金卡(配折)" , @"上海银行·慧通白金卡(不配折)" , @"上海银行·申卡(银联卡)" , @"上海银行·申卡借记卡" ,@"上海银行·银联申卡(银联卡)" , @"上海银行·单位借记卡" ,@"上海银行·首发纪念版IC卡" , @"上海银行·申卡" ,@"上海银行·申卡" ,@"上海银行·J分期付款信用卡" ,@"上海银行·申卡" ,@"上海银行·申卡" ,@"上海银行·上海申卡IC" ,@"上海银行·申卡" ,@"上海银行·申卡普通卡" ,@"上海银行·申卡金卡" ,@"上海银行·万事达白金卡" ,@"上海银行·万事达星运卡" ,@"上海银行·申卡金卡" ,@"上海银行·申卡普通卡" ,@"上海银行·安融卡" ,@"上海银行·分期付款信用卡" ,@"上海银行·信用卡" ,@"上海银行·个人公务卡" ,@"上海银行·安融卡" ,@"上海银行·上海银行银联白金卡" ,@"上海银行·贷记IC卡" , @"上海银行·中国旅游卡（IC普卡）" , @"上海银行·中国旅游卡（IC金卡）" , @"上海银行·中国旅游卡（IC白金卡）" , @"上海银行·万事达钻石卡" ,@"上海银行·淘宝IC普卡" , @"北京银行·京卡借记卡" ,@"北京银行·京卡(银联卡)" , @"北京银行·京卡借记卡" ,@"北京银行·京卡" ,@"北京银行·京卡" ,@"北京银行·借记IC卡" , @"北京银行·京卡贵宾金卡" ,@"北京银行·京卡贵宾白金卡" ,@"吉林银行·君子兰一卡通(银联卡)" , @"吉林银行·君子兰卡(银联卡)" , @"吉林银行·长白山金融IC卡" , @"吉林银行·信用卡" ,@"吉林银行·信用卡" ,@"吉林银行·公务卡" ,@"镇江市商业银行·金山灵通卡(银联卡)" , @"镇江市商业银行·金山灵通卡(银联卡)" , @"宁波银行·银联标准卡" ,@"宁波银行·汇通借记卡" ,@"宁波银行·汇通卡(银联卡)" , @"宁波银行·明州卡" ,@"宁波银行·汇通借记卡" ,@"宁波银行·汇通国际卡银联双币卡" ,@"宁波银行·汇通国际卡银联双币卡" ,@"平安银行·新磁条借记卡" ,@"平安银行·平安银行IC借记卡" , @"平安银行·万事顺卡" ,@"平安银行·平安银行借记卡" ,@"平安银行·平安银行借记卡" ,@"平安银行·万事顺借记卡" ,@"焦作市商业银行·月季借记卡(银联卡)" , @"焦作市商业银行·月季城市通(银联卡)" , @"焦作市商业银行·中国旅游卡" ,@"温州银行·金鹿卡" ,@"汉口银行·九通卡(银联卡)" , @"汉口银行·九通卡" ,@"汉口银行·借记卡" ,@"汉口银行·借记卡" ,@"盛京银行·玫瑰卡" ,@"盛京银行·玫瑰IC卡" , @"盛京银行·玫瑰IC卡" , @"盛京银行·玫瑰卡" ,@"盛京银行·玫瑰卡" ,@"盛京银行·玫瑰卡(银联卡)" , @"盛京银行·玫瑰卡(银联卡)" , @"盛京银行·盛京银行公务卡" ,@"洛阳银行·都市一卡通(银联卡)" , @"洛阳银行·都市一卡通(银联卡)" , @"洛阳银行·--" ,@"大连银行·北方明珠卡" ,@"大连银行·人民币借记卡" ,@"大连银行·金融IC借记卡" , @"大连银行·大连市社会保障卡" ,@"大连银行·借记IC卡" , @"大连银行·借记IC卡" , @"大连银行·大连市商业银行" , @"大连银行·大连市商业银行" , @"大连银行·银联标准公务卡" ,@"苏州市商业银行·姑苏卡" ,@"杭州商业银行·西湖卡" ,@"杭州商业银行·西湖卡" ,@"杭州商业银行·借记IC卡" , @"杭州商业银行·" ,@"南京银行·梅花信用卡公务卡" ,@"南京银行·梅花信用卡商务卡" ,@"南京银行·梅花(银联卡)" , @"南京银行·梅花借记卡(银联卡)" , @"南京银行·白金卡" ,@"南京银行·商务卡" ,@"东莞市商业银行·万顺通卡(银联卡)" , @"东莞市商业银行·万顺通卡(银联卡)" , @"东莞市商业银行·万顺通借记卡" , @"东莞市商业银行·社会保障卡" ,@"乌鲁木齐市商业银行·雪莲借记IC卡" , @"乌鲁木齐市商业银行·乌鲁木齐市公务卡" , @"乌鲁木齐市商业银行·福农卡" , @"乌鲁木齐市商业银行·福农卡准" , @"乌鲁木齐市商业银行·雪莲准" , @"乌鲁木齐市商业银行·雪莲(银联卡)" , @"乌鲁木齐市商业银行·雪莲借记IC卡" , @"乌鲁木齐市商业银行·雪莲借记卡(银联卡)" , @"乌鲁木齐市商业银行·雪莲卡(银联卡)" , @"绍兴银行·兰花IC借记卡" , @"绍兴银行·社保IC借记卡" , @"绍兴银行·兰花公务卡" ,@"成都商业银行·芙蓉锦程福农卡" ,@"成都商业银行·芙蓉锦程天府通卡" ,@"成都商业银行·锦程卡(银联卡)" , @"成都商业银行·锦程卡金卡" ,@"成都商业银行·锦程卡定活一卡通金卡" , @"成都商业银行·锦程卡定活一卡通" , @"成都商业银行·锦程力诚联名卡" , @"成都商业银行·锦程力诚联名卡" , @"成都商业银行·锦程卡(银联卡)" , @"抚顺银行·借记IC卡" , @"临商银行·借记卡" ,@"宜昌市商业银行·三峡卡(银联卡)" , @"宜昌市商业银行·信用卡(银联卡)" , @"葫芦岛市商业银行·一通卡" ,@"葫芦岛市商业银行·一卡通(银联卡)" , @"天津市商业银行·津卡" ,@"天津市商业银行·津卡(银联卡)" , @"天津市商业银行·贷记IC卡" , @"天津市商业银行·--" ,@"天津银行·商务卡" ,@"宁夏银行·宁夏银行公务卡" ,@"宁夏银行·宁夏银行福农" ,@"宁夏银行·如意卡(银联卡)" , @"宁夏银行·宁夏银行福农借记卡" , @"宁夏银行·如意借记卡" ,@"宁夏银行·如意IC卡" , @"宁夏银行·宁夏银行如意借记卡" , @"宁夏银行·中国旅游卡" ,@"齐商银行·金达卡(银联卡)" , @"齐商银行·金达借记卡(银联卡)" , @"齐商银行·金达IC卡" , @"徽商银行·黄山卡" ,@"徽商银行·黄山卡" ,@"徽商银行·借记卡" ,@"徽商银行·徽商银行中国旅游卡（安徽）" , @"徽商银行合肥分行·黄山卡" ,@"徽商银行芜湖分行·黄山卡(银联卡)" , @"徽商银行马鞍山分行·黄山卡(银联卡)" , @"徽商银行淮北分行·黄山卡(银联卡)" , @"徽商银行安庆分行·黄山卡(银联卡)" , @"重庆银行·长江卡(银联卡)" , @"重庆银行·长江卡(银联卡)" , @"重庆银行·长江卡" ,@"重庆银行·借记IC卡" , @"哈尔滨银行·丁香一卡通(银联卡)" , @"哈尔滨银行·丁香借记卡(银联卡)" , @"哈尔滨银行·丁香卡" ,@"哈尔滨银行·福农借记卡" ,@"无锡市商业银行·太湖金保卡(银联卡)" , @"丹东银行·借记IC卡" , @"丹东银行·丹东银行公务卡" ,@"兰州银行·敦煌卡" ,@"南昌银行·金瑞卡(银联卡)" , @"南昌银行·南昌银行借记卡" ,@"南昌银行·金瑞卡" ,@"晋商银行·晋龙一卡通" ,@"晋商银行·晋龙一卡通" ,@"晋商银行·晋龙卡(银联卡)" , @"青岛银行·金桥通卡" ,@"青岛银行·金桥卡(银联卡)" , @"青岛银行·金桥卡(银联卡)" , @"青岛银行·金桥卡" ,@"青岛银行·借记IC卡" , @"吉林银行·雾凇卡(银联卡)" , @"吉林银行·雾凇卡(银联卡)" , @"南通商业银行·金桥卡(银联卡)" , @"南通商业银行·金桥卡(银联卡)" , @"日照银行·黄海卡、财富卡借记卡" , @"鞍山银行·千山卡(银联卡)" , @"鞍山银行·千山卡(银联卡)" , @"鞍山银行·千山卡" ,@"青海银行·三江银行卡(银联卡)" , @"青海银行·三江卡" ,@"台州银行·大唐" ,@"台州银行·大唐准" ,@"台州银行·大唐卡(银联卡)" , @"台州银行·大唐卡" ,@"台州银行·借记卡" ,@"台州银行·公务卡" ,@"泉州银行·海峡银联卡(银联卡)" , @"泉州银行·海峡储蓄卡" ,@"泉州银行·海峡银联卡(银联卡)" , @"泉州银行·海峡卡" ,@"泉州银行·公务卡" ,@"昆明商业银行·春城卡(银联卡)" , @"昆明商业银行·春城卡(银联卡)" , @"昆明商业银行·富滇IC卡（复合卡）" , @"阜新银行·借记IC卡" , @"嘉兴银行·南湖借记卡(银联卡)" , @"廊坊银行·白金卡" ,@"廊坊银行·金卡" ,@"廊坊银行·银星卡(银联卡)" , @"廊坊银行·龙凤呈祥卡" ,@"内蒙古银行·百灵卡(银联卡)" , @"内蒙古银行·成吉思汗卡" ,@"湖州市商业银行·百合卡" ,@"湖州市商业银行·" ,@"沧州银行·狮城卡" ,@"南宁市商业银行·桂花卡(银联卡)" , @"包商银行·雄鹰卡(银联卡)" , @"包商银行·包头市商业银行借记卡" , @"包商银行·雄鹰" ,@"包商银行·包商银行内蒙古自治区公务卡" , @"包商银行·" ,@"包商银行·借记卡" ,@"连云港市商业银行·金猴神通借记卡" ,@"威海商业银行·通达卡(银联卡)" , @"威海市商业银行·通达借记IC卡" , @"攀枝花市商业银行·攀枝花卡(银联卡)" , @"攀枝花市商业银行·攀枝花卡" ,@"绵阳市商业银行·科技城卡(银联卡)" , @"泸州市商业银行·酒城卡(银联卡)" , @"泸州市商业银行·酒城IC卡" , @"大同市商业银行·云冈卡(银联卡)" , @"三门峡银行·天鹅卡(银联卡)" , @"广东南粤银行·南珠卡(银联卡)" , @"张家口市商业银行·好运IC借记卡" , @"桂林市商业银行·漓江卡(银联卡)" , @"龙江银行·福农借记卡" ,@"龙江银行·联名借记卡" ,@"龙江银行·福农借记卡" ,@"龙江银行·龙江IC卡" , @"龙江银行·社会保障卡" ,@"龙江银行·--" ,@"江苏长江商业银行·长江卡" ,@"徐州市商业银行·彭城借记卡(银联卡)" , @"南充市商业银行·借记IC卡" , @"南充市商业银行·熊猫团团卡" ,@"莱商银行·银联标准卡" ,@"莱芜银行·金凤卡" ,@"莱商银行·借记IC卡" , @"德阳银行·锦程卡定活一卡通" ,@"德阳银行·锦程卡定活一卡通金卡" ,@"德阳银行·锦程卡定活一卡通" ,@"唐山市商业银行·唐山市城通卡" ,@"曲靖市商业银行·珠江源卡" ,@"曲靖市商业银行·珠江源IC卡" , @"温州银行·金鹿信用卡" ,@"温州银行·金鹿信用卡" ,@"温州银行·金鹿公务卡" ,@"温州银行·贷记IC卡" , @"汉口银行·汉口银行" ,@"汉口银行·汉口银行" ,@"汉口银行·九通香港旅游贷记普卡" ,@"汉口银行·九通香港旅游贷记金卡" ,@"汉口银行·" ,@"汉口银行·九通公务卡" ,@"江苏银行·聚宝借记卡" ,@"江苏银行·月季卡" ,@"江苏银行·紫金卡" ,@"江苏银行·绿扬卡(银联卡)" , @"江苏银行·月季卡(银联卡)" , @"江苏银行·九州借记卡(银联卡)" , @"江苏银行·月季卡(银联卡)" , @"江苏银行·聚宝惠民福农卡" ,@"江苏银行·江苏银行聚宝IC借记卡" , @"江苏银行·聚宝IC借记卡VIP卡" , @"长治市商业银行·长治商行银联晋龙卡" , @"承德市商业银行·热河卡" ,@"承德银行·借记IC卡" , @"德州银行·长河借记卡" ,@"德州银行·--" ,@"遵义市商业银行·社保卡" ,@"遵义市商业银行·尊卡" ,@"邯郸市商业银行·邯银卡" ,@"邯郸市商业银行·邯郸银行贵宾IC借记卡" , @"安顺市商业银行·黄果树福农卡" , @"安顺市商业银行·黄果树借记卡" , @"江苏银行·紫金信用卡(公务卡)" , @"江苏银行·紫金信用卡" ,@"江苏银行·天翼联名信用卡" ,@"平凉市商业银行·广成卡" ,@"玉溪市商业银行·红塔卡" ,@"玉溪市商业银行·红塔卡" ,@"浙江民泰商业银行·金融IC卡" , @"浙江民泰商业银行·民泰借记卡" , @"浙江民泰商业银行·金融IC卡C卡" , @"浙江民泰商业银行·银联标准普卡金卡" , @"浙江民泰商业银行·商惠通" ,@"上饶市商业银行·三清山卡" ,@"东营银行·胜利卡" ,@"泰安市商业银行·岱宗卡" ,@"泰安市商业银行·市民一卡通" ,@"浙江稠州商业银行·义卡" ,@"浙江稠州商业银行·义卡借记IC卡" , @"浙江稠州商业银行·公务卡" ,@"自贡市商业银行·借记IC卡" , @"自贡市商业银行·锦程卡" ,@"鄂尔多斯银行·天骄公务卡" ,@"鹤壁银行·鹤卡" ,@"许昌银行·连城卡" ,@"铁岭银行·龙凤卡" ,@"乐山市商业银行·大福卡" ,@"乐山市商业银行·--" ,@"长安银行·长长卡" ,@"长安银行·借记IC卡" , @"重庆三峡银行·财富人生卡" ,@"重庆三峡银行·借记卡" ,@"石嘴山银行·麒麟借记卡" ,@"石嘴山银行·麒麟借记卡" ,@"石嘴山银行·麒麟公务卡" ,@"盘锦市商业银行·鹤卡" ,@"盘锦市商业银行·盘锦市商业银行鹤卡" , @"平顶山银行·平顶山银行公务卡" , @"朝阳银行·鑫鑫通卡" ,@"朝阳银行·朝阳银行福农卡" ,@"朝阳银行·红山卡" ,@"宁波东海银行·绿叶卡" ,@"遂宁市商业银行·锦程卡" ,@"遂宁是商业银行·金荷卡" ,@"保定银行·直隶卡" ,@"保定银行·直隶卡" ,@"凉山州商业银行·锦程卡" ,@"凉山州商业银行·金凉山卡" ,@"漯河银行·福卡" ,@"漯河银行·福源卡" ,@"漯河银行·福源公务卡" ,@"达州市商业银行·锦程卡" ,@"新乡市商业银行·新卡" ,@"晋中银行·九州方圆借记卡" ,@"晋中银行·九州方圆卡" ,@"驻马店银行·驿站卡" ,@"驻马店银行·驿站卡" ,@"驻马店银行·公务卡" ,@"衡水银行·金鼎卡" ,@"衡水银行·借记IC卡" , @"周口银行·如愿卡" ,@"周口银行·公务卡" ,@"阳泉市商业银行·金鼎卡" ,@"阳泉市商业银行·金鼎卡" ,@"宜宾市商业银行·锦程卡" ,@"宜宾市商业银行·借记IC卡" , @"库尔勒市商业银行·孔雀胡杨卡" , @"雅安市商业银行·锦城卡" ,@"雅安市商业银行·--" ,@"安阳银行·安鼎卡" ,@"信阳银行·信阳卡" ,@"信阳银行·公务卡" ,@"信阳银行·信阳卡" ,@"华融湘江银行·华融卡" ,@"华融湘江银行·华融卡" ,@"营口沿海银行·祥云借记卡" ,@"景德镇商业银行·瓷都卡" ,@"哈密市商业银行·瓜香借记卡" ,@"湖北银行·金牛卡" ,@"湖北银行·汉江卡" ,@"湖北银行·借记卡" ,@"湖北银行·三峡卡" ,@"湖北银行·至尊卡" ,@"湖北银行·金融IC卡" , @"西藏银行·借记IC卡" , @"新疆汇和银行·汇和卡" ,@"广东华兴银行·借记卡" ,@"广东华兴银行·华兴银联公司卡" ,@"广东华兴银行·华兴联名IC卡" , @"广东华兴银行·华兴金融IC借记卡" , @"濮阳银行·龙翔卡" ,@"宁波通商银行·借记卡" ,@"甘肃银行·神舟兴陇借记卡" ,@"甘肃银行·甘肃银行神州兴陇IC卡" , @"枣庄银行·借记IC卡" , @"本溪市商业银行·借记卡" ,@"盛京银行·医保卡" ,@"上海农商银行·如意卡(银联卡)" , @"上海农商银行·如意卡(银联卡)" , @"上海农商银行·鑫通卡" ,@"上海农商银行·国际如意卡" ,@"上海农商银行·借记IC卡" , @"常熟市农村商业银行·粒金(银联卡)" , @"常熟市农村商业银行·公务卡" ,@"常熟市农村商业银行·粒金准贷卡" ,@"常熟农村商业银行·粒金借记卡(银联卡)" , @"常熟农村商业银行·粒金IC卡" , @"常熟农村商业银行·粒金卡" ,@"深圳农村商业银行·信通卡(银联卡)" , @"深圳农村商业银行·信通商务卡(银联卡)" , @"深圳农村商业银行·信通卡" ,@"深圳农村商业银行·信通商务卡" ,@"广州农村商业银行·福农太阳卡" ,@"广东南海农村商业银行·盛通卡" ,@"广东南海农村商业银行·盛通卡(银联卡)" , @"佛山顺德农村商业银行·恒通卡(银联卡)" , @"佛山顺德农村商业银行·恒通卡" , @"佛山顺德农村商业银行·恒通卡(银联卡)" , @"江阴农村商业银行·暨阳公务卡" , @"江阴市农村商业银行·合作(银联卡)" , @"江阴农村商业银行·合作借记卡" , @"江阴农村商业银行·合作卡(银联卡)" , @"江阴农村商业银行·暨阳卡" ,@"重庆农村商业银行·江渝借记卡VIP卡" , @"重庆农村商业银行·江渝IC借记卡" , @"重庆农村商业银行·江渝乡情福农卡" , @"东莞农村商业银行·信通卡(银联卡)" , @"东莞农村商业银行·信通卡(银联卡)" , @"东莞农村商业银行·信通信用卡" , @"东莞农村商业银行·信通借记卡" , @"东莞农村商业银行·贷记IC卡" , @"张家港农村商业银行·一卡通(银联卡)" , @"张家港农村商业银行·一卡通(银联卡)" , @"张家港农村商业银行·" ,@"北京农村商业银行·信通卡" ,@"北京农村商业银行·惠通卡" ,@"北京农村商业银行·凤凰福农卡" ,@"北京农村商业银行·惠通卡" ,@"北京农村商业银行·中国旅行卡" ,@"北京农村商业银行·凤凰卡" ,@"天津农村商业银行·吉祥商联IC卡" , @"天津农村商业银行·信通借记卡(银联卡)" , @"天津农村商业银行·借记IC卡",
                          @"鄞州农村合作银行·蜜蜂借记卡(银联卡)" , @"宁波鄞州农村合作银行·蜜蜂电子钱包(IC)" , @"宁波鄞州农村合作银行·蜜蜂IC借记卡" , @"宁波鄞州农村合作银行·蜜蜂贷记IC卡" , @"宁波鄞州农村合作银行·蜜蜂",
                          @"宁波鄞州农村合作银行·公务卡" ,@"成都农村商业银行·福农卡" ,@"成都农村商业银行·福农卡" ,@"珠海农村商业银行·信通卡(银联卡)" , @"太仓农村商业银行·郑和卡(银联卡)" , @"太仓农村商业银行·郑和IC借记卡" , @"无锡农村商业银行·金阿福" ,@"无锡农村商业银行·借记IC卡" , @"黄河农村商业银行·黄河卡" ,@"黄河农村商业银行·黄河富农卡福农卡" , @"黄河农村商业银行·借记IC卡" , @"天津滨海农村商业银行·四海通卡",
                          @"天津滨海农村商业银行·四海通e芯卡" , @"武汉农村商业银行·汉卡" ,@"武汉农村商业银行·汉卡" ,@"武汉农村商业银行·中国旅游卡" ,@"江南农村商业银行·阳湖卡(银联卡)" , @"江南农村商业银行·天天红火卡",
                          @"江南农村商业银行·借记IC卡" , @"海口联合农村商业银行·海口联合农村商业银行合卡" , @"湖北嘉鱼吴江村镇银行·垂虹卡" , @"福建建瓯石狮村镇银行·玉竹卡" , @"浙江平湖工银村镇银行·金平卡" , @"重庆璧山工银村镇银行·翡翠卡",
                          @"重庆农村商业银行·银联标准" ,@"重庆农村商业银行·公务卡" ,@"南阳村镇银行·玉都卡" ,@"晋中市榆次融信村镇银行·魏榆卡" ,@"三水珠江村镇银行·珠江太阳卡" ,@"东营莱商村镇银行·绿洲卡" ,@"中国建设银行·单位结算卡" ,@"玉溪市商业银行·红塔卡",@"广发银行",@"广发银行",@"广发银行",@"广发银行",@"广发银行"];

    //BIN号
    NSArray* bankBin = @[
                         @"621098", @"622150", @"622151", @"622181", @"622188", @"955100", @"621095", @"620062", @"621285", @"621798", @"621799",
                         @"621797", @"620529", @"622199", @"621096", @"621622", @"623219", @"621674", @"623218", @"621599",@"370246", @"370248",
                         @"370249", @"427010", @"427018", @"427019", @"427020", @"427029", @"427030", @"427039", @"370247", @"438125", @"438126",
                         @"451804",@"451810", @"451811", @"458071", @"489734", @"489735", @"489736", @"510529", @"427062", @"524091", @"427064",
                         @"530970", @"530990", @"558360", @"620200", @"620302", @"620402", @"620403" , @"620404", @"524047" , @"620406" , @"620407",
                         @"525498" , @"620409" , @"620410" , @"620411" ,@"620412" ,@"620502", @"620503", @"620405", @"620408", @"620512", @"620602",
                         @"620604", @"620607", @"620611", @"620612", @"620704", @"620706", @"620707", @"620708", @"620709", @"620710", @"620609", @"620712" , @"620713" , @"620714" , @"620802" , @"620711" , @"620904" , @"620905" , @"621001" , @"620902" , @"621103" , @"621105" , @"621106" , @"621107" , @"621102" , @"621203" , @"621204" , @"621205" , @"621206" , @"621207" , @"621208" , @"621209" , @"621210" , @"621302" , @"621303" , @"621202" , @"621305" , @"621306" , @"621307" , @"621309" , @"621311" , @"621313" , @"621211" , @"621315" , @"621304" , @"621402" , @"621404" , @"621405" , @"621406" , @"621407" , @"621408" , @"621409" , @"621410" , @"621502" , @"621317" , @"621511" , @"621602" , @"621603" , @"621604" , @"621605" , @"621608" , @"621609" , @"621610" , @"621611" , @"621612" , @"621613" , @"621614" , @"621615" , @"621616" , @"621617" , @"621607" , @"621606" , @"621804" , @"621807" , @"621813" , @"621814" , @"621817" , @"621901" , @"621904" , @"621905" , @"621906" , @"621907" , @"621908" , @"621909" , @"621910" , @"621911" , @"621912" , @"621913" , @"621915" , @"622002" , @"621903" , @"622004" , @"622005" , @"622006" , @"622007" , @"622008" , @"622010" , @"622011" , @"622012" , @"621914" , @"622015" , @"622016" , @"622003" , @"622018" , @"622019" , @"622020" , @"622102" , @"622103" , @"622104" , @"622105" , @"622013" , @"622111" , @"622114" , @"622200" , @"622017" , @"622202" , @"622203" , @"622208" , @"622210" , @"622211" , @"622212" , @"622213" , @"622214" , @"622110" , @"622220" , @"622223" , @"622225" , @"622229" , @"622230" , @"622231" , @"622232" , @"622233" , @"622234" , @"622235" , @"622237" , @"622215" , @"622239" , @"622240" , @"622245" , @"622224" , @"622303" , @"622304" , @"622305" , @"622306" , @"622307" , @"622308" , @"622309" , @"622238" , @"622314" , @"622315" , @"622317" , @"622302" , @"622402" , @"622403" , @"622404" , @"622313" , @"622504" , @"622505" , @"622509" , @"622513" , @"622517" , @"622502" , @"622604" , @"622605" , @"622606" , @"622510" , @"622703" , @"622715" , @"622806" , @"622902" , @"622903" , @"622706" , @"623002" , @"623006" , @"623008" , @"623011" , @"623012" , @"622904" , @"623015" , @"623100" , @"623202" , @"623301" , @"623400" , @"623500" , @"623602" , @"623803" , @"623901" , @"623014" , @"624100" , @"624200" , @"624301" , @"624402" , @"62451804" , @"62451810" , @"62451811" , @"62458071" , @"623700" , @"628288" , @"624000" , @"628286" , @"622206" , @"621225" , @"526836" , @"513685" , @"543098" , @"458441" , @"620058" , @"621281" , @"622246" , @"900000" , @"544210" , @"548943" , @"370267" , @"621558" , @"621559" , @"621722" , @"621723" , @"620086" , @"621226" , @"402791" , @"427028" , @"427038" , @"548259" , @"356879" , @"356880" , @"356881" , @"356882" , @"528856" , @"621618" , @"620516" , @"621227" , @"621721" , @"900010" , @"625330" , @"625331" , @"625332" , @"623062" , @"622236" , @"621670" , @"524374" , @"550213" , @"374738" , @"374739" , @"621288" , @"625708" , @"625709" , @"622597" , @"622599" , @"360883" , @"360884" , @"625865" , @"625866" , @"625899" , @"621376" , @"620054" , @"620142" , @"621428" , @"625939" , @"621434" , @"625987" , @"621761" , @"621749" , @"620184" , @"621300" , @"621378" , @"625114" , @"622159" , @"621720" , @"625021" , @"625022" , @"621379" , @"620114" , @"620146" , @"621724" , @"625918" , @"621371" , @"620143" , @"620149" , @"621414" , @"625914" , @"621375" , @"620187" , @"621433" , @"625986" , @"621370" , @"625925" , @"622926" , @"622927" , @"622928" , @"622929" , @"622930" , @"622931" , @"620124" , @"620183" , @"620561" , @"625116" , @"622227" , @"621372" , @"621464" , @"625942" , @"622158" , @"625917" , @"621765" , @"620094" , @"620186" , @"621719" , @"621719" , @"621750" , @"621377" , @"620148" , @"620185" , @"621374" , @"621731" , @"621781" , @"552599" , @"623206" , @"621671" , @"620059" , @"403361" , @"404117" , @"404118" , @"404119" , @"404120" , @"404121" , @"463758" , @"514027" , @"519412" , @"519413" , @"520082" , @"520083" , @"558730" , @"621282" , @"621336" , @"621619" , @"622821" , @"622822" , @"622823" , @"622824" , @"622825" , @"622826" , @"622827" , @"622828" , @"622836" , @"622837" , @"622840" , @"622841" , @"622843" , @"622844" , @"622845" , @"622846" , @"622847" , @"622848" , @"622849" , @"623018" , @"625996" , @"625997" , @"625998" , @"628268" , @"625826" , @"625827" , @"548478" , @"544243" , @"622820" , @"622830" , @"622838" , @"625336" , @"628269" , @"620501" , @"621660" , @"621661" , @"621662" , @"621663" , @"621665" , @"621667" , @"621668" , @"621669" , @"621666" , @"625908" , @"625910" , @"625909" , @"356833" , @"356835" , @"409665" , @"409666" , @"409668" , @"409669" , @"409670" , @"409671" , @"409672" , @"456351" , @"512315" , @"512316" , @"512411" , @"512412" , @"514957" , @"409667" , @"518378" , @"518379" , @"518474" , @"518475" , @"518476" , @"438088" , @"524865" , @"525745" , @"525746" , @"547766" , @"552742" , @"553131" , @"558868" , @"514958" , @"622752" , @"622753" , @"622755" , @"524864" , @"622757" , @"622758" , @"622759" , @"622760" , @"622761" , @"622762" , @"622763" , @"601382" , @"622756" , @"628388" , @"621256" , @"621212" , @"620514" , @"622754" , @"622764" , @"518377" , @"622765" , @"622788" , @"621283" , @"620061" , @"621725" , @"620040" , @"558869" , @"621330" , @"621331" , @"621332" , @"621333" , @"621297" , @"377677" , @"621568" , @"621569" , @"625905" , @"625906" , @"625907" , @"628313" , @"625333" , @"628312" , @"623208" , @"621620" , @"621756" , @"621757" , @"621758" , @"621759" , @"621785" , @"621786" , @"621787" , @"621788" , @"621789" , @"621790" , @"621672" , @"625337" , @"625338" , @"625568" , @"621648" , @"621248" , @"621249" , @"622750" , @"622751" , @"622771" , @"622772" , @"622770" , @"625145" , @"620531" , @"620210" , @"620211" , @"622479" , @"622480" , @"622273" , @"622274" , @"621231" , @"621638" , @"621334" , @"625140" , @"621395" , @"622725" , @"622728" , @"621284" , @"421349" , @"434061" , @"434062" , @"436728" , @"436742" , @"453242" , @"491031" , @"524094" , @"526410" , @"544033" , @"552245" , @"589970" , @"620060" , @"621080" , @"621081" , @"621466" , @"621467" , @"621488" , @"621499" , @"621598" , @"621621" , @"621700" , @"622280" , @"622700" , @"622707" , @"622966" , @"622988" , @"625955" , @"625956" , @"553242" , @"621082" , @"621673" , @"623211" , @"356896" , @"356899" , @"356895" , @"436718" , @"436738" , @"436745" , @"436748" , @"489592" , @"531693" , @"532450" , @"532458" , @"544887" , @"552801" , @"557080" , @"558895" , @"559051" , @"622166" , @"622168" , @"622708" , @"625964" , @"625965" , @"625966" , @"628266" , @"628366" , @"625362" , @"625363" , @"628316" , @"628317" , @"620021" , @"620521" , @"405512" , @"601428" , @"405512" , @"434910" , @"458123" , @"458124" , @"520169" , @"522964" , @"552853" , @"601428" , @"622250" , @"622251" , @"521899" , @"622254" , @"622255" , @"622256" , @"622257" , @"622258" , @"622259" , @"622253" , @"622261" , @"622284" , @"622656" , @"628216" , @"622252" , @"66405512" , @"622260" , @"66601428" , @"955590" , @"955591" , @"955592" , @"955593" , @"628218" , @"622262" , @"621069" , @"620013" , @"625028" , @"625029" , @"621436" , @"621002" , @"621335" , @"433670" , @"433680" , @"442729" , @"442730" , @"620082" , @"622690" , @"622691" , @"622692" , @"622696" , @"622698" , @"622998" , @"622999" , @"433671" , @"968807" , @"968808" , @"968809" , @"621771" , @"621767" , @"621768" , @"621770" , @"621772" , @"621773" , @"620527" , @"356837" , @"356838" , @"486497" , @"622660" , @"622662" , @"622663" , @"622664" , @"622665" , @"622666" , @"622667" , @"622669" , @"622670" , @"622671" , @"622672" , @"622668" , @"622661" , @"622674" , @"622673" , @"620518" , @"621489" , @"621492" , @"620535" , @"623156" , @"621490" , @"621491" , @"620085" , @"623155" , @"623157" , @"623158" , @"623159" , @"999999" , @"621222" , @"623020" , @"623021" , @"623022" , @"623023" , @"622630" , @"622631" , @"622632" , @"622633" , @"622615" , @"622616" , @"622618" , @"622622" , @"622617" , @"622619" , @"415599" , @"421393" , @"421865" , @"427570" , @"427571" , @"472067" , @"472068" , @"622620" , @"621691" , @"545392" , @"545393" , @"545431" , @"545447" , @"356859" , @"356857" , @"407405" , @"421869" , @"421870" , @"421871" , @"512466" , @"356856" , @"528948" , @"552288" , @"622600" , @"622601" , @"622602" , @"517636" , @"622621" , @"628258" , @"556610" , @"622603" , @"464580" , @"464581" , @"523952" , @"545217" , @"553161" , @"356858" , @"622623" , @"625911" , @"377152" , @"377153" , @"377158" , @"377155" , @"625912" , @"625913" , @"356885" , @"356886" , @"356887" , @"356888" , @"356890" , @"402658" , @"410062" , @"439188" , @"439227" , @"468203" , @"479228" , @"479229" , @"512425" , @"521302" , @"524011" , @"356889" , @"545620" , @"545621" , @"545947" , @"545948" , @"552534" , @"552587" , @"622575" , @"622576" , @"622577" , @"622579" , @"622580" , @"545619" , @"622581" , @"622582" , @"622588" , @"622598" , @"622609" , @"690755" , @"690755" , @"545623" , @"621286" , @"620520" , @"621483" , @"621485" , @"621486" , @"628290" , @"622578" , @"370285" , @"370286" , @"370287" , @"370289" , @"439225" , @"518710" , @"518718" , @"628362" , @"439226" , @"628262" , @"625802" , @"625803" , @"621299" , @"966666" , @"622909" , @"622908" , @"438588" , @"438589" , @"461982" , @"486493" , @"486494" , @"486861" , @"523036" , @"451289" , @"527414" , @"528057" , @"622901" , @"622902" , @"622922" , @"628212" , @"451290" , @"524070" , @"625084" , @"625085" , @"625086" , @"625087" , @"548738" , @"549633" , @"552398" , @"625082" , @"625083" , @"625960" , @"625961" , @"625962" , @"625963" , @"356851" , @"356852" , @"404738" , @"404739" , @"456418" , @"498451" , @"515672" , @"356850" , @"517650" , @"525998" , @"622177" , @"622277" , @"622516" , @"622517" , @"622518" , @"622520" , @"622521" , @"622522" , @"622523" , @"628222" , @"628221" , @"984301" , @"984303" , @"622176" , @"622276" , @"622228" , @"621352" , @"621351" , @"621390" , @"621792" , @"625957" , @"625958" , @"621791" , @"620530" , @"625993" , @"622519" , @"621793" , @"621795" , @"621796" , @"622500" , @"623078" , @"622384" , @"940034" , @"940015" , @"622886" , @"622391" , @"940072" , @"622359" , @"940066" , @"622857" , @"940065" , @"621019" , @"622309" , @"621268" , @"622884" , @"621453" , @"622684" , @"621016" , @"621015" , @"622950" , @"622951" , @"621072" , @"623183" , @"623185" , @"621005" , @"622172" , @"622985" , @"622987" , @"622267" , @"622278" , @"622279" , @"622468" , @"622892" , @"940021" , @"621050" , @"620522" , @"356827" , @"356828" , @"356830" , @"402673" , @"402674" , @"438600" , @"486466" , @"519498" , @"520131" , @"524031" , @"548838" , @"622148" , @"622149" , @"622268" , @"356829" , @"622300" , @"628230" , @"622269" , @"625099" , @"625953" , @"625350" , @"625351" , @"625352" , @"519961" , @"625839" , @"421317" , @"602969" , @"621030" , @"621420" , @"621468" , @"623111" , @"422160" , @"422161" , @"622865" , @"940012" , @"623131" , @"622178" , @"622179" , @"628358" , @"622394" , @"940025" , @"621279" , @"622281" , @"622316" , @"940022" , @"621418" , @"512431" , @"520194" , @"621626" , @"623058" , @"602907" , @"622986" , @"622989" , @"622298" , @"622338" , @"940032" , @"623205" , @"621977" , @"990027" , @"622325" , @"623029" , @"623105" , @"621244" , @"623081" , @"623108" , @"566666" , @"622455" , @"940039" , @"622466" , @"628285" , @"622420" , @"940041" , @"623118" , @"603708" , @"622993" , @"623070" , @"623069" , @"623172" , @"623173" , @"622383" , @"622385" , @"628299" , @"603506" , @"603367" , @"622878" , @"623061" , @"623209" , @"628242" , @"622595" , @"622303" , @"622305" , @"621259" , @"622596" , @"622333" , @"940050" , @"621439" , @"623010" , @"621751" , @"628278" , @"625502" , @"625503" , @"625135" , @"622476" , @"621754" , @"622143" , @"940001" , @"623026" , @"623086" , @"628291" , @"621532" , @"621482" , @"622135" , @"622152" , @"622153" , @"622154" , @"622996" , @"622997" , @"940027" , @"623099" , @"623007" , @"940055" , @"622397" , @"622398" , @"940054" , @"622331" , @"622426" , @"625995" , @"621452" , @"628205" , @"628214" , @"625529" , @"622428" , @"621529" , @"622429" , @"621417" , @"623089" , @"623200" , @"940057" , @"622311" , @"623119" , @"622877" , @"622879" , @"621775" , @"623203" , @"603601" , @"622137" , @"622327" , @"622340" , @"622366" , @"622134" , @"940018" , @"623016" , @"623096" , @"940049" , @"622425" , @"622425" , @"621577" , @"622485" , @"623098" , @"628329" , @"621538" , @"940006" , @"621269" , @"622275" , @"621216" , @"622465" , @"940031" , @"621252" , @"622146" , @"940061" , @"621419" , @"623170" , @"622440" , @"940047" , @"940017" , @"622418" , @"623077" , @"622413" , @"940002" , @"623188" , @"622310" , @"940068" , @"622321" , @"625001" , @"622427" , @"940069" , @"623039" , @"628273" , @"622370" , @"683970" , @"940074" , @"621437" , @"628319" , @"990871" , @"622308" , @"621415" , @"623166" , @"622132" , @"621340" , @"621341" , @"622140" , @"623073" , @"622147" , @"621633" , @"622301" , @"623171" , @"621422" , @"622335" , @"622336" , @"622165" , @"622315" , @"628295" , @"625950" , @"621760" , @"622337" , @"622411" , @"623102" , @"622342" , @"623048" , @"622367" , @"622392" , @"623085" , @"622395" , @"622441" , @"622448" , @"621413" , @"622856" , @"621037" , @"621097" , @"621588" , @"623032" , @"622644" , @"623518" , @"622870" , @"622866" , @"623072" , @"622897" , @"628279" , @"622864" , @"621403" , @"622561" , @"622562" , @"622563" , @"622167" , @"622777" , @"621497" , @"622868" , @"622899" , @"628255" , @"625988" , @"622566" , @"622567" , @"622625" , @"622626" , @"625946" , @"628200" , @"621076" , @"504923" , @"622173" , @"622422" , @"622447" , @"622131" , @"940076" , @"621579" , @"622876" , @"622873" , @"622962" , @"622936" , @"623060" , @"622937" , @"623101" , @"621460" , @"622939" , @"622960" , @"623523" , @"621591" , @"622961" , @"628210" , @"622283" , @"625902" , @"621010" , @"622980" , @"623135" , @"621726" , @"621088" , @"620517" , @"622740" , @"625036" , @"621014" , @"621004" , @"622972" , @"623196" , @"621028" , @"623083" , @"628250" , @"623121" , @"621070" , @"628253" , @"622979" , @"621035" , @"621038" , @"621086" , @"621498" , @"621296" , @"621448" , @"622945" , @"621755" , @"622940" , @"623120" , @"628355" , @"621089" , @"623161" , @"628339" , @"621074" , @"621515" , @"623030" , @"621345" , @"621090" , @"623178" , @"621091" , @"623168" , @"621057" , @"623199" , @"621075" , @"623037" , @"628303" , @"621233" , @"621235" , @"621223" , @"621780" , @"621221" , @"623138" , @"628389" , @"621239" , @"623068" , @"621271" , @"628315" , @"621272" , @"621738" , @"621273" , @"623079" , @"621263" , @"621325" , @"623084" , @"621327" , @"621753" , @"628331" , @"623160" , @"621366" , @"621388" , @"621348" , @"621359" , @"621360" , @"621217" , @"622959" , @"621270" , @"622396" , @"622511" , @"623076" , @"621391" , @"621339" , @"621469" , @"621625" , @"623688" , @"623113" , @"621601" , @"621655" , @"621636" , @"623182" , @"623087" , @"621696" , @"622955" , @"622478" , @"940013" , @"621495" , @"621688" , @"623162" , @"622462" , @"628272" , @"625101" , @"622323" , @"623071" , @"603694" , @"622128" , @"622129" , @"623035" , @"623186" , @"621522" , @"622271" , @"940037" , @"940038" , @"985262" , @"622322" , @"628381" , @"622481" , @"622341" , @"940058" , @"623115" , @"621258" , @"621465" , @"621528" , @"622328" , @"940062" , @"625288" , @"623038" , @"625888" , @"622332" , @"940063" , @"623123" , @"622138" , @"621066" , @"621560" , @"621068" , @"620088" , @"621067" , @"622531" , @"622329" , @"623103" , @"622339" , @"620500" , @"621024" , @"622289" , @"622389" , @"628300" , @"625516" , @"621516" , @"622859" , @"622869" , @"623075" , @"622895" , @"623125" , @"622947" , @"621561" , @"623095" , @"621073" , @"623109" , @"621361" , @"623033" , @"623207" , @"622891" , @"621363" , @"623189" , @"623510" , @"622995" , @"621053" , @"621230" , @"621229" , @"622218" , @"628267" , @"621392" , @"621481" , @"621310" , @"621396" , @"623251" , @"628351", @"622568", @"520152", @"520382", @"911121", @"548844"];

    int index = -1;

    if(idCard==nil || idCard.length<16 || idCard.length>19){
        return @"请检查卡号位数";
    }

    //6位Bin号
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    for (int i = 0; i < bankBin.count; i++) {
        if ([cardbin_6 isEqualToString:bankBin[i]]) {
            index = i;
        }
    }
    if (index != -1) {
        return bankName[index];
    }

    //8位Bin号
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    for (int i = 0; i < bankBin.count; i++) {
        if ([cardbin_8 isEqualToString:bankBin[i]]) {
            index = i;
        }
    }
    if (index != -1) {
        return bankName[index];
    }
    return @"未查询到归属银行";
}

@end
