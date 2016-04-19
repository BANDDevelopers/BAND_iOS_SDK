//
//  BDKPostListViewController.m
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKPostListViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "UIImage+BDKSample.h"
#import "UIAlertView+BDKSample.h"


typedef NS_ENUM(NSInteger, BDKPostType) {
    BDKPostTypeDefault,
    BDKPostTypeNotice
};


static NSString *const BDKPostTableViewCellIdentifier        = @"BDKPostTableViewCellIdentifier";
static NSString *const BDKPostTableViewLoadingCellIdentifier = @"BDKPostTableViewLoadingCellIdentifier";


@interface BDKPostListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) BDKBand        *band;
@property (assign, nonatomic) BDKPostType     postType;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSString       *nextPostKey;

@property (weak, nonatomic) IBOutlet UITableView             *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKPostListViewController

#pragma mark - Instantiation

+ (instancetype)officialBandPostListViewController {
    return [[self alloc] initWithBand:nil postType:BDKPostTypeDefault];
}


+ (instancetype)officialBandNoticeListViewController {
    return [[self alloc] initWithBand:nil postType:BDKPostTypeNotice];
}


+ (instancetype)guildBandPostListViewControllerWithBand:(BDKBand *)band {
    return [[self alloc] initWithBand:band postType:BDKPostTypeDefault];
}


+ (instancetype)guildBandNoticeListViewControllerWithBand:(BDKBand *)band {
    return [[self alloc] initWithBand:band postType:BDKPostTypeNotice];
}


- (instancetype)initWithBand:(BDKBand *)band postType:(BDKPostType)postType {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        [self setBand:band];
        [self setPostType:postType];
        [self setPosts:[@[[[NSNull alloc] init]] mutableCopy]];
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}


#pragma mark - View

- (void)setupViews {
    [self setTitle:self.band.name ? : [@"Official Band" bdk_localizedString]];
    
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
}


#pragma mark - Request

- (void)requestPostsWithType:(BDKPostType)type completion:(void (^)(NSArray *posts, NSString *nextPostKey, NSError *error))completion {
    [self.indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    void (^handleResponse)(NSArray *, NSString *, NSError *) = ^(NSArray *posts, NSString *nextPostKey, NSError *error) {
        [weakSelf.indicator stopAnimating];
        
        if (error) {
            BDK_RUN_BLOCK(completion, nil, nil, error);
            return;
        }
        
        [weakSelf setNextPostKey:nextPostKey];
        BDK_RUN_BLOCK(completion, posts, nextPostKey, nil);
    };
    
    switch (type) {
        case BDKPostTypeNotice:
            if (self.band.bandKey.length == 0) {
                [BDKAPI getOfficialBandNoticesWithNextPostKey:self.nextPostKey completion:handleResponse];
            } else {
                [BDKAPI getGuildBandNoticesWithBandKey:self.band.bandKey nextPostKey:self.nextPostKey completion:handleResponse];
            }
            break;
        default:
            if (self.band.bandKey.length == 0) {
                [BDKAPI getOfficialBandPostsWithNextPostKey:self.nextPostKey completion:handleResponse];
            } else {
                [BDKAPI getGuildBandPostsWithBandKey:self.band.bandKey nextPostKey:self.nextPostKey completion:handleResponse];
            }
            break;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    BDKPost *post = self.posts[indexPath.row];
    
    if ([post isKindOfClass:[NSNull class]]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BDKPostTableViewLoadingCellIdentifier];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = indicator.frame;
        frame.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(indicator.bounds)) / 2.0f;
        frame.origin.y = (CGRectGetHeight(cell.bounds) - CGRectGetHeight(indicator.bounds)) / 2.0f;
        [indicator setFrame:frame];
        [indicator startAnimating];
        [cell addSubview:indicator];
        
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:BDKPostTableViewCellIdentifier] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BDKPostTableViewCellIdentifier];
    [cell.textLabel setText:post.content];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    [cell.detailTextLabel setText:[[NSString alloc] initWithFormat:@"%@ | %@", post.author.name, post.createdAt]];
    
    BDKPostPhoto *photo = post.photos.firstObject;
    
    if (photo) {
        CGFloat adjustedWidth;
        CGFloat adjustedHeight;
        CGFloat maxLength = CGRectGetHeight(cell.bounds) - 2.0f;
        
        if (photo.size.width > photo.size.height) {
            adjustedWidth = maxLength;
            adjustedHeight = maxLength * photo.size.height / photo.size.width;
        } else {
            adjustedWidth = maxLength * photo.size.width / photo.size.height;
            adjustedHeight = maxLength;
        }

        [UIImage bdk_loadImageWithURL:[post.photos.firstObject URL] defaultImage:nil size:CGSizeMake(adjustedWidth, adjustedHeight) completion:^(UIImage *image) {
            if (image) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, adjustedWidth, adjustedHeight)];
                [imageView setImage:image];
                
                if (post.photos.count > 1) {
                    UILabel *countLabel = [[UILabel alloc] init];
                    [countLabel setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]];
                    [countLabel setFont:[UIFont systemFontOfSize:10.0f]];
                    [countLabel setTextColor:[UIColor whiteColor]];
                    [countLabel setText:[[NSString alloc] initWithFormat:@"+%lu", (unsigned long)post.photos.count - 1]];
                    [countLabel sizeToFit];
                    
                    CGRect frame = countLabel.frame;
                    frame.origin.x = CGRectGetWidth(imageView.bounds) - CGRectGetWidth(frame);
                    frame.origin.y = CGRectGetHeight(imageView.bounds) - CGRectGetHeight(frame);
                    [countLabel setFrame:frame];
                    [imageView addSubview:countLabel];
                }
                
                [cell setAccessoryView:imageView];
            }
        }];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BDKPost *post = self.posts[indexPath.row];
    
    if (![post isKindOfClass:[NSNull class]]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self requestPostsWithType:self.postType completion:^(NSArray *posts, NSString *nextPostKey, NSError *error) {
        if (error) {
            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
            return;
        }
        
        if (posts) {
            [weakSelf.posts removeLastObject];
            [weakSelf.posts addObjectsFromArray:posts];
            [weakSelf.posts addObject:[[NSNull alloc] init]];
        }
        
        if (!nextPostKey) {
            [weakSelf.posts removeLastObject];
        }
        
        [weakSelf.tableView reloadData];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BDKPost *post = self.posts[indexPath.row];
    
    if ([post isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if (self.selectionCompletion) {
        self.selectionCompletion(self, post);
        return;
    }
    
    [UIAlertView bdk_showPost:post];
}

@end
