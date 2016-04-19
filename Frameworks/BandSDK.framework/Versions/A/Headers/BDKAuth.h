//
//  BDKAuth.h
//  BandSDK
//
//  Created by Alan on 2016. 1. 14.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  This class manages the interaction between the BAND app and authentication.
 *  It is required to initialize this class in the application:didFinishLaunchingWithOptions: method defined in the app delegate of which has been integrated with the BAND SDK.
 */
@interface BDKAuth : NSObject

/// App's client ID, a client identifier for OAuth authentication. This can be issued through BAND Developers.
@property (strong, nonatomic) NSString *clientID;

/// App's client secret, a password used for OAuth authentication. This can be issued through BAND Developers.
@property (strong, nonatomic) NSString *clientSecret;


/**
 *  Returns the singleton instance of the BDKAuth class.
 *
 *  The singleton instance must be used instead of creating a new instance whenever the instance of the BDKAuth class is required. 
 *
 *  @return Singleton instance of the BDKAuth class
 */
+ (instancetype)sharedInstance;

/**
 *  Returns whether user authentication is properly performed after integration.
 *
 *  This method can be used to check if  the user is logged in or not.
 *
 *  @return Whether the user is authenticated. 
 */
- (BOOL)isAuthorized;

/**
 *  Returns whether the callback URL is called by the BAND app after authentication.
 *
 *  @return Whether the callback URL is called in the BAND app after authentication.
 */
- (BOOL)isAuthCallbackURL:(NSURL *)URL;

/**
 *  Handles the callback URL called in the BAND app after authentication.
 *
 *  @return Success or failure of the callback URL
 */
- (BOOL)openAuthCallbackURL:(NSURL *)URL;

@end
