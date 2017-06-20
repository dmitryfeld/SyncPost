//
//  UIColor+Service.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/16/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Service)
- (instancetype) initWithRGBValue:(NSUInteger)rgbValue;
- (instancetype) initWithRGBValue:(NSUInteger)rgbValue andAlpha:(CGFloat)alpha;
@end
