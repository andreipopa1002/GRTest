//
//  GRTSquareManager.h
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTSquareManager : NSObject
- (instancetype)initWithSuperView:(UIView* )superView
                    drawingHeight:(CGFloat) drawingHeight
                  blackHoleCenter:(CGPoint) blackHoleCenter
                  blackHoleRadius:(CGFloat) blackHoleRadius;
- (void)addNewSquare;
- (void)sendAllSquaresToTheBlackHole;

@end
