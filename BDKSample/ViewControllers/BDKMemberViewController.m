//
//  BDKMemberViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 4..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKMemberViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UIAlertView+BDKSample.h"


typedef NS_ENUM(NSInteger, BDKMemberViewConnectionOption) {
    BDKMemberViewConnectionOptionALL = 0,
    BDKMemberViewConnectionOptionYES,
    BDKMemberViewConnectionOptionNO
};


typedef NS_ENUM(NSInteger, BDKMemberViewMessageAcceptanceOption) {
    BDKMemberViewMessageAcceptanceOptionALL = 0,
    BDKMemberViewMessageAcceptanceOptionYES,
    BDKMemberViewMessageAcceptanceOptionNO
};


typedef NS_ENUM(NSInteger, BDKMemberViewSortingDirection) {
    BDKMemberViewSortingDirectionAscending = 0,
    BDKMemberViewSortingDirectionDescending
};


static NSString *const BDKMemberTableViewCellIdentifier = @"BDKMemberTableViewCellIdentifier";

static UIImage *BDKMemberViewDefaultProfileImage;


@interface BDKMemberViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) BDKBand  *band;
@property (strong, nonatomic) NSArray  *members;
@property (strong, nonatomic) NSArray  *displayedMembers;
@property (strong, nonatomic) NSString *searchingText;

@property (weak, nonatomic) IBOutlet UILabel            *connectionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel            *messageAcceptanceLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageAcceptanceSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel            *sortingLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel            *searchingLabel;
@property (weak, nonatomic) IBOutlet UITextField        *searchingField;

@property (weak, nonatomic) IBOutlet UITableView             *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKMemberViewController

#pragma mark - Instantiation

+ (void)initialize {
    [super initialize];
    
    BDKMemberViewDefaultProfileImage = [UIImage imageNamed:@"ico_default_profile"];
}


+ (instancetype)memberViewControllerWithBand:(BDKBand *)band {
    return [[self alloc] initWithBand:band];
}


- (instancetype)initWithBand:(BDKBand *)band {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        [self setBand:band];
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    [self requestMembersWithCompletion:^(NSArray *members, NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
            return;
        }

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
        members = [members sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        if (self.allowsConnectedMembersOnly) {
            members = [members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.%@ = YES", NSStringFromSelector(@selector(isAppConnected))]];
        } else if (self.allowsNotConnectedMembersOnly) {
            members = [members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.%@ = NO", NSStringFromSelector(@selector(isAppConnected))]];
        }
        
        [weakSelf setMembers:members];
        [weakSelf updateDisplayedMembersWithCompletion:^{
            [weakSelf.tableView reloadData];
        }];
        
        [weakSelf setTitle:[[NSString alloc] initWithFormat:@"%@ (%lu)", weakSelf.titleSeed, (unsigned long)members.count]];
    }];
}


#pragma mark - Data

- (void)updateDisplayedMembersWithCompletion:(void (^)(void))completion {
    [self.indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *connectionPredicateString = [[NSMutableString alloc] initWithFormat:@"SELF.%@ = ", NSStringFromSelector(@selector(isAppConnected))];
        
        switch (weakSelf.connectionSegmentedControl.selectedSegmentIndex) {
            case BDKMemberViewConnectionOptionYES:
                [connectionPredicateString appendString:@"YES"];
                break;
            case BDKMemberViewConnectionOptionNO:
                [connectionPredicateString appendString:@"NO"];
                break;
            default:
                connectionPredicateString = nil;
                break;
        }
        
        NSMutableString *messageAcceptancePredicateString = [[NSMutableString alloc] initWithFormat:@"SELF.%@ = ", NSStringFromSelector(@selector(allowsMessages))];
        
        switch (weakSelf.messageAcceptanceSegmentedControl.selectedSegmentIndex) {
            case BDKMemberViewMessageAcceptanceOptionYES:
                [messageAcceptancePredicateString appendString:@"YES"];
                break;
            case BDKMemberViewMessageAcceptanceOptionNO:
                [messageAcceptancePredicateString appendString:@"NO"];
                break;
            default:
                messageAcceptancePredicateString = nil;
                break;
        }
        
        NSString *predicateString;
        
        if (connectionPredicateString) {
            if (messageAcceptancePredicateString) {
                predicateString = [[NSString alloc] initWithFormat:@"%@ AND %@", connectionPredicateString, messageAcceptancePredicateString];
            } else {
                predicateString = [[NSString alloc] initWithString:connectionPredicateString];
            }
        } else {
            if (messageAcceptancePredicateString) {
                predicateString = [[NSString alloc] initWithString:messageAcceptancePredicateString];
            } else {
                predicateString = nil;
            }
        }
        
        NSArray *source = weakSelf.searchingText ? [weakSelf.members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.%@ CONTAINS[cd] %@", NSStringFromSelector(@selector(name)), weakSelf.searchingText]] : weakSelf.members;
        NSArray *sorted = weakSelf.sortingSegmentedControl.selectedSegmentIndex == BDKMemberViewSortingDirectionAscending ? source : source.reverseObjectEnumerator.allObjects;
        
        if (predicateString) {
            [weakSelf setDisplayedMembers:[sorted filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]]];
        } else {
            [weakSelf setDisplayedMembers:sorted];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.indicator stopAnimating];
            BDK_RUN_BLOCK(completion);
        });
    });
}


#pragma mark - View

- (void)setupViews {
    [self setTitle:self.titleSeed];
    
    [self.connectionLabel setText:[@"member.option.connection" bdk_localizedString]];
    [self.connectionSegmentedControl setSelectedSegmentIndex:BDKMemberViewConnectionOptionALL];
    
    [self.messageAcceptanceLabel setText:[@"member.option.messageAcceptance" bdk_localizedString]];
    [self.messageAcceptanceSegmentedControl setSelectedSegmentIndex:BDKMemberViewMessageAcceptanceOptionALL];
    
    [self.sortingLabel setText:[@"Sorting" bdk_localizedString]];
    [self.sortingSegmentedControl setTitle:[@"Ascending" bdk_localizedString] forSegmentAtIndex:BDKMemberViewSortingDirectionAscending];
    [self.sortingSegmentedControl setTitle:[@"Descending" bdk_localizedString] forSegmentAtIndex:BDKMemberViewSortingDirectionDescending];
    [self.sortingSegmentedControl setSelectedSegmentIndex:BDKMemberViewSortingDirectionAscending];
    
    [self.searchingLabel setText:[@"Searching" bdk_localizedString]];
    [self.searchingField setPlaceholder:[@"member.option.searching.field.placeholder" bdk_localizedString]];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


#pragma mark - Action

- (IBAction)valueChangedSegmentedControl:(UISegmentedControl *)sender {
    __weak typeof(self) weakSelf = self;
    [self updateDisplayedMembersWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - Request

- (void)requestMembersWithCompletion:(void (^)(NSArray *members, NSError *error))completion {
    [self.indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.band.bandKey.length == 0) {
        [BDKAPI getFriendsWithCompletion:^(NSArray *friends, NSError *error) {
            [weakSelf.indicator stopAnimating];
            BDK_RUN_BLOCK(completion, friends, error);
        }];
    } else {
        [BDKAPI getBandMembersWithBandKey:self.band.bandKey allowsDisplaySelf:self.allowsDisplaySelf completion:^(NSArray *members, NSError *error) {
            [weakSelf.indicator stopAnimating];
            BDK_RUN_BLOCK(completion, members, error);
        }];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    
    [self setSearchingText:nil];
    [self updateDisplayedMembersWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    
    [self setSearchingText:textField.text];
    [self updateDisplayedMembersWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
    
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedMembers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BDKMemberTableViewCellIdentifier] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BDKMemberTableViewCellIdentifier];
    BDKProfile *memberProfile = self.displayedMembers[indexPath.row];
    
    [cell.imageView setImage:BDKMemberViewDefaultProfileImage];
    [cell.textLabel setText:memberProfile.name];
    
    if (self.allowsSendMessagesOrInvite) {
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        
        if (memberProfile.isAppConnected && memberProfile.allowsMessages) {
            [cell.detailTextLabel setText:[@"member.cell_detail.sendMessage" bdk_localizedString]];
        } else if (!memberProfile.isAppConnected) {
            [cell.detailTextLabel setText:[@"member.cell_detail.invite" bdk_localizedString]];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        if (memberProfile.isAppConnected) {
            [cell.detailTextLabel setTextColor:[UIColor greenColor]];
            [cell.detailTextLabel setText:[@"App Connected" bdk_localizedString]];
        } else {
            [cell.detailTextLabel setTextColor:[UIColor redColor]];
            [cell.detailTextLabel setText:[@"Not App Connected" bdk_localizedString]];
        }
    }
    
    [UIImage bdk_loadImageWithURL:[memberProfile profileImageURLWithType:BDKProfileImageTypeSquare40] defaultImage:BDKMemberViewDefaultProfileImage size:CGSizeZero completion:^(UIImage *image) {
        [cell.imageView setImage:image];
    }];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BDKProfile *member = self.displayedMembers[indexPath.row];
    
    if (self.selectionCompletion) {
        self.selectionCompletion(self, member);
        return;
    }
    
    [UIAlertView bdk_showProfile:member];
}

@end
