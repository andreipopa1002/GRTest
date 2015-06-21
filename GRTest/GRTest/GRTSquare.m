//
//  GRTSquare.m
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

#import "GRTSquare.h"
#import "UIColor(GRTest).h"

@interface GRTSquare()
@property (nonatomic, assign, readwrite) CGFloat initialSide;

- (CGFloat)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;

@end

@implementation GRTSquare
+ (instancetype)squareWithSide: (CGFloat)side atPoint: (CGPoint)point {
    return [self squareWithSide:side atPoint:point withColour:[UIColor randomColor]];
}

+ (instancetype)squareWithSide:(CGFloat)side atPoint:(CGPoint)point withColour:(UIColor *)backgroundColor {
    GRTSquare *square = [[GRTSquare alloc] initWithFrame:CGRectMake(point.x,
                                                                    point.y,
                                                                    side,
                                                                    side)];
    square.layer.borderWidth = 1.0;
    square.layer.borderColor = [UIColor blackColor].CGColor;
    square.backgroundColor = backgroundColor;
    square.userInteractionEnabled =YES;
    return square;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addPanGestureWithTarget:(NSObject<UIGestureRecognizerDelegate>*)target action:(SEL)action {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:target action:action];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = target;
    [self addGestureRecognizer:panGesture];
}

- (void)addTapGestureWithTarget:(NSObject<UIGestureRecognizerDelegate>*)target action:(SEL)action {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = target;
    [self addGestureRecognizer:tapGesture];
}

- (BOOL)isSquareInsideBlackHoleWithCenter:(CGPoint)blackHoleCenter andRadius:(CGFloat)blackHoleRadius {
    BOOL result = NO;
    // I the square is inside the circle but not contains the circle center
    if ([self distanceFromPoint:blackHoleCenter toPoint:self.center] < blackHoleRadius) {
        // this means that the square is entirely inside the black hole
        return YES;
    }
    // II the square is bigger than the circle and contains entirely the circle without intersecting the circle
    if (CGRectContainsPoint(self.frame, blackHoleCenter)) {
        return YES;
    }
    /*
    III the square sides intersect the cirle
     i)  Considering that a circle ecuation is: (x-a)^2+(y-b)^2=r^2 where the center point is (a,b) and the radius is r
     ii) Our square has 4 sides each of them can be described using a line ecuation and it will have only the form x=SomeValue or y=SomeValue
     Each line may theoretically intersect our circle in one or two points
     Considering i ii the circle ecuation can be rewritten according to x or y in order to calculate the intesection point(s)
        x^2-2ax-a^2+y^2-2by+b^2-r^2=0   delta=(-2a)^2-4(a^2+y^2-2by+b^2-r^2) for line ecuation y=SomeNumber x=-(-2a)+-sqrt(delta)
        y^2-2by-a^1+x^2-2ax+b^2-r^2=0   delta=(-2b)^2-4(b^2+x^2-2ax+a^2-r^2) for line ecuation x=SomeNumber y=-(-2b)+-sqrt(delta)
     Solving the appropriate quadratic equation, for each line, will provide the possible point(s) of intersection. If the point(s) are included in our square side then the square side is intersecting the circle
     D-------------------C
     |                   |
     |                   |
     |                   |
     |                   |
     |                   |
     A-------------------B
     CB side -> x=B.x
     DA side -> x=D.x
     AB side -> y=A.y
     DC side -> y=C.y
     */
    // ecuation according to Y
    // AB side
    CGFloat abSideDelta = [self deltaForLineComponent:CGRectGetMaxY(self.frame)
                                         circleCenter:blackHoleCenter
                                               radius:blackHoleRadius];
    BOOL resultABSide = [self evaluateDelta:abSideDelta
                           forStartingPoint:CGPointMake(self.frame.origin.x,CGRectGetMaxY(self.frame))
                                endingPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
                           withCircleCenter:blackHoleCenter
                           withCircleRadius:blackHoleRadius];
    if (resultABSide) {
        return YES;
    }
    // DC side
    CGFloat dcSideDelta = [self deltaForLineComponent:self.frame.origin.y
                                         circleCenter:blackHoleCenter
                                               radius:blackHoleRadius];
    BOOL resultDCSide = [self evaluateDelta:dcSideDelta
                           forStartingPoint:self.frame.origin
                                endingPoint:CGPointMake(self.frame.origin.x, CGRectGetMaxY(self.frame))
                           withCircleCenter:blackHoleCenter
                           withCircleRadius:blackHoleRadius];
    if (resultDCSide) {
        return YES;
    }
    // ecuation according to X
    blackHoleCenter = CGPointMake(blackHoleCenter.y, blackHoleCenter.x);
    // DA side
    CGFloat daSideDelta = [self deltaForLineComponent:self.frame.origin.x
                                         circleCenter:blackHoleCenter
                                               radius:blackHoleRadius];
    BOOL resultDASide = [self evaluateDelta:daSideDelta
                           forStartingPoint:self.frame.origin
                                endingPoint:CGPointMake(self.frame.origin.x, CGRectGetMaxY(self.frame))
                           withCircleCenter:blackHoleCenter
                           withCircleRadius:blackHoleRadius];
    if (resultDASide) {
        return YES;
    }
    // CB side
    CGFloat cbSideDelta = [self deltaForLineComponent:self.frame.origin.x
                                         circleCenter:blackHoleCenter
                                               radius:blackHoleRadius];
    BOOL resultCBSide = [self evaluateDelta:cbSideDelta
                           forStartingPoint:CGPointMake(CGRectGetMaxX(self.frame), self.frame.origin.x)
                                endingPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
                           withCircleCenter:blackHoleCenter
                           withCircleRadius:blackHoleRadius];
    if (resultCBSide) {
        return YES;
    }
    
    return result;
}

#pragma mark Internal methods

- (CGFloat)deltaForLineComponent:(CGFloat)lineComponent circleCenter:(CGPoint)circleCenter radius:(CGFloat)radius {
    // formula according to  y=SomeNumber
    CGFloat delta = 0.0;
    delta = pow(-2*circleCenter.x, 2);
    delta = delta - 4*(pow(circleCenter.x,2) + pow(lineComponent, 2) - 2*circleCenter.y*lineComponent + pow(circleCenter.y, 2) - pow(radius,2));
    return delta;
}

- (BOOL)lineFrom:(CGPoint)startPoint toPoint:(CGPoint)endPoint containsValue:(CGFloat)intermediateValue {
    BOOL result = NO;
    if (startPoint.x == endPoint.x) {
        // intermediate point on Y axis
        if (startPoint.y > endPoint.y ) {
            //switch values
            CGPoint tempPoint = endPoint;
            endPoint = startPoint;
            startPoint = tempPoint;
        }
        if (startPoint.y <= intermediateValue && intermediateValue <= endPoint.y) {
                result = YES;
        }
    } else {
        // intermediate point on X axis
        if (startPoint.x > endPoint.x) {
            CGPoint tempPoint = endPoint;
            endPoint = startPoint;
            startPoint = tempPoint;
        }
        if (startPoint.x <= intermediateValue && intermediateValue <= endPoint.x) {
            result = YES;
        }
    }
    return result;
}

- (BOOL)evaluateDelta:(CGFloat) delta
     forStartingPoint:(CGPoint) startingPoint
          endingPoint:(CGPoint) endingPoint
     withCircleCenter:(CGPoint) circleCenter
     withCircleRadius:(CGFloat) circleRadius {

    if (delta == 0) {
        CGFloat possibleIntersection = -(-2*circleCenter.x) / 2;
        if ([self lineFrom:startingPoint toPoint:endingPoint containsValue:possibleIntersection]) {
            return YES;
        }
    } else if (delta > 0) {
        CGFloat possibleIntersection1 = (-(-2*circleCenter.x) - sqrt(delta)) / 2;
        if ([self lineFrom:startingPoint toPoint:endingPoint containsValue:possibleIntersection1]) {
            return YES;
        }
        CGFloat possibleIntersection2 = -(-(-2*circleCenter.x) / 2 + sqrt(delta)) / 2;
        if ([self lineFrom:startingPoint toPoint:endingPoint containsValue:possibleIntersection2]) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB {
    return sqrt(pow((pointB.x - pointA.x), 2) + pow((pointB.y - pointA.y), 2));
}

@end
