//
//  LQRadarChart.m
//  LQRadarChart
//
//  Created by LiQuan on 16/7/14.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "LQRadarChart.h"

@implementation LQRadarChart


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _baseConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _baseConfig];
    }
    return self;
}

- (CGRect)frame
{
    CGRect frame = [super frame];
    if (self.autoCenterPoint) {
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
    }
    
    if (MIN(frame.size.width, frame.size.height) < self.radius * 2) {
        self.radius = MIN(frame.size.width, frame.size.height)/2;
    }
    
    [self reloadData];

    return frame;
}


- (void)_baseConfig
{
    _radius = 80;
    _minValue = 0;
    _maxValue = 5;
    _showPoint = true;
    _showBorder = true;
    _fillArea = true;
    _clockwise = false;
    _autoCenterPoint = true;
    
    [self reloadData];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.dataSource || !context) {
        return;
    }
    
    UIFont * textFont = [_delegate fontOfTitleForRadarChart:self];
    NSInteger numOfSetp = MAX([_dataSource numberOfStepForRadarChart:self], 1);
    NSInteger numOfRow = [_dataSource numberOfRowForRadarChart:self];
    NSInteger numOfSection = [_dataSource numberOfSectionForRadarChart:self];
    CGFloat perAngle = (CGFloat)(M_PI * 2) / (CGFloat)(numOfRow) * (CGFloat)(self.clockwise ? 1 : -1);
    CGFloat padding = (CGFloat)(2);
    CGFloat height = textFont.lineHeight;
    CGFloat radius = _radius;
    CGFloat minValue = _minValue;
    CGFloat maxValue = _maxValue;
    
    UIColor * lineColor = [_delegate colorOfLineForRadarChart:self];
    
    /// Create  titles
    UIColor * titleColor = [_delegate colorOfTitleForRadarChart:self];
    for (NSInteger index = 0; index<numOfRow; index ++) {
        NSInteger i = (CGFloat)index;
        NSString * title = [_dataSource titleOfRowForRadarChart:self row:index];
        CGPoint pointOnEdge = CGPointMake(_centerPoint.x - radius * sin(i * perAngle),
                                          _centerPoint.y - radius * cos(i * perAngle));
        CGSize attributeTextSize = [title sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        CGFloat width = attributeTextSize.width;
        CGFloat xOffset = pointOnEdge.x >=  _centerPoint .x ? width / 2.0 + padding : -width / 2.0 - padding;
        CGFloat yOffset = pointOnEdge.y >=  _centerPoint .y ? height / 2.0 + padding : -height / 2.0 - padding;
        CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset,
                                           pointOnEdge.y + yOffset);
        
        NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        NSDictionary * attributes = @{NSFontAttributeName: textFont,
                                      NSParagraphStyleAttributeName: paragraphStyle,
                                      NSForegroundColorAttributeName: titleColor};
        
        if (index == 0 || (numOfRow%2 == 0 && index == numOfRow/2)) {
            legendCenter.x = _centerPoint.x;
            legendCenter.y = _centerPoint.y + (radius + padding + height / 2.0) *(CGFloat)(index == 0 ? -1 : 1);
        }
        CGRect rect = CGRectMake(legendCenter.x - width / 2.0, legendCenter.y - height/2.0, width, height);
        [title drawInRect:rect withAttributes:attributes];
    }
    
    /// Draw the background rectangle
    CGContextSaveGState(context);
    [lineColor setStroke];
    
    for (NSInteger stepTemp = 1; stepTemp <= numOfSetp; stepTemp ++) {
        NSInteger step = numOfSetp - stepTemp + 1;
        UIColor * fillColor = [_delegate colorOfFillStepForRadarChart:self step:step];
        
        CGFloat scale = (CGFloat)((CGFloat)step / (CGFloat)numOfSetp);
        CGFloat innserRadius = scale * radius;
        UIBezierPath * path = [UIBezierPath bezierPath];
        for (NSInteger index = 0; index < numOfRow; index ++) {
            CGFloat i = (CGFloat)index;
            if (index == 0) {
                CGFloat x = _centerPoint.x;
                CGFloat y = _centerPoint.y;
                [path moveToPoint:CGPointMake(x, y)];
            }else{
                CGFloat x = _centerPoint.x - innserRadius * sin(i * perAngle);
                CGFloat y = _centerPoint.y - innserRadius * cos(i * perAngle);
                [path addLineToPoint:CGPointMake(x, y)];
            }
        }
        
        CGFloat x = _centerPoint.x;
        CGFloat y = _centerPoint.y - innserRadius;
       [path addLineToPoint:CGPointMake(x, y)];
        
        
        [fillColor setFill];
        
        path.lineWidth = 1;
        [path  fill];
        [path stroke];
        
    }
    CGContextRestoreGState(context);
    
    [lineColor setStroke];
    for (NSInteger index = 0; index < numOfRow; index ++) {
        CGFloat i = (CGFloat)(index);
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:_centerPoint];
        CGFloat x = _centerPoint.x - radius * sin(i * perAngle);
        CGFloat y = _centerPoint.y - radius * cos(i * perAngle);
        [path addLineToPoint:CGPointMake(x, y)];
        [path stroke];
        
    }
    
    if (numOfRow > 0) {
        for (NSInteger section = 0;section < numOfSection; section ++) {
            
            UIColor * fillColor = [_delegate colorOfSectionFillForRadarChart:self section: section];
            UIColor *  borderColor = [_delegate colorOfSectionBorderForRadarChart:self  section: section];
            
            UIBezierPath * path = [UIBezierPath bezierPath];
            for (NSInteger index = 0; index < numOfRow; index ++) {
                CGFloat i = (CGFloat)(index);
                CGFloat value = [_dataSource valueOfSectionForRadarChart:self row:0  section:section];
                CGFloat scale = (value - minValue)/(maxValue - minValue);
                CGFloat innserRadius = scale * radius;
                if (index == 0 ){
                    CGFloat x = _centerPoint.x;
                    CGFloat y = _centerPoint.y -  innserRadius;
                    [path moveToPoint:CGPointMake(x, y)];
                } else {
                    CGFloat x = _centerPoint.x - innserRadius * sin(i * perAngle);
                    CGFloat y = _centerPoint.y - innserRadius * cos(i * perAngle);
                    [path addLineToPoint:CGPointMake(x, y)];
                }
            }
            
            CGFloat value = [_dataSource valueOfSectionForRadarChart:self row: 0 section: section];
            CGFloat x = _centerPoint.x;
            CGFloat y = _centerPoint.y - (value - minValue) / (maxValue - minValue) * radius;
            [path addLineToPoint:CGPointMake(x, y)];

            [fillColor setFill];
            [borderColor setStroke];
   
            path.lineWidth = 2;
            [path fill];
            [path stroke];
            
            
            if (self.showPoint) {
                UIColor *borderColor = [_delegate colorOfSectionBorderForRadarChart:self section:section];
                for (NSInteger i = 0; i < numOfRow; i ++) {
                    CGFloat value = [_dataSource valueOfSectionForRadarChart:self row:i section:section];
                    CGFloat xVal = _centerPoint.x - (value - minValue) / (maxValue - minValue) * radius * sin((CGFloat)(i) * perAngle);
                    CGFloat yVal = _centerPoint.y - (value - minValue) / (maxValue - minValue) * radius * cos((CGFloat)(i) * perAngle);
                    [borderColor setFill];
                    CGContextFillEllipseInRect(context, CGRectMake(xVal-3, yVal-3, 6, 6));

                }
            }
        }
    }

}

- (void)reloadData
{
    [self setNeedsDisplay];
}

@end
