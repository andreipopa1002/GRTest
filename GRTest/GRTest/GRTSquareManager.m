//
//  GRTSquareManager.m
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

#import "GRTSquareManager.h"
#import "GRTSquare.h"

NSInteger const GRTInitialNumberOfSquares   = 3;
CGFloat const GRTSquareSide             = 100.0;
CGPoint const GRTSquareStartingPoint    = {10.0,20.0};

@interface GRTSquareManager()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) UIView *superView;
@property (nonatomic, assign, readwrite) CGFloat drawingHeight;
@property (nonatomic, assign, readwrite) CGPoint blackHoleCenter;
@property (nonatomic, assign, readwrite) CGFloat blackHoleRadius;

- (void)generateInitialSquares;
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture;
@end

@implementation GRTSquareManager

- (instancetype)initWithSuperView:(UIView* )superView
                    drawingHeight:(CGFloat) drawingHeight
                  blackHoleCenter:(CGPoint) blackHoleCenter
                  blackHoleRadius:(CGFloat) blackHoleRadius {
    self = [super init];
    if (self) {
        _superView = superView;
        [_superView setUserInteractionEnabled:YES];
        _drawingHeight = drawingHeight;
        _blackHoleCenter = blackHoleCenter;
        _blackHoleRadius = blackHoleRadius;
        [self generateInitialSquares];
    }
    return self;
}

- (void)addNewSquare {
    GRTSquare *square = [GRTSquare squareWithSide:GRTSquareSide
                                          atPoint:CGPointMake(arc4random() % (int)((self.superView.bounds.size.width)-GRTSquareSide),arc4random() % (int)(self.drawingHeight - GRTSquareSide))];
    [square addPanGestureWithTarget:self action:@selector(handlePanGesture:)];
    [square addTapGestureWithTarget:self action:@selector(handleTapGesture:)];
    [self.superView addSubview:square];
}

- (void)sendAllSquaresToTheBlackHole {
    for (UIView *subView in self.superView.subviews) {
        if ([subView isKindOfClass:[GRTSquare class]]) {
            [UIView animateWithDuration:1.0
                             animations:^{
                                 subView.frame = CGRectMake(self.blackHoleCenter.x,
                                                                    self.blackHoleCenter.y,
                                                                    0,
                                                                    0);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [subView removeFromSuperview];
                                     
                                 }
                             }];
        }
    }
}

- (void)generateInitialSquares {
    for (int i = 1; i <= GRTInitialNumberOfSquares; i++) {
        GRTSquare *square = [GRTSquare squareWithSide:GRTSquareSide
                                              atPoint:CGPointMake(i * GRTSquareStartingPoint.x, i * GRTSquareStartingPoint.y)];
        [square addPanGestureWithTarget:self action:@selector(handlePanGesture:)];
        [square addTapGestureWithTarget:self action:@selector(handleTapGesture:)];
        [self.superView addSubview:square];
    }
}

# pragma mark Gesture handlers
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    panGesture.view.center = CGPointMake(panGesture.view.center.x + [panGesture translationInView:self.superView].x,
                                         panGesture.view.center.y + [panGesture translationInView:self.superView].y);
    [panGesture setTranslation:CGPointZero inView:self.superView];
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if ([(GRTSquare*)panGesture.view isSquareInsideBlackHoleWithCenter:self.blackHoleCenter andRadius:self.blackHoleRadius]) {
            [UIView animateWithDuration:1.0
                             animations:^{
                                 panGesture.view.frame = CGRectMake(self.blackHoleCenter.x,
                                                                    self.blackHoleCenter.y,
                                                                    0,
                                                                    0);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [panGesture.view removeFromSuperview];
                                     
                                 }
                             }];
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    // at this point no implementation is needed - added this gesture only to bring up the square in the event of a tap
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self.superView bringSubviewToFront:gestureRecognizer.view];
    return YES;
}

@end
