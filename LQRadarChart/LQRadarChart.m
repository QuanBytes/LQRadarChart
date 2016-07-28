//
//  LQRadarChart.m
//  LQRadarChart
//
//  Created by LiQuan on 16/7/14.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "LQRadarChart.h"
static const NSInteger LQRadarChartTitleButtonTag = 32000;
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
    _showPoint = true;
    _fillArea = true;
    _clockwise = true;
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
    UIFont * textFont = [UIFont systemFontOfSize:13];
    if ([_delegate respondsToSelector:@selector(fontOfTitleForRadarChart:)]) {
        textFont = [_delegate fontOfTitleForRadarChart:self];
    }
    NSInteger numOfSetp = MAX([_dataSource numberOfStepForRadarChart:self], 1);
    NSInteger numOfRow = [_dataSource numberOfRowForRadarChart:self];
    NSInteger numOfSection = [_dataSource numberOfSectionForRadarChart:self];
    CGFloat perAngle = (CGFloat)(M_PI * 2) / (CGFloat)(numOfRow) * (CGFloat)(self.clockwise ? 1 : -1);
    CGFloat padding = (CGFloat)(2);
    CGFloat height = MAX(textFont.lineHeight,25);
    CGFloat radius = _radius;
    CGFloat minValue = 0;
    if ([_dataSource respondsToSelector:@selector(minValueForRadarChart:)]) {
        minValue = [_dataSource minValueForRadarChart:self];
    }
    CGFloat maxValue = [_dataSource maxValueForRadarChart:self];;
    
    /// Create  titles
    UIColor *titleColor = [UIColor blackColor];
    if ([_delegate respondsToSelector:@selector(colorOfTitleForRadarChart:)]) {
        titleColor = [_delegate colorOfTitleForRadarChart:self];
    }
    [self createTitleButtonsWithNumOfRow:numOfRow Radius:radius PerAngle:perAngle TextFont:textFont Height:height Padding:padding TitleColor:titleColor];
    CGContextSaveGState(context);
    
    /// Draw the background rectangle
    [self createBackgroundWithNumOfStep:numOfSetp Radius:radius NumOfRow:numOfRow PerAngle:perAngle];
    CGContextRestoreGState(context);
    
    UIColor *separateLineColor = [UIColor grayColor];
    if ([_delegate respondsToSelector:@selector(colorOfSeparateLineForRadarChart:)]) {
        separateLineColor = [_delegate colorOfSeparateLineForRadarChart:self];
    }
    [separateLineColor setStroke];
    [self createLineWithNumOfRow:numOfRow Radius:radius PerAngle:perAngle];
    
    if (numOfRow > 0) {
        [self createSectionsWithNumOfSection:numOfSection NumOfRow:numOfRow MaxValue:maxValue MinValue:minValue Radius:radius PerAngle:perAngle Context:context];
    }

}

- (void)createTitleButtonsWithNumOfRow:(NSInteger)numOfRow Radius:(CGFloat)radius PerAngle:(CGFloat)perAngle TextFont:(UIFont *)textFont Height:(CGFloat)height Padding:(CGFloat)padding TitleColor:(UIColor *)titleColor
{
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
        
        if (index == 0 || (numOfRow%2 == 0 && index == numOfRow/2)) {
            legendCenter.x = _centerPoint.x;
            legendCenter.y = _centerPoint.y + (radius + padding + height / 2.0) *(CGFloat)(index == 0 ? -1 : 1);
        }
        CGRect aRect = CGRectMake(legendCenter.x - width / 2.0, legendCenter.y - height/2.0, width, height);
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:aRect];
        titleButton.tag = LQRadarChartTitleButtonTag + index;
        [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
        [titleButton setTitle:title forState:UIControlStateNormal];
        [titleButton.titleLabel setFont:textFont];
        [titleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
    }
}

- (void)createBackgroundWithNumOfStep:(NSInteger)numOfStep Radius:(CGFloat)radius NumOfRow:(NSInteger)numOfRow PerAngle:(CGFloat)perAngle
{
    for (NSInteger stepTemp = 1; stepTemp <= numOfStep; stepTemp ++) {
        NSInteger step = numOfStep - stepTemp + 1;
        
        UIColor *lineColor = [UIColor grayColor];
        if ([_delegate respondsToSelector:@selector(colorOfLineForRadarChart:step:)]) {
            lineColor = [_delegate colorOfLineForRadarChart:self step:step];
        }
        [lineColor setStroke];
        
        UIColor *fillColor = [UIColor whiteColor];
        if ([_delegate respondsToSelector:@selector(colorOfFillStepForRadarChart:step:)]) {
            fillColor = [_delegate colorOfFillStepForRadarChart:self step:step];
        }
        
        CGFloat scale = (CGFloat)((CGFloat)step / (CGFloat)numOfStep);
        CGFloat innserRadius = scale * radius;
        UIBezierPath * path = [UIBezierPath bezierPath];
        for (NSInteger index = 0; index < numOfRow; index ++) {
            CGFloat i = (CGFloat)index;
            if (index == 0) {
                CGFloat x = _centerPoint.x;
                CGFloat y = _centerPoint.y -  innserRadius ;
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
}

- (void)createLineWithNumOfRow:(NSInteger)numOfRow Radius:(CGFloat)radius PerAngle:(CGFloat)perAngle
{
    for (NSInteger index = 0; index < numOfRow; index ++) {
        CGFloat i = (CGFloat)(index);
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:_centerPoint];
        CGFloat x = _centerPoint.x - radius * sin(i * perAngle);
        CGFloat y = _centerPoint.y - radius * cos(i * perAngle);
        [path addLineToPoint:CGPointMake(x, y)];
        [path stroke];
    }
}

- (void)createSectionsWithNumOfSection:(NSInteger)numOfSection NumOfRow:(NSInteger)numOfRow MaxValue:(CGFloat)maxValue MinValue:(CGFloat)minValue Radius:(CGFloat)radius PerAngle:(CGFloat)perAngle Context:(CGContextRef)context
{
    for (NSInteger section = 0;section < numOfSection; section ++) {
        UIColor *fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        if ([_delegate respondsToSelector:@selector(colorOfSectionFillForRadarChart:section:)]) {
            fillColor = [_delegate colorOfSectionFillForRadarChart:self section:section];
        }
        UIColor *borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
        if ([_delegate respondsToSelector:@selector(colorOfSectionBorderForRadarChart:section:)]) {
            borderColor = [_delegate colorOfSectionBorderForRadarChart:self section:section];
        }
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        for (NSInteger index = 0; index <= numOfRow; index ++) {
            CGFloat i = (CGFloat)(index);
            CGFloat value = [_dataSource valueOfSectionForRadarChart:self row:index  section:section];
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

- (void)reloadData
{
    [self setNeedsDisplay];
}

- (IBAction)buttonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([_delegate respondsToSelector:@selector(radarChart:didSelectedItemAtIndex:)]) {
        [_delegate radarChart:self didSelectedItemAtIndex:button.tag - LQRadarChartTitleButtonTag];
    }
}
@end
