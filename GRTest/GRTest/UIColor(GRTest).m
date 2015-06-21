//
//  UIColor(GRTest).m
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

#import "UIColor(GRTest).h"

@implementation UIColor(GRTest)

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
