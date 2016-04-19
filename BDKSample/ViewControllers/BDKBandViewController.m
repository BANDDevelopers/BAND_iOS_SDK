//
//  BDKBandViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 16..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKBandViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKBandJoinViewController.h"

#import "BDKJoinableGuildBandManager.h"
#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "NSError+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UIAlertView+BDKSample.h"


typedef NS_ENUM(NSInteger, BDKBandViewGuildBandOption) {
    BDKBandViewGuildBandOptionALL = 0,
    BDKBandViewGuildBandOptionYES,
    BDKBandViewGuildBandOptionNO
};


typedef NS_ENUM(NSInteger, BDKBandViewSortingCategory) {
    BDKBandViewSortingCategoryName = 0,
    BDKBandViewSortingCategoryMemberCount,
};


typedef NS_ENUM(NSInteger, BDKBandViewSortingDirection) {
    BDKBandViewSortingDirectionAscending = 0,
    BDKBandViewSortingDirectionDescending,
};


static NSString *const BDKBandTableViewCellIdentifier = @"BDKBandTableViewCellIdentifier";

static UIImage *BDKBandViewDefaultCoverImage;


@interface BDKBandViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray  *bands;
@property (strong, nonatomic) NSArray  *displayedBands;
@property (strong, nonatomic) NSString *searchingText;

@property (weak, nonatomic) IBOutlet UILabel            *guildBandLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *guildBandSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel            *sortingLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingCategorySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingDirectionSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel            *searchingLabel;
@property (weak, nonatomic) IBOutlet UITextField        *searchingField;

@property (weak, nonatomic) IBOutlet UITableView             *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKBandViewController

#pragma mark - Instantiation

+ (void)initialize {
    [super initialize];
    
    BDKBandViewDefaultCoverImage = [[UIImage imageNamed:@"ico_band"] bdk_resizedImage:CGSizeMake(27.0f, 36.0f)];
}


+ (instancetype)bandViewController {
    return [[self alloc] initWithNibName:nil bundle:nil];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    [self requestBandsWithCompletion:^(NSArray *bands, NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
            return;
        }
        
        if (weakSelf.allowsGuildBandOnly) {
            bands = [bands filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isGuildBand = YES"]];
        } else if (weakSelf.allowsJoinableGuildBandOnly) {
            NSArray *guildBands = [bands filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isGuildBand = YES"]];
            BDKJoinableGuildBandManager *joinableGuildBandManager = [BDKJoinableGuildBandManager managerWithGuildBands:guildBands];
            bands = joinableGuildBandManager.joinableBands;
        }
        
        [weakSelf setBands:bands];
        [weakSelf updateDisplayedBandsWithCompletion:^{
            [weakSelf.tableView reloadData];
            [weakSelf setTitle:[[NSString alloc] initWithFormat:@"%@ (%lu)", weakSelf.titleSeed, (unsigned long)weakSelf.displayedBands.count]];
        }];
    }];
}


#pragma mark - Data

- (void)updateDisplayedBandsWithCompletion:(void (^)(void))completion {
    [self.indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *predicateString = [[NSMutableString alloc] initWithFormat:@"SELF.%@ = ", NSStringFromSelector(@selector(isGuildBand))];
        
        switch (weakSelf.guildBandSegmentedControl.selectedSegmentIndex) {
            case BDKBandViewGuildBandOptionYES:
                [predicateString appendString:@"YES"];
                break;
            case BDKBandViewGuildBandOptionNO:
                [predicateString appendString:@"NO"];
                break;
            default:
                predicateString = nil;
                break;
        }
        
        NSArray *source = weakSelf.searchingText ? [weakSelf.bands filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.%@ CONTAINS[cd] %@", NSStringFromSelector(@selector(name)), weakSelf.searchingText]] : weakSelf.bands;
        NSSortDescriptor *sortDescriptor;
        
        switch (weakSelf.sortingCategorySegmentedControl.selectedSegmentIndex) {
            case BDKBandViewSortingCategoryMemberCount:
                sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(memberCount)) ascending:(self.sortingDirectionSegmentedControl.selectedSegmentIndex == BDKBandViewSortingDirectionAscending)];
                break;
            default:
                sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:(self.sortingDirectionSegmentedControl.selectedSegmentIndex == BDKBandViewSortingDirectionAscending)];
                break;
        }
        
        NSArray *sorted = [source sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        if (predicateString) {
            [weakSelf setDisplayedBands:[sorted filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]]];
        } else {
            [weakSelf setDisplayedBands:sorted];
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
    
    [self.guildBandLabel setText:[@"Guild Band" bdk_localizedString]];
    [self.guildBandSegmentedControl setSelectedSegmentIndex:BDKBandViewGuildBandOptionALL];
    
    [self.sortingLabel setText:[@"Sorting" bdk_localizedString]];
    [self.sortingCategorySegmentedControl setTitle:[@"Name" bdk_localizedString] forSegmentAtIndex:BDKBandViewSortingCategoryName];
    [self.sortingCategorySegmentedControl setTitle:[@"Member Count" bdk_localizedString] forSegmentAtIndex:BDKBandViewSortingCategoryMemberCount];
    [self.sortingCategorySegmentedControl setSelectedSegmentIndex:BDKBandViewSortingCategoryName];
    
    [self.sortingDirectionSegmentedControl setTitle:[@"Ascending" bdk_localizedString] forSegmentAtIndex:BDKBandViewSortingDirectionAscending];
    [self.sortingDirectionSegmentedControl setTitle:[@"Descending" bdk_localizedString] forSegmentAtIndex:BDKBandViewSortingDirectionDescending];
    [self.sortingDirectionSegmentedControl setSelectedSegmentIndex:BDKBandViewSortingDirectionAscending];
    
    [self.searchingLabel setText:[@"Searching" bdk_localizedString]];
    [self.searchingField setPlaceholder:[@"band.option.searching.field.placeholder" bdk_localizedString]];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


#pragma mark - Action

- (IBAction)valueChangedSegmentedControl:(UISegmentedControl *)sender {
    __weak typeof(self) weakSelf = self;
    [self updateDisplayedBandsWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - Request

- (void)requestBandsWithCompletion:(void (^)(NSArray *bands, NSError *error))completion {
    [self.indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [BDKAPI getBandsWithCompletion:^(NSArray *bands, NSError *error) {
        [weakSelf.indicator stopAnimating];
        BDK_RUN_BLOCK(completion, bands, error);
    }];
}


- (void)requestToWithdrawFromBandWithBandKey:(NSString *)bandKey completion:(void (^)(NSError *error))completion {
    [self.indicator startAnimating];
    
    if (bandKey.length == 0) {
        [self.indicator stopAnimating];
        BDK_RUN_BLOCK(completion, BDK_NILL_PARAMETER_ERROR(@"bandKey"));
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [BDKAPI leaveGuildBandWithBandKey:bandKey completion:^(NSError *error) {
        [weakSelf.indicator stopAnimating];
        BDK_RUN_BLOCK(completion, error);
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    
    [self setSearchingText:nil];
    [self updateDisplayedBandsWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    
    [self setSearchingText:textField.text];
    [self updateDisplayedBandsWithCompletion:^{
        [weakSelf.tableView reloadData];
    }];
    
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedBands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BDKBandTableViewCellIdentifier] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BDKBandTableViewCellIdentifier];
    BDKBand *band = self.displayedBands[indexPath.row];
    
    [cell.imageView setImage:BDKBandViewDefaultCoverImage];
    [cell.textLabel setText:band.name];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    [cell.detailTextLabel setText:[[NSString alloc] initWithFormat:@"%@: %@", [@"Member Count" bdk_localizedString], band.memberCount]];
    
    [UIImage bdk_loadImageWithURL:[band coverImageURLWithType:BDKBandCoverImageTypeSquare110] defaultImage:BDKBandViewDefaultCoverImage size:CGSizeZero completion:^(UIImage *image) {
        [cell.imageView setImage:image];
    }];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BDKBand *band = self.displayedBands[indexPath.row];
    
    if (self.selectionCompletion) {
        self.selectionCompletion(self, band);
        return;
    }
    
    if (self.allowsGuildBandOnly) {
        __weak typeof(self) weakSelf = self;
        [self requestToWithdrawFromBandWithBandKey:band.bandKey completion:^(NSError *error) {
            if (error) {
                BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                return;
            }
            
            NSMutableArray *renewedBands = [weakSelf.bands mutableCopy];
            [renewedBands removeObject:band];
            [weakSelf setBands:[[NSArray alloc] initWithArray:renewedBands]];
            [weakSelf updateDisplayedBandsWithCompletion:^{
                [weakSelf.tableView reloadData];
                [weakSelf setTitle:[[NSString alloc] initWithFormat:@"%@ (%lu)", weakSelf.titleSeed, (unsigned long)weakSelf.displayedBands.count]];
            }];
            [UIAlertView bdk_showAlertWithMessage:[[NSString alloc] initWithFormat:[@"band.join.withdrawn" bdk_localizedString], band.name]];
        }];
        return;
    }
    
    if (self.allowsJoinableGuildBandOnly) {
        __weak typeof(self) weakSelf = self;
        BDKBandJoinViewController *viewController = [BDKBandJoinViewController bandJoinViewControllerWithBand:band completion:^(BDKBand *joinedBand) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            NSMutableArray *renewedBands = [weakSelf.bands mutableCopy];
            [renewedBands removeObject:joinedBand];
            [weakSelf setBands:[[NSArray alloc] initWithArray:renewedBands]];
            [weakSelf updateDisplayedBandsWithCompletion:^{
                [weakSelf.tableView reloadData];
                
            }];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    [UIAlertView bdk_showBand:band];
}

@end
