//
//  BDKMessageFormViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKBand, BDKProfile;


@interface BDKMessageFormViewController : UIViewController

+ (instancetype)invitationFormViewControllerWithBand:(BDKBand *)band receiver:(BDKProfile *)receiver;
+ (instancetype)messageFormViewControllerWithBand:(BDKBand *)band receiver:(BDKProfile *)receiver;

@end
