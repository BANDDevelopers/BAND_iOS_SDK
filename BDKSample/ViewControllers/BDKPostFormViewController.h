//
//  BDKPostFormViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 29..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKBand;


@interface BDKPostFormViewController : UIViewController

+ (instancetype)postFormViewControllerWithBand:(BDKBand *)band;

@end
