//
//  ZFSlider.m
//  ZFSlider
//
//  Created by amornchai kanokpullwad on 3/2/13.
//  Copyright (c) 2013 amornchai kanokpullwad. All rights reserved.
//

#import "ZFSlider.h"

@interface ZFSlider ()
@property ZFSliderPopup *sliderPopup;
@end

@implementation ZFSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

-(void)setup{
    self.clipsToBounds = NO;
    _sliderPopup = [[ZFSliderPopup alloc] initWithFrame:CGRectMake(-25, -45, 55, 40)];
    [_sliderPopup setUserInteractionEnabled:NO];
    _sliderPopup.alpha = 0;
    [self addSubview:_sliderPopup];
    [self sendSubviewToBack:_sliderPopup];
    
    [self setSliderPopupPositionFromValue:self.value];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self showSliderPopup];
    [self setSliderPopupPositionFromValue:self.value];
    return [super continueTrackingWithTouch:touch withEvent:event];;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self performSelector:@selector(hideSliderPopup) withObject:self afterDelay:2.0];
}

-(void)setSliderPopupPositionFromValue:(float)value {
    
    float percentPoint = ((self.bounds.size.width - 24) * self.value) / (self.maximumValue - self.minimumValue);
    _sliderPopup.label.text = [NSString stringWithFormat:@"%.2f",self.value];
    _sliderPopup.frame = CGRectMake(percentPoint - 16 , -45, 55, 40);
}

-(void)hideSliderPopup{
    [UIView animateWithDuration:0.5 animations:^{
        _sliderPopup.alpha = 0;
    }];
}

-(void)showSliderPopup{
    _sliderPopup.alpha = 1;
}

@end

@interface ZFSliderPopup ()

@end

@implementation ZFSliderPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

-(void)setup{
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width - 16, self.frame.size.height - 16)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.text = @"test";
    
    [self addSubview:_label];
    
}

-(void)drawRect:(CGRect)rect{

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)[UIColor darkGrayColor].CGColor,
                               (id)[UIColor colorWithRed: 0.723 green: 0.723 blue: 0.723 alpha: 1].CGColor,
                               (id)[UIColor whiteColor].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    UIColor* shadow = [UIColor darkGrayColor];
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 2;
    
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2.5, 2.5, 50, 35.5) cornerRadius: 6];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(27.5, 38), CGPointMake(27.5, 2.5), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    [[UIColor grayColor] setStroke];
    roundedRectanglePath.lineWidth = 0.5;
    [roundedRectanglePath stroke];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

@end