//
//  BDKMessageFormViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKMessageFormViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKKeyboardAccessoryView.h"

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "NSError+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UIAlertView+BDKSample.h"


typedef NS_ENUM(NSInteger, BDKMessageType) {
    BDKMessageTypeDefault,
    BDKMessageTypeInvitation
};


static NSString *BDKMessageFormPresetTitle;
static NSString *BDKMessageFormPresetMessage;
static NSURL    *BDKMessageFormPresetImageURL;
static NSString *BDKMessageFormPresetLinkName;
static NSString *BDKMessageFormPresetAndroidLink;
static NSString *BDKMessageFormPresetIOSLink;


@interface BDKMessageFormViewController () <UITextFieldDelegate, BDKKeyboardAccessoryViewDelegate>

@property (strong, nonatomic) BDKBand        *band;
@property (strong, nonatomic) BDKProfile     *receiver;
@property (assign, nonatomic) BDKMessageType  messageType;

@property (strong, nonatomic) NSArray *responders;

@property (weak, nonatomic) UIBarButtonItem *sendItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *presetButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property (weak, nonatomic) IBOutlet UITextField *attachedImageURLField;
@property (weak, nonatomic) IBOutlet UIImageView *attachedImageView;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (weak, nonatomic) IBOutlet UITextField *linkNameField;
@property (weak, nonatomic) IBOutlet UITextField *androidLinkField;
@property (weak, nonatomic) IBOutlet UITextField *iOSLinkField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldWidthConstraint;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKMessageFormViewController

#pragma mark - Instantiation

+ (void)initialize {
    [super initialize];
    
    BDKMessageFormPresetTitle = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    BDKMessageFormPresetImageURL = [[NSURL alloc] initWithString:@"http://coresos.phinf.naver.net/a/2gjah3_j/aaeUd01597xj4e5668ll_hq3ake.png"];
    BDKMessageFormPresetLinkName = [[NSString alloc] initWithFormat:[@"post.form.snippetLinkName.preset" bdk_localizedString], BDKMessageFormPresetTitle];
}


+ (instancetype)invitationFormViewControllerWithBand:(BDKBand *)band receiver:(BDKProfile *)receiver {
    return [[self alloc] initWithBand:band receiver:receiver messageType:BDKMessageTypeInvitation];
}


+ (instancetype)messageFormViewControllerWithBand:(BDKBand *)band receiver:(BDKProfile *)receiver {
    return [[self alloc] initWithBand:band receiver:receiver messageType:BDKMessageTypeDefault];
}


- (instancetype)initWithBand:(BDKBand *)band receiver:(BDKProfile *)receiver messageType:(BDKMessageType)messageType {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        BDKMessageFormPresetMessage = [[NSString alloc] initWithFormat:[messageType == BDKMessageTypeInvitation ? @"message.form.invitation.preset" : @"message.form.message.preset" bdk_localizedString], BDKMessageFormPresetTitle];
        BDKMessageFormPresetAndroidLink = [[NSString alloc] initWithFormat:@"exec/view?bandKey=%@", self.band.bandKey];
        BDKMessageFormPresetIOSLink = [[NSString alloc] initWithFormat:@"exec/view?bandKey=%@", self.band.bandKey];
        
        [self setBand:band];
        [self setReceiver:receiver];
        [self setMessageType:messageType];
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self registerNotifications];
    
    [self setResponders:@[self.titleField, self.messageField, self.attachedImageURLField, self.linkNameField, self.androidLinkField, self.iOSLinkField]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.titleField becomeFirstResponder];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Determinant

- (BOOL)canSend {
    return self.titleField.text.length > 0 &&
    self.messageField.text.length > 0 &&
    self.attachedImageURLField.text.length > 0 &&
    self.linkNameField.text.length > 0 &&
    (self.androidLinkField.text.length > 0 || self.iOSLinkField.text.length > 0);
}


#pragma mark - View

- (void)setupViews {
    [self setTitle:self.band.name];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[@"Send" bdk_localizedString] style:UIBarButtonItemStyleBordered target:self action:@selector(tapSendItem:)];
    [item setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:item];
    [self setSendItem:item];
    
    [self.presetButton setTitle:[@"Use Presets" bdk_localizedString] forState:UIControlStateNormal];
    [self.clearButton setTitle:[@"Clear All" bdk_localizedString] forState:UIControlStateNormal];
    
    [self.titleField setPlaceholder:[@"message.form.title.placeholder" bdk_localizedString]];
    [self.titleField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    [self.titleFieldWidthConstraint setConstant:CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 20.0f];
    
    [self.messageField setPlaceholder:[@"message.form.message.placeholder" bdk_localizedString]];
    [self.messageField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.attachedImageURLField setPlaceholder:[@"message.form.imageURL.placeholder" bdk_localizedString]];
    [self.attachedImageURLField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    [self.reloadButton setTitle:[@"Reload" bdk_localizedString] forState:UIControlStateNormal];
    
    [self.linkNameField setPlaceholder:[@"message.form.linkName.placeholder" bdk_localizedString]];
    [self.linkNameField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.androidLinkField setPlaceholder:[@"message.form.androidLink.placeholder" bdk_localizedString]];
    [self.androidLinkField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.iOSLinkField setPlaceholder:[@"message.form.iOSLink.placeholder" bdk_localizedString]];
    [self.iOSLinkField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


- (void)refreshAttachedImageWithURL:(NSURL *)URL {
    if (URL.absoluteString.length == 0) {
        [self.attachedImageView setImage:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIImage bdk_loadImageWithURL:URL defaultImage:nil size:CGSizeZero completion:^(UIImage *image) {
        if (image) {
            [weakSelf.attachedImageView setImage:image];
        }
    }];
}


- (UIResponder *)firstResponder {
    for (UIResponder *candidate in self.responders) {
        if ([candidate isFirstResponder]) {
            return candidate;
        }
    }
    
    return nil;
}


- (UIResponder *)nextResponder:(UIResponder *)responder {
    BOOL needsToSearch = NO;
    
    for (UIResponder *candidate in self.responders) {
        BOOL isSelf = [candidate isEqual:responder];
        NSString *text = [candidate respondsToSelector:@selector(text)] ? [candidate performSelector:@selector(text) withObject:nil] : nil;
        
        if (needsToSearch && text.length == 0 && !isSelf) {
            return candidate;
        }
        
        if ([candidate isEqual:responder]) {
            needsToSearch = YES;
        }
    }
    
    for (UIResponder *candidate in self.responders) {
        BOOL isSelf = [candidate isEqual:responder];
        NSString *text = [candidate respondsToSelector:@selector(text)] ? [candidate performSelector:@selector(text) withObject:nil] : nil;
        
        if (needsToSearch && text.length == 0 && !isSelf) {
            return candidate;
        }
        
        if ([candidate isEqual:responder]) {
            needsToSearch = NO;
        }
    }
    
    return nil;
}


#pragma mark - Action

- (void)tapSendItem:(UIBarButtonItem *)item {
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self requestSendingWithCompletion:^(NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)touchUpInsidePresetButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.titleField setText:BDKMessageFormPresetTitle];
    [self.messageField setText:BDKMessageFormPresetMessage];
    
    [self.attachedImageURLField setText:BDKMessageFormPresetImageURL.absoluteString];
    [self refreshAttachedImageWithURL:BDKMessageFormPresetImageURL];
    
    [self.linkNameField setText:BDKMessageFormPresetLinkName];
    [self.androidLinkField setText:BDKMessageFormPresetAndroidLink];
    [self.iOSLinkField setText:BDKMessageFormPresetIOSLink];
    
    [self.sendItem setEnabled:YES];
}


- (IBAction)touchUpInsideClearButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.titleField setText:nil];
    [self.messageField setText:nil];
    
    [self.attachedImageURLField setText:nil];
    [self refreshAttachedImageWithURL:nil];
    
    [self.linkNameField setText:nil];
    [self.androidLinkField setText:nil];
    [self.iOSLinkField setText:nil];
    
    [self.sendItem setEnabled:NO];
}


- (IBAction)touchUpInsideReloadButton:(UIButton *)sender {
    [self refreshAttachedImageWithURL:[[NSURL alloc] initWithString:self.attachedImageURLField.text]];
}


- (IBAction)editingChangedAttachedImageURLField:(UITextField *)sender {
    [self.reloadButton setEnabled:sender.text.length > 0];
}


- (IBAction)editingChangedContentTextField:(UITextField *)sender {
    [self.sendItem setEnabled:[self canSend]];
}


#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    UITextField *firstResponder = (UITextField *)[self firstResponder];
    
    if (!firstResponder) {
        return;
    }
    
    CGFloat responderMaxY = CGRectGetMaxY(firstResponder.frame);
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (responderMaxY < keyboardHeight) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(0.0f, responderMaxY - keyboardHeight + 10.0f) animated:YES];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    if (CGPointEqualToPoint(self.scrollView.contentOffset, CGPointZero)) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Request

- (void)requestSendingWithCompletion:(void (^)(NSError *error))completion {
    [self.indicator startAnimating];
    
    if (self.band.bandKey.length == 0) {
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"bandKey"));
        return;
    }
    
    if (self.receiver.userKey.length == 0) {
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"receiverKey"));
        return;
    }
    
    BDKSnippet *snippet = [[BDKSnippet alloc] init];
    [snippet setTitle:self.titleField.text];
    [snippet setText:self.messageField.text];
    [snippet setImageURL:[[NSURL alloc] initWithString:self.attachedImageURLField.text]];
    [snippet setLinkName:self.linkNameField.text];
    [snippet setAndroidLink:self.androidLinkField.text];
    [snippet setIOSLink:self.iOSLinkField.text];
    
    __weak typeof(self) weakSelf = self;
    void (^handleResponse)(BDKQuota *, NSError *) = ^(BDKQuota *messageQuota, NSError *error) {
        [weakSelf.indicator stopAnimating];
        
        if (!error) {
            [UIAlertView bdk_showResultWithTitle:[@"message.form.sendSucceeded" bdk_localizedString] quota:messageQuota];
        }
        
        BDK_RUN_BLOCK(completion, error);
    };
    
    switch (self.messageType) {
        case BDKMessageTypeInvitation:
            [BDKAPI sendInvitationWithBandKey:self.band.bandKey receiverKey:self.receiver.userKey snippet:snippet completion:handleResponse];
            break;
        default:
            [BDKAPI sendMessageWithBandKey:self.band.bandKey receiverKey:self.receiver.userKey snippet:snippet completion:handleResponse];
            break;
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self nextResponder:textField]) {
        [textField setReturnKeyType:UIReturnKeyNext];
    } else {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.attachedImageURLField]) {
        [self refreshAttachedImageWithURL:[[NSURL alloc] initWithString:textField.text]];
    }
    
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self nextResponder:textField]) {
        [textField setReturnKeyType:UIReturnKeyNext];
    } else {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
    if ([textField isEqual:self.attachedImageURLField]) {
        [textField setText:nil];
        [self refreshAttachedImageWithURL:[[NSURL alloc] initWithString:textField.text]];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIResponder *nextResponder = [self nextResponder:textField];
    
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    
    return YES;
}


#pragma mark - BDKKeyboardAccessoryViewDelegate

- (void)keyboardAccessoryView:(BDKKeyboardAccessoryView *)keyboardAccessoryView didTouchUpInsideCloseButton:(UIButton *)sender {
    [self.view endEditing:YES];
}

@end
