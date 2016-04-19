//
//  BDKKeyboardAccessoryView.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKKeyboardAccessoryView.h"

#import "NSString+BDKSample.h"


@interface BDKKeyboardAccessoryView ()

@property (weak, nonatomic) id<BDKKeyboardAccessoryViewDelegate> delegate;

@end


@implementation BDKKeyboardAccessoryView

#pragma mark - Instantiation

+ (instancetype)keyboardAccessoryViewWithDelegate:(id<BDKKeyboardAccessoryViewDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}


- (instancetype)initWithDelegate:(id<BDKKeyboardAccessoryViewDelegate>)delegate {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 44.0f)];
    
    if (self) {
        [self setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6f]];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, CGRectGetHeight(self.frame))];
        [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [closeButton setTitle:[@"Close" bdk_localizedString] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(touchUpInsideCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect frame = closeButton.frame;
        frame.origin.x = screenWidth - CGRectGetWidth(frame);
        [closeButton setFrame:frame];
        
        [self addSubview:closeButton];
        
        [self setDelegate:delegate];
    }
    
    return self;
}


#pragma mark - Action

- (void)touchUpInsideCloseButton:(UIButton *)sender {
    [self.delegate keyboardAccessoryView:self didTouchUpInsideCloseButton:sender];
}

@end
