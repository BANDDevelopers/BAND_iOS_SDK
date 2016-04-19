//
//  BDKPostFormViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 29..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKPostFormViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKKeyboardAccessoryView.h"

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "NSError+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UITextView+BDKSample.h"
#import "UIAlertView+BDKSample.h"


static NSString *const BDKPostFormPresetContentText = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";

static NSURL *BDKPostFormPresetContentImageURL;

static NSString *BDKPostFormPresetSnippetTitle;
static NSString *BDKPostFormPresetSnippetText;
static NSString *BDKPostFormPresetSnippetLinkName;
static NSString *BDKPostFormPresetSnippetAndroidLink;
static NSString *BDKPostFormPresetSnippetIOSLink;


@interface BDKPostFormViewController () <UITextViewDelegate, UITextFieldDelegate, BDKKeyboardAccessoryViewDelegate>

@property (strong, nonatomic) BDKBand *band;

@property (strong, nonatomic) NSArray *responders;

@property (weak, nonatomic) UIBarButtonItem *postingItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *presetButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UITextField *contentImageURLField;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton    *reloadButton;

@property (weak, nonatomic) IBOutlet UITextField *snippetTitleField;
@property (weak, nonatomic) IBOutlet UITextField *snippetTextField;
@property (weak, nonatomic) IBOutlet UITextField *snippetLinkNameField;
@property (weak, nonatomic) IBOutlet UITextField *snippetAndroidLinkField;
@property (weak, nonatomic) IBOutlet UITextField *snippetIOSLinkField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewWidthConstraint;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKPostFormViewController

#pragma mark - Instantiation

+ (void)initialize {
    [super initialize];
    
    BDKPostFormPresetContentImageURL = [[NSURL alloc] initWithString:@"http://coresos.phinf.naver.net/a/2gjah3_j/aaeUd01597xj4e5668ll_hq3ake.png"];
    BDKPostFormPresetSnippetTitle = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    BDKPostFormPresetSnippetText = [[NSString alloc] initWithFormat:[@"post.form.snippetText.preset" bdk_localizedString], BDKPostFormPresetSnippetTitle];
    BDKPostFormPresetSnippetLinkName = [[NSString alloc] initWithFormat:[@"post.form.snippetLinkName.preset" bdk_localizedString], BDKPostFormPresetSnippetTitle];
}


+ (instancetype)postFormViewControllerWithBand:(BDKBand *)band {
    return [[self alloc] initWithBand:band];
}


- (instancetype)initWithBand:(BDKBand *)band {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        BDKPostFormPresetSnippetAndroidLink = [[NSString alloc] initWithFormat:@"exec/view?bandKey=%@", self.band.bandKey];
        BDKPostFormPresetSnippetIOSLink = [[NSString alloc] initWithFormat:@"exec/view?bandKey=%@", self.band.bandKey];
        
        [self setBand:band];
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self registerNotifications];
    
    [self setResponders:@[self.contentTextView, self.contentImageURLField, self.snippetTitleField, self.snippetTextField, self.snippetLinkNameField, self.snippetAndroidLinkField, self.snippetIOSLinkField]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contentTextView becomeFirstResponder];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Determinant

- (BOOL)canPost {
    return self.contentTextView.text.length > 0 &&
    self.snippetTitleField.text.length > 0 &&
    self.snippetTextField.text.length > 0 &&
    self.snippetLinkNameField.text.length > 0 &&
    (self.snippetAndroidLinkField.text.length > 0 || self.snippetIOSLinkField.text.length > 0);
}


#pragma mark - View

- (void)setupViews {
    [self setTitle:self.band.name];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[@"Posting" bdk_localizedString] style:UIBarButtonItemStyleBordered target:self action:@selector(tapPostingItem:)];
    [item setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:item];
    [self setPostingItem:item];
    
    [self.presetButton setTitle:[@"Use Presets" bdk_localizedString] forState:UIControlStateNormal];
    [self.clearButton setTitle:[@"Clear All" bdk_localizedString] forState:UIControlStateNormal];
    
    [self.contentTextView bdk_setPlaceholder:[@"post.form.content.placeHolder" bdk_localizedString]];
    [self.contentTextView setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    [self.contentTextViewWidthConstraint setConstant:CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 20.0f];
    
    [self.contentImageURLField setPlaceholder:[@"post.form.imageURL.placeholder" bdk_localizedString]];
    [self.contentImageURLField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    [self.reloadButton setTitle:[@"Reload" bdk_localizedString] forState:UIControlStateNormal];
    
    [self.snippetTitleField setPlaceholder:[@"post.form.snippetTitle.placeholder" bdk_localizedString]];
    [self.snippetTitleField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
 
    [self.snippetTextField setPlaceholder:[@"post.form.snippetText.placeholder" bdk_localizedString]];
    [self.snippetTextField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.snippetLinkNameField setPlaceholder:[@"post.form.snippetLinkName.placeholder" bdk_localizedString]];
    [self.snippetLinkNameField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.snippetAndroidLinkField setPlaceholder:[@"post.form.snippetAndroidLink.placeholder" bdk_localizedString]];
    [self.snippetAndroidLinkField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.snippetIOSLinkField setPlaceholder:[@"post.form.snippetIOSLink.placeholder" bdk_localizedString]];
    [self.snippetIOSLinkField setInputAccessoryView:[BDKKeyboardAccessoryView keyboardAccessoryViewWithDelegate:self]];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


- (void)refreshContentImageWithURL:(NSURL *)URL {
    if (URL.absoluteString.length == 0) {
        [self.contentImageView setImage:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIImage bdk_loadImageWithURL:URL defaultImage:nil size:CGSizeZero completion:^(UIImage *image) {
        if (image) {
            [weakSelf.contentImageView setImage:image];
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

- (void)tapPostingItem:(UIBarButtonItem *)item {
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self requestPostingWithCompletion:^(NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}


- (IBAction)touchUpInsidePresetButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.contentTextView bdk_setText:BDKPostFormPresetContentText];
    
    [self.contentImageURLField setText:BDKPostFormPresetContentImageURL.absoluteString];
    [self refreshContentImageWithURL:BDKPostFormPresetContentImageURL];
    
    [self.snippetTitleField setText:BDKPostFormPresetSnippetTitle];
    [self.snippetTextField setText:BDKPostFormPresetSnippetText];
    [self.snippetLinkNameField setText:BDKPostFormPresetSnippetLinkName];
    [self.snippetAndroidLinkField setText:BDKPostFormPresetSnippetAndroidLink];
    [self.snippetIOSLinkField setText:BDKPostFormPresetSnippetIOSLink];
    
    [self.postingItem setEnabled:YES];
}


- (IBAction)touchUpInsideClearButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self.contentTextView bdk_setPlaceholder:[@"post.form.content.placeHolder" bdk_localizedString]];
    
    [self.contentImageURLField setText:nil];
    [self refreshContentImageWithURL:nil];
    
    [self.snippetTitleField setText:nil];
    [self.snippetTextField setText:nil];
    [self.snippetLinkNameField setText:nil];
    [self.snippetAndroidLinkField setText:nil];
    [self.snippetIOSLinkField setText:nil];
    
    [self.postingItem setEnabled:NO];
}


- (IBAction)touchUpInsideReloadButton:(UIButton *)sender {
    [self refreshContentImageWithURL:[[NSURL alloc] initWithString:self.contentImageURLField.text]];
}


- (IBAction)editingChangedContentImageURLField:(UITextField *)sender {
    [self.reloadButton setEnabled:sender.text.length > 0];
}


- (IBAction)editingChangedSnippetTextField:(UITextField *)sender {
    [self.postingItem setEnabled:[self canPost]];
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

- (void)requestPostingWithCompletion:(void (^)(NSError *error))completion {
    [self.indicator startAnimating];
    
    if (self.band.bandKey.length == 0) {
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"bandKey"));
        return;
    }
    
    NSString *body = self.contentTextView.text;
    
    if (body.length == 0) {
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"body"));
        return;
    }
    
    BDKSnippet *snippet = [[BDKSnippet alloc] init];
    [snippet setTitle:self.snippetTitleField.text];
    [snippet setText:self.snippetTextField.text];
    [snippet setLinkName:self.snippetLinkNameField.text];
    [snippet setAndroidLink:self.snippetAndroidLinkField.text];
    [snippet setIOSLink:self.snippetIOSLinkField.text];
    
    __weak typeof(self) weakSelf = self;
    [BDKAPI writePostWithBandKey:self.band.bandKey body:body imageURL:[[NSURL alloc] initWithString:self.contentImageURLField.text] snippet:snippet completion:^(BDKQuota *postQuota, NSError *error) {
        [weakSelf.indicator stopAnimating];
        
        if (!error) {
            [UIAlertView bdk_showResultWithTitle:[@"post.form.postingSucceeded" bdk_localizedString] quota:postQuota];
        }
        
        BDK_RUN_BLOCK(completion, error);
    }];
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView bdk_isPlaceholderSet]) {
        [textView bdk_setPlaceholder:nil];
    }
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        [textView bdk_setPlaceholder:[@"post.form.content.placeHolder" bdk_localizedString]];
    }
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self.postingItem setEnabled:[self canPost]];
    return YES;
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
    if ([textField isEqual:self.contentImageURLField]) {
        [self refreshContentImageWithURL:[[NSURL alloc] initWithString:textField.text]];
    }
    
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self nextResponder:textField]) {
        [textField setReturnKeyType:UIReturnKeyNext];
    } else {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
    if ([textField isEqual:self.contentImageURLField]) {
        [textField setText:nil];
        [self refreshContentImageWithURL:[[NSURL alloc] initWithString:textField.text]];
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
