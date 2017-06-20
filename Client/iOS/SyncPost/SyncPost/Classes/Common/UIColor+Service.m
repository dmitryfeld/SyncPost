//
//  UIColor+Service.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/16/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "UIColor+Service.h"

@implementation UIColor(Service)

- (instancetype) initWithRGBValue:(NSUInteger)rgbValue {
    CGFloat red = ((float)((rgbValue & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((float)((rgbValue & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((float)(rgbValue & 0xFF))/255.0;
    return [self initWithRed:red green:green blue:blue alpha:1.f];
}
- (instancetype) initWithRGBValue:(NSUInteger)rgbValue andAlpha:(CGFloat)alpha {
    CGFloat red = ((float)((rgbValue & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((float)((rgbValue & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((float)(rgbValue & 0xFF))/255.0;
    return [self initWithRed:red green:green blue:blue alpha:alpha];
}
@end
