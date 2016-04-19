//
//  BDKJoinableGuildBandManager.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKJoinableGuildBandManager.h"

#import <BandSDK/BandSDK.h>


@interface BDKJoinableGuildBandManager ()

@property (strong, nonatomic) NSArray *guildBands;
@property (strong, nonatomic) NSArray *joinableBands;

@end


#pragma mark -

@implementation BDKJoinableGuildBandManager

#pragma mark - Instantiation

+ (instancetype)managerWithGuildBands:(NSArray *)guildBands {
    return [[self alloc] initWithGuildBands:guildBands];
}


- (instancetype)initWithGuildBands:(NSArray *)guildBands {
    self = [super init];
    
    if (self) {
        [self setGuildBands:guildBands];
        
        NSMutableDictionary *guildBandsInfo = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"all_bands"]] mutableCopy] ? : [[NSMutableDictionary alloc] init];
        
        for (BDKBand *band in guildBands) {
            guildBandsInfo[band.bandKey] = band;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[guildBandsInfo copy]] forKey:@"all_bands"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (guildBandsInfo) {
            for (BDKBand *band in guildBands) {
                guildBandsInfo[band.bandKey] = nil;
            }
            
            [self setJoinableBands:guildBandsInfo.allValues];
        } else {
            [self setJoinableBands:[[NSArray alloc] init]];
        }
    }
    
    return self;
}

@end
