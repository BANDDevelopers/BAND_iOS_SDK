//
//  BDKKeyboardAccessoryView.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol BDKKeyboardAccessoryViewDelegate;


@interface BDKKeyboardAccessoryView : UIView

+ (instancetype)keyboardAccessoryViewWithDelegate:(id<BDKKeyboardAccessoryViewDelegate>)delegate;

@end


@protocol BDKKeyboardAccessoryViewDelegate <NSObject>

@required

- (void)keyboardAccessoryView:(BDKKeyboardAccessoryView *)keyboardAccessoryView didTouchUpInsideCloseButton:(UIButton *)sender;

@end
