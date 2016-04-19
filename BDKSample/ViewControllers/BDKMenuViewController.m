//
//  BDKMenuViewController.m
//  BDK Sample
//
//  Created by Hyunmin Ryu on 2014. 5. 14..
//  Copyright (c) 2014년 Camp Mobile Inc. All rights reserved.
//


#import "BDKMenuViewController.h"

#import <BandSDK/BandSDK.h>

#import "BDKMemberViewController.h"
#import "BDKBandViewController.h"
#import "BDKPostListViewController.h"
#import "BDKPostFormViewController.h"
#import "BDKMessageFormViewController.h"

#import "BDKErrorHandler.h"

#import "NSString+BDKSample.h"
#import "NSError+BDKSample.h"
#import "UIAlertView+BDKSample.h"


typedef NS_ENUM(NSInteger, BDKMenuSection) {
    BDKMenuSectionConnection = 0,
    BDKMenuSectionUser,
    BDKMenuSectionFriendList,
    BDKMenuSectionBandCreation,
    BDKMenuSectionBandJoin,
    
    BDKMenuSectionBandInformation,
    BDKMenuSectionPost,
    BDKMenuSectionMessage,
    BDKMenuSectionOpen,
    BDKMenuSectionBandLeave
};


typedef NS_ENUM(NSInteger, BDKMenu) {
    BDKMenuLogout,
    BDKMenuDisconnect,
    BDKMenuGetAccessToken,
    
    BDKMenuGetProfile,
    BDKMenuGetQuotas,
    
    BDKMenuGetFriends,
    BDKMenuGetBandMembers,
    
    BDKMenuCreateGuildBand,
    
    BDKMenuJoinGuildBand,
    BDKMenuJoinOfficialBand,
    
    BDKMenuGetBands,
    BDKMenuGetGuildBandPosts,
    BDKMenuGetGuildBandNotices,
    BDKMenuGetOfficialBandInformation,
    BDKMenuGetOfficialBandPosts,
    BDKMenuGetOfficialBandNotices,
    
    BDKMenuWritePost,
    
    BDKMenuSendInvitaion,
    BDKMenuSendMessage,
    
    BDKMenuOpenBand,
    BDKMenuOpenPost,
    BDKMenuOpenBandChat,
    BDKMenuInstallBandApp,
    
    BDKMenuLeaveGuildBand
};


static NSString *const BDKMenuTableViewCellIdentifier = @"BDKMenuTableViewCellIdentifier";


@interface BDKMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *menus;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BDKErrorHandler *errorHandler;

@end


#pragma mark -

@implementation BDKMenuViewController

#pragma mark - Instantiation

+ (instancetype)menuViewController {
    return [[self alloc] initWithNibName:nil bundle:nil];
}


#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setMenus:@{[@(BDKMenuSectionConnection) stringValue]     : @[@(BDKMenuLogout),
                                                                           @(BDKMenuDisconnect),
                                                                           @(BDKMenuGetAccessToken)],
                         [@(BDKMenuSectionUser) stringValue]           : @[@(BDKMenuGetProfile),
                                                                           @(BDKMenuGetQuotas)],
                         [@(BDKMenuSectionFriendList) stringValue]     : @[@(BDKMenuGetFriends),
                                                                           @(BDKMenuGetBandMembers)],
                         [@(BDKMenuSectionBandCreation) stringValue]   : @[@(BDKMenuCreateGuildBand)],
                         [@(BDKMenuSectionBandJoin) stringValue]       : @[@(BDKMenuJoinGuildBand),
                                                                           @(BDKMenuJoinOfficialBand)],
                         [@(BDKMenuSectionBandInformation) stringValue]: @[@(BDKMenuGetBands),
                                                                           @(BDKMenuGetGuildBandPosts),
                                                                           @(BDKMenuGetGuildBandNotices),
                                                                           @(BDKMenuGetOfficialBandInformation),
                                                                           @(BDKMenuGetOfficialBandPosts),
                                                                           @(BDKMenuGetOfficialBandNotices)],
                         [@(BDKMenuSectionPost) stringValue]           : @[@(BDKMenuWritePost)],
                         [@(BDKMenuSectionMessage) stringValue]        : @[@(BDKMenuSendInvitaion),
                                                                           @(BDKMenuSendMessage)],
                         [@(BDKMenuSectionOpen) stringValue]           : @[@(BDKMenuOpenBand),
                                                                           @(BDKMenuOpenPost),
                                                                           @(BDKMenuOpenBandChat),
                                                                           @(BDKMenuInstallBandApp)],
                         [@(BDKMenuSectionBandLeave) stringValue]      : @[@(BDKMenuLeaveGuildBand)]
                         }];
        [self setErrorHandler:[BDKErrorHandler handler]];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]];
    [self.navigationItem setHidesBackButton:YES];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BDKMenuTableViewCellIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menus[[@(section) stringValue]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BDKMenuTableViewCellIdentifier forIndexPath:indexPath];
    BDKMenu menu = [self.menus[[@(indexPath.section) stringValue]][indexPath.row] integerValue];
    
    switch (menu) {
        case BDKMenuLogout:
            [cell.textLabel setText:[@"topMenu.menu.logout" bdk_localizedString]];
            break;
        case BDKMenuDisconnect:
            [cell.textLabel setText:[@"topMenu.menu.disconnect" bdk_localizedString]];
            break;
        case BDKMenuGetAccessToken:
            [cell.textLabel setText:[@"topMenu.menu.getAccessToken" bdk_localizedString]];
            break;
        case BDKMenuGetProfile:
            [cell.textLabel setText:[@"topMenu.menu.getProfile" bdk_localizedString]];
            break;
        case BDKMenuGetQuotas:
            [cell.textLabel setText:[@"topMenu.menu.getQuotas" bdk_localizedString]];
            break;
        case BDKMenuGetFriends:
            [cell.textLabel setText:[@"topMenu.menu.getFriends" bdk_localizedString]];
            break;
        case BDKMenuGetBandMembers:
            [cell.textLabel setText:[@"topMenu.menu.getBandMembers" bdk_localizedString]];
            break;
        case BDKMenuCreateGuildBand:
            [cell.textLabel setText:[@"topMenu.menu.createGuildBand" bdk_localizedString]];
            break;
        case BDKMenuJoinGuildBand:
            [cell.textLabel setText:[@"topMenu.menu.joinGuildBand" bdk_localizedString]];
            break;
        case BDKMenuJoinOfficialBand:
            [cell.textLabel setText:[@"topMenu.menu.joinOfficialBand" bdk_localizedString]];
            break;
        case BDKMenuGetBands:
            [cell.textLabel setText:[@"topMenu.menu.getBands" bdk_localizedString]];
            break;
        case BDKMenuGetGuildBandPosts:
            [cell.textLabel setText:[@"topMenu.menu.getGuildBandPosts" bdk_localizedString]];
            break;
        case BDKMenuGetGuildBandNotices:
            [cell.textLabel setText:[@"topMenu.menu.getGuildBandNotices" bdk_localizedString]];
            break;
        case BDKMenuGetOfficialBandInformation:
            [cell.textLabel setText:[@"topMenu.menu.getOfficialBandInformation" bdk_localizedString]];
            break;
        case BDKMenuGetOfficialBandPosts:
            [cell.textLabel setText:[@"topMenu.menu.getOfficialBandPosts" bdk_localizedString]];
            break;
        case BDKMenuGetOfficialBandNotices:
            [cell.textLabel setText:[@"topMenu.menu.getOfficialBandNotices" bdk_localizedString]];
            break;
        case BDKMenuWritePost:
            [cell.textLabel setText:[@"topMenu.menu.writePost" bdk_localizedString]];
            break;
        case BDKMenuSendInvitaion:
            [cell.textLabel setText:[@"topMenu.menu.sendInvitation" bdk_localizedString]];
            break;
        case BDKMenuSendMessage:
            [cell.textLabel setText:[@"topMenu.menu.sendMessage" bdk_localizedString]];
            break;
        case BDKMenuOpenBand:
            [cell.textLabel setText:[@"topMenu.menu.openBand" bdk_localizedString]];
            break;
        case BDKMenuOpenPost:
            [cell.textLabel setText:[@"topMenu.menu.openPost" bdk_localizedString]];
            break;
        case BDKMenuOpenBandChat:
            [cell.textLabel setText:[@"topMenu.menu.openBandChat" bdk_localizedString]];
            break;
        case BDKMenuInstallBandApp:
            [cell.textLabel setText:[@"topMenu.menu.installBandApp" bdk_localizedString]];
            break;
        case BDKMenuLeaveGuildBand:
            [cell.textLabel setText:[@"topMenu.menu.leaveGuildBand" bdk_localizedString]];
            break;
        default:
            break;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menus.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle;
    
    switch ((BDKMenuSection)section) {
        case BDKMenuSectionConnection:
            headerTitle = [@"Connection" bdk_localizedString];
            break;
        case BDKMenuSectionUser:
            headerTitle = [@"Users" bdk_localizedString];
            break;
        case BDKMenuSectionFriendList:
            headerTitle = [@"Access Friend List" bdk_localizedString];
            break;
        case BDKMenuSectionBandCreation:
            headerTitle = [@"Band Creation" bdk_localizedString];
            break;
        case BDKMenuSectionBandJoin:
            headerTitle = [@"Band Join" bdk_localizedString];
            break;
        case BDKMenuSectionBandInformation:
            headerTitle = [@"Band Information" bdk_localizedString];
            break;
        case BDKMenuSectionPost:
            headerTitle = [@"Posts" bdk_localizedString];
            break;
        case BDKMenuSectionMessage:
            headerTitle = [@"Messages" bdk_localizedString];
            break;
        case BDKMenuSectionOpen:
            headerTitle = [@"Open" bdk_localizedString];
            break;
        case BDKMenuSectionBandLeave:
            headerTitle = [@"Band Leave" bdk_localizedString];
            break;
        default:
            break;
    }
    
    return headerTitle ? [[NSString alloc] initWithFormat:@"%ld. %@", (long)section + 1, headerTitle] : nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) weakSelf = self;
    BDKMenu menu = [self.menus[[@(indexPath.section) stringValue]][indexPath.row] integerValue];
    
    switch (menu) {
        case BDKMenuLogout: {
            [BDKAPI logoutWithCompletion:^ {
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }];
            break;
        }
        case BDKMenuDisconnect: {
            [BDKAPI disconnectWithCompletion:^(NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }];
            break;
        }
        case BDKMenuGetAccessToken: {
            [BDKAPI getAccessTokenWithCompletion:^(NSString *accessToken, NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
            
                [UIAlertView bdk_showAccessToken:accessToken];
            }];
            break;
        }
        case BDKMenuGetProfile: {
            [BDKAPI getProfileWithCompletion:^(BDKProfile *profile, NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
                
                [UIAlertView bdk_showProfile:profile];
            }];
            break;
        }
        case BDKMenuGetQuotas: {
            [BDKAPI getQuotasWithCompletion:^(NSDictionary *quotas, NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
                
                [UIAlertView bdk_showQuotas:quotas];
            }];
            break;
        }
        case BDKMenuGetFriends: {
            BDKMemberViewController *viewController = [BDKMemberViewController memberViewControllerWithBand:nil];
            [viewController setTitleSeed:[@"Friends" bdk_localizedString]];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuGetBandMembers: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKMemberViewController *memberViewController = [BDKMemberViewController memberViewControllerWithBand:band];
                [memberViewController setAllowsDisplaySelf:YES];
                [memberViewController setTitleSeed:[@"Members" bdk_localizedString]];
                [viewController.navigationController pushViewController:memberViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuCreateGuildBand: {
            [UIAlertView bdk_showGuildBandNameInputAlertWithCompletion:^(NSString *bandName) {
                if (bandName.length == 0) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, BDK_NILL_PARAMETER_ERROR(@"bandName"), weakSelf);
                    return;
                }
                
                [BDKAPI createGuildBandWithBandName:bandName completion:^(BDKBand *band, NSError *error) {
                    if (error) {
                        BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                        return;
                    }
                    
                    [UIAlertView bdk_showBand:band];
                }];
            }];
            break;
        }
        case BDKMenuJoinGuildBand: {
            BDKBandViewController *viewController = [BDKBandViewController bandViewController];
            [viewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [viewController setAllowsJoinableGuildBandOnly:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuJoinOfficialBand: {
            [BDKAPI joinOfficialBandWithCompletion:^(NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
                
                [UIAlertView bdk_showAlertWithLocalizedMessage:@"alert.officialBandJoin.message"];
            }];
            break;
        }
        case BDKMenuGetBands: {
            BDKBandViewController *viewController = [BDKBandViewController bandViewController];
            [viewController setTitleSeed:[@"Bands" bdk_localizedString]];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuGetGuildBandPosts: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setAllowsGuildBandOnly:YES];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKPostListViewController *postListViewController = [BDKPostListViewController guildBandPostListViewControllerWithBand:band];
                [weakSelf.navigationController pushViewController:postListViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuGetGuildBandNotices: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setAllowsGuildBandOnly:YES];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKPostListViewController *postListViewController = [BDKPostListViewController guildBandNoticeListViewControllerWithBand:band];
                [weakSelf.navigationController pushViewController:postListViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuGetOfficialBandInformation: {
            [BDKAPI getOfficialBandInformationWithCompletion:^(NSString *bandKey, BOOL isJoined, NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return ;
                }
                
                if (bandKey.length == 0) {
                    [UIAlertView bdk_showAlertWithLocalizedMessage:@"officialBand.notExist"];
                    return;
                }

                if (!isJoined) {
                    [UIAlertView bdk_showQueryWithLocalizedMessage:@"alert.officialBandJoinQuery.message" delegate:self];
                    return;
                }

                [UIAlertView bdk_showOfficialBandInformationWithBandKey:bandKey joined:isJoined];
            }];
            break;
        }
        case BDKMenuGetOfficialBandPosts: {
            BDKPostListViewController *viewController = [BDKPostListViewController officialBandPostListViewController];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuGetOfficialBandNotices: {
            BDKPostListViewController *viewController = [BDKPostListViewController officialBandNoticeListViewController];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuWritePost: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKPostFormViewController *postFormViewController = [BDKPostFormViewController postFormViewControllerWithBand:band];
                [viewController.navigationController pushViewController:postFormViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuSendInvitaion: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKMemberViewController *memberViewController = [BDKMemberViewController memberViewControllerWithBand:band];
                [memberViewController setTitleSeed:[@"Members" bdk_localizedString]];
                [memberViewController setAllowsNotConnectedMembersOnly:YES];
                [memberViewController setAllowsSendMessagesOrInvite:YES];
                [memberViewController setSelectionCompletion:^(BDKMemberViewController *viewController, BDKProfile *member) {
                    BDKMessageFormViewController *messageFormViewController = [BDKMessageFormViewController invitationFormViewControllerWithBand:band receiver:member];
                    [viewController.navigationController pushViewController:messageFormViewController animated:YES];
                }];
                [viewController.navigationController pushViewController:memberViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuSendMessage: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                BDKMemberViewController *memberViewController = [BDKMemberViewController memberViewControllerWithBand:band];
                [memberViewController setTitleSeed:[@"Members" bdk_localizedString]];
                [memberViewController setAllowsConnectedMembersOnly:YES];
                [memberViewController setAllowsSendMessagesOrInvite:YES];
                [memberViewController setSelectionCompletion:^(BDKMemberViewController *viewController, BDKProfile *member) {
                    BDKMessageFormViewController *messageFormViewController = [BDKMessageFormViewController messageFormViewControllerWithBand:band receiver:member];
                    [viewController.navigationController pushViewController:messageFormViewController animated:YES];
                }];
                [viewController.navigationController pushViewController:memberViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuOpenBand: {
            BDKBandViewController *viewController = [BDKBandViewController bandViewController];
            [viewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [viewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                if (band.bandKey.length == 0) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, BDK_NILL_PARAMETER_ERROR(@"bandKey"), weakSelf);
                    return;
                }
                
                [BDKAPI openBandWithBandKey:band.bandKey completion:^(NSError *error) {
                    if (error) {
                        BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    }
                }];
            }];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuOpenPost: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setAllowsGuildBandOnly:YES];
            [bandViewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                if (band.bandKey.length == 0) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, BDK_NILL_PARAMETER_ERROR(@"bandKey"), weakSelf);
                    return;
                }
                
                BDKPostListViewController *postListViewController = [BDKPostListViewController guildBandPostListViewControllerWithBand:band];
                [postListViewController setSelectionCompletion:^(BDKPostListViewController *viewController, BDKPost *post) {
                    if (post.postKey.length == 0) {
                        BDK_HANDLE_ERROR(weakSelf.errorHandler, BDK_NILL_PARAMETER_ERROR(@"postKey"), weakSelf);
                        return;
                    }
                    
                    [BDKAPI openPostWithBandKey:band.bandKey postKey:post.postKey completion:^(NSError *error) {
                        if (error) {
                            BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                        }
                    }];
                }];
                [viewController.navigationController pushViewController:postListViewController animated:YES];
            }];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        case BDKMenuOpenBandChat: {
            BDKBandViewController *viewController = [BDKBandViewController bandViewController];
            [viewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [viewController setSelectionCompletion:^(BDKBandViewController *viewController, BDKBand *band) {
                if (band.bandKey.length == 0) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, BDK_NILL_PARAMETER_ERROR(@"bandKey"), weakSelf);
                    return;
                }
                
                [BDKAPI openBandChatWithBandKey:band.bandKey completion:^(NSError *error) {
                    if (error) {
                        BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    }
                }];
            }];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case BDKMenuInstallBandApp: {
            [BDKAPI installBandApp];
            break;
        }
        case BDKMenuLeaveGuildBand: {
            BDKBandViewController *bandViewController = [BDKBandViewController bandViewController];
            [bandViewController setTitleSeed:[@"Band Selection" bdk_localizedString]];
            [bandViewController setAllowsGuildBandOnly:YES];
            [self.navigationController pushViewController:bandViewController animated:YES];
            break;
        }
        default: {
            break;
        }
    }
}


#pragma mark - UIAlertViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            __weak typeof(self) weakSelf = self;
            [BDKAPI joinOfficialBandWithCompletion:^(NSError *error) {
                if (error) {
                    BDK_HANDLE_ERROR(weakSelf.errorHandler, error, weakSelf);
                    return;
                }
                
                [UIAlertView bdk_showAlertWithLocalizedMessage:@"alert.officialBandJoin.message"];
            }];
            break;
        }
        default: {
            break;
        }
    }
}

@end
