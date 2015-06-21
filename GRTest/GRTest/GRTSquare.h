//
//  GRTSquare.h
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTSquare : UIView

+ (instancetype)squareWithSide: (CGFloat)side atPoint: (CGPoint)point;
+ (instancetype)squareWithSide:(CGFloat)side atPoint:(CGPoint)point withColour:(UIColor *)backgroundColor;
- (void)addPanGestureWithTarget:(NSObject<UIGestureRecognizerDelegate>*)target action:(SEL)action;
- (void)addTapGestureWithTarget:(NSObject<UIGestureRecognizerDelegate>*)target action:(SEL)action;
- (BOOL)isSquareInsideBlackHoleWithCenter:(CGPoint)blackHoleCenter andRadius:(CGFloat)blackHoleRadius;

@end
