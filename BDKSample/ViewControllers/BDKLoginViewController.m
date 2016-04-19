//
//  BDKLoginViewController.m
//  BDK Sample
//
//  Created by Hyunmin Ryu on 2014. 4. 29..
//  Copyright (c) 2014년 Camp Mobile Inc. All rights reserved.
//

#import "BDKLoginViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKMenuViewController.h"

#import "BDKErrorHandler.h"

#import "UIAlertView+BDKSample.h"


@interface BDKLoginViewController ()

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKLoginViewController

#pragma mark - Instantiation

+ (instancetype)loginViewController {
    return [[self alloc] initWithNibName:nil bundle:nil];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    if ([[BDKAuth sharedInstance] isAuthorized]) {
        [self.navigationController pushViewController:[BDKMenuViewController menuViewController] animated:NO];
    }
}


#pragma mark - Action

- (IBAction)touchUpInsideLoginButton:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [BDKAPI loginWithCompletion:^(NSError *error) {
        if (error) {
            [UIAlertView bdk_showError:error withCodeDescription:__PRETTY_FUNCTION__ lineNumber:__LINE__];
            return;
        }
        
        [weakSelf.navigationController pushViewController:[BDKMenuViewController menuViewController] animated:YES];
    }];
}

@end
