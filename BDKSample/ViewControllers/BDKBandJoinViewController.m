//
//  BDKBandJoinViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKBandJoinViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKKeyboardAccessoryView.h"

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "NSError+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UIAlertView+BDKSample.h"


static UIImage *BDKBandJoinViewDefaultProfileImage;

static NSString *const BDKBandJoinViewPresetNickname = @"Band SDK";
static UIImage  *      BDKBandJoinViewPresetProfileImage;


@interface BDKBandJoinViewController () <BDKKeyboardAccessoryViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) BDKBand *band;
@property (strong, nonatomic) UIImage *profileImage;

@property (weak, nonatomic) IBOutlet UIButton                *presetButton;
@property (weak, nonatomic) IBOutlet UIButton                *clearButton;
@property (weak, nonatomic) IBOutlet UITextField             *nicknameField;
@property (weak, nonatomic) IBOutlet UITextField             *profileImageURLField;
@property (weak, nonatomic) IBOutlet UIImageView             *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton                *reloadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@property (copy, nonatomic) void (^completion)(BDKBand *joinedBand);

@end


#pragma mark -

@implementation BDKBandJoinViewController

#pragma mark - Instantiation

+ (void)initialize {
    [super initialize];
    
    BDKBandJoinViewDefaultProfileImage = [UIImage imageNamed:@"ico_default_profile"];
    BDKBandJoinViewPresetProfileImage = [UIImage imageNamed:@"AppIcon60x60"];
}


+ (instancetype)bandJoinViewControllerWithBand:(BDKBand *)band completion:(void (^)(BDKBand *joinedBand))completion {
    return [[self alloc] initWithBand:band completion:completion];
}


- (instancetype)initWithBand:(BDKBand *)band completion:(void (^)(BDKBand *joinedBand))completion {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        [self setBand:band];
        [self setErrorHandler:[BDKErrorHandler handler]];
        [self setCompletion:completion];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.nicknameField becomeFirstResponder];
}


#pragma mark - View

- (void)setupViews {
    [self setTitle:self.band.name];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[@"Join" bdk_localizedString] style:UIBarButtonItemStyleBordered target:self action:@selector(tapJoinItem:)];
    [self.navigationItem setRightBarButtonItem:item];
    
    [self.presetButton setTitle:[@"Use Presets" bdk_localizedString] forState:UIControlStateNormal];
    [self.clearButton setTitle:[@"Clear All" bdk_localizedString] forState:UIControlStateNormal];
    
    BDKKeyboardAccessoryView *keyboardAccessoryView = [BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self];
    [self.nicknameField setPlaceholder:[@"band.join.nickname.placeholder" bdk_localizedString]];
    [self.nicknameField setInputAccessoryView:keyboardAccessoryView];
    
    [self.profileImageURLField setPlaceholder:[@"band.join.profileImageURL.placeholder" bdk_localizedString]];
    [self.profileImageURLField setInputAccessoryView:keyboardAccessoryView];
    
    [self.profileImageView setImage:BDKBandJoinViewDefaultProfileImage];
    
    [self.reloadButton setTitle:[@"Reload" bdk_localizedString] forState:UIControlStateNormal];
    [self.reloadButton setEnabled:NO];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


- (void)refreshProfileImageWithURL:(NSURL *)URL {
    __weak typeof(self) weakSelf = self;
    [UIImage bdk_loadImageWithURL:URL defaultImage:BDKBandJoinViewDefaultProfileImage size:CGSizeMake(150.0f, 150.0f) completion:^(UIImage *image) {
        [weakSelf setProfileImage:image];
        
        if (image) {
            [weakSelf.profileImageView setImage:image];
        }
    }];
}


#pragma mark - Action

- (void)tapJoinItem:(UIBarButtonItem *)item {
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self requestJoinBandWithCompletion:^(NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
            return;
        }
        
        [UIAlertView bdk_showAlertWithMessage:[[NSString alloc] initWithFormat:[@"band.join.joined" bdk_localizedString], weakSelf.band.name]];
        BDK_RUN_BLOCK(weakSelf.completion, weakSelf.band);
    }];
}


- (IBAction)touchUpInsidePresetButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.nicknameField setText:BDKBandJoinViewPresetNickname];
    
    [self setProfileImage:BDKBandJoinViewPresetProfileImage];
    [self.profileImageView setImage:BDKBandJoinViewPresetProfileImage];
}


- (IBAction)touchUpInsideClearButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.nicknameField setText:nil];
    
    [self setProfileImage:nil];
    [self.profileImageURLField setText:nil];
    [self.profileImageView setImage:nil];
}


- (IBAction)touchUpInsideReloadButton:(UIButton *)sender {
    [self refreshProfileImageWithURL:[[NSURL alloc] initWithString:self.profileImageURLField.text]];
}


- (IBAction)editingChangedProfileImageURLField:(UITextField *)sender {
    [self.reloadButton setEnabled:sender.text.length > 0];
}


#pragma mark - Request

- (void)requestJoinBandWithCompletion:(void (^)(NSError *error))completion {
    [self.indicator startAnimating];
    
    if (self.band.bandKey.length == 0) {
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"bandKey"));
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [BDKAPI joinGuildBandWithBandKey:self.band.bandKey nickname:self.nicknameField.text profileImage:self.profileImage completion:^(NSError *error) {
        [weakSelf.indicator stopAnimating];
        BDK_RUN_BLOCK(completion, error);
    }];
}


#pragma mark - BDKKeyboardAccessoryViewDelegate

- (void)keyboardAccessoryView:(BDKKeyboardAccessoryView *)keyboardAccessoryView didTouchUpInsideCloseButton:(UIButton *)sender {
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.profileImageURLField]) {
        [self refreshProfileImageWithURL:[[NSURL alloc] initWithString:textField.text]];
    }
    
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([textField isEqual:self.profileImageURLField]) {
        [textField setText:nil];
        [self refreshProfileImageWithURL:[[NSURL alloc] initWithString:textField.text]];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nicknameField]) {
        if (self.profileImageURLField.text.length > 0) {
            [self.view endEditing:YES];
        } else {
            [self.profileImageURLField becomeFirstResponder];
        }
    } else if ([textField isEqual:self.profileImageURLField]) {
        if (self.nicknameField.text.length > 0) {
            [self.view endEditing:YES];
        } else {
            [self.nicknameField becomeFirstResponder];
        }
    }
    
    return YES;
}

@end
