//
//  BDKJoinableGuildBandManager.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface BDKJoinableGuildBandManager : NSObject

@property (strong, nonatomic, readonly) NSArray *joinableBands;


+ (instancetype)managerWithGuildBands:(NSArray *)guildBands;

@end
