//
//  GRTViewController.m
//  GRTest
//
//  Created by Andrei Popa on 02/06/2014.
//  Copyright (c) 2014 Andrei Popa. All rights reserved.
//

CGFloat const GRTButtonWidth                    = 120.0;
CGFloat const GRTButtonHeight                   = 20.0;
CGFloat const GRTButtonRightPadding             = 10.0;
CGFloat const GRTBlackHoleButtonBottomPadding   = 50.0;
CGFloat const GRTAddSquareButtonBotomPadding    = 30.0;
CGFloat const GRTBlackHoleRadius                = 50.0;
CGFloat const GRTBlackHoleLeftPadding           = 10.0;
CGFloat const GRTBlackHoleBotomPadding          = 10.0;

#import "GRTViewController.h"
#import "GRTSquareManager.h"

@interface GRTViewController ()
@property (nonatomic, strong, readwrite) UIButton *blackHoleButton;
@property (nonatomic, strong, readwrite) UIButton *addSquareButton;
@property (nonatomic, strong, readwrite) UIView *blackHoleView;
@property (nonatomic, strong, readwrite) GRTSquareManager *squareManager;


- (void)setupInitialUI;
- (UIButton *)addButtonWithTitle:(NSString *)title forSelector:(SEL)selector;
- (void)createBlackHole;

@end

@implementation GRTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInitialUI];
    self.squareManager = [[GRTSquareManager alloc] initWithSuperView:self.view
                                                       drawingHeight:MIN(self.blackHoleView.frame.origin.y, self.blackHoleButton.frame.origin.y)
                                                     blackHoleCenter:self.blackHoleView.center
                                                     blackHoleRadius:GRTBlackHoleRadius];
}

#pragma mark - Internal Methods
- (void)setupInitialUI {
    // addSquareButton
    if (!self.addSquareButton) {
        self.addSquareButton = [self addButtonWithTitle:@"Add square" forSelector:@selector(addSquareButtonTapped:)];
        self.addSquareButton.frame = CGRectMake(self.view.bounds.size.width - GRTButtonWidth - GRTButtonRightPadding,
                                                self.view.bounds.size.height - GRTAddSquareButtonBotomPadding - GRTButtonHeight,
                                                GRTButtonWidth,
                                                GRTButtonHeight);
        [self.addSquareButton sizeToFit];
        [self.view addSubview:self.addSquareButton];
    }
    // blackHole button
    if (!self.blackHoleButton) {
        self.blackHoleButton = [self addButtonWithTitle:@"Black Hole" forSelector:@selector(blackHoleButtonTapped:)];
        self.blackHoleButton.frame = CGRectMake(self.view.bounds.size.width - GRTButtonWidth - GRTButtonRightPadding,
                                                self.addSquareButton.frame.origin.y - GRTBlackHoleButtonBottomPadding - GRTButtonHeight,
                                                GRTButtonWidth,
                                                GRTButtonHeight);
        [self.blackHoleButton sizeToFit];
        [self.view addSubview:self.blackHoleButton];
    }
    // black hole
    [self createBlackHole];
}

- (UIButton *)addButtonWithTitle:(NSString *)title forSelector:(SEL)selector {
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setTitle:title forState:UIControlStateHighlighted];
    [newButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return  newButton;
}

- (void)createBlackHole {
    if (!self.blackHoleView) {
        self.blackHoleView = [[UIView alloc] initWithFrame:CGRectMake(GRTBlackHoleLeftPadding,
                                                                        self.view.bounds.size.height - GRTBlackHoleBotomPadding - 2*GRTBlackHoleRadius,
                                                                        2*GRTBlackHoleRadius,
                                                                        2*GRTBlackHoleRadius)];
        self.blackHoleView.layer.cornerRadius = GRTBlackHoleRadius;
        self.blackHoleView.layer.borderColor = [UIColor blackColor].CGColor;
        self.blackHoleView.layer.borderWidth = 1.0;
        [self.view addSubview:self.blackHoleView];
    }
}

# pragma mark - Buttons Actions
- (void)blackHoleButtonTapped:(id)sender {
    [self.squareManager sendAllSquaresToTheBlackHole];
}

- (void)addSquareButtonTapped:(id)sender {
    [self.squareManager addNewSquare];
}
@end
