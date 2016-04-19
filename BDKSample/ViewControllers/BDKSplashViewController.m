//
//  BDKSplashViewController.m
//  BDK Sample
//
//  Created by Hyunmin Ryu on 2014. 9. 23..
//  Copyright (c) 2014년 Camp Mobile Inc. All rights reserved.
//


#import "BDKSplashViewController.h"

#import <MediaPlayer/MPMoviePlayerController.h>

#import "BDKLoginViewController.h"


@interface BDKSplashViewController ()

@property (nonatomic, strong) MPMoviePlayerController *splashPlayerController;

@end


#pragma mark -

@implementation BDKSplashViewController

#pragma mark - Instantiation

+ (instancetype)splashViewController {
    return [[self alloc] initWithNibName:nil bundle:nil];
}

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    [self createSplashMoviePlayerController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self showSplash];
}


#pragma mark - View

- (void)createSplashMoviePlayerController {
    NSString *splashFilePath = [[NSBundle mainBundle] pathForResource:[@"launching_animation" stringByDeletingPathExtension] ofType:@"mp4"];
    NSURL *splashMovieUrl = [NSURL fileURLWithPath:splashFilePath];
    
    self.splashPlayerController = [[MPMoviePlayerController alloc] initWithContentURL:splashMovieUrl];
    self.splashPlayerController.backgroundView.backgroundColor = [UIColor whiteColor];
    self.splashPlayerController.controlStyle = MPMovieControlStyleNone;
    self.splashPlayerController.scalingMode = MPMovieScalingModeAspectFit;
    self.splashPlayerController.movieSourceType = MPMovieSourceTypeFile;
    self.splashPlayerController.shouldAutoplay = YES;
    self.splashPlayerController.repeatMode = NO;
    [self.splashPlayerController prepareToPlay];
}


- (void)showSplash {
    [self.splashPlayerController.view setFrame:self.view.bounds];
    [self.view addSubview:self.splashPlayerController.view];
    [self.splashPlayerController play];
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay: 2.0f];
}


- (void)hideSplash {
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:[BDKLoginViewController loginViewController]];
    [navigationViewController.navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication].delegate.window setRootViewController:navigationViewController];
}

@end
