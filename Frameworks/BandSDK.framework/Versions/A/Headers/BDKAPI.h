//
//  BDKAPI.h
//  BandSDK
//
//  Created by Alan on 2016. 1. 22.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <BandSDK/BDKProfile.h>
#import <BandSDK/BDKQuota.h>
#import <BandSDK/BDKBand.h>
#import <BandSDK/BDKPost.h>
#import <BandSDK/BDKPostPhoto.h>
#import <BandSDK/BDKSnippet.h>
#import <BandSDK/BDKAuthor.h>


/**
 *  This provides a list of API error codes.
 */
typedef NS_ENUM(NSInteger, BDKErrorCode) {
    /// App quota exceeds the limit
    BDKErrorCodeQuotaExceeded                   = 1001,
    
    /// User quota exceeds the limit
    BDKErrorCodeUserQuotaExceeded               = 1002,
    
    /// Continuous API calls for a short period of time is not available
    BDKErrorCodeCooltimeExceeded                = 1003,
    
    /// Message is sent to myself
    BDKErrorCodeMessageSentToSelf               = 2162,
    
    /// Error in server response
    BDKErrorCodeInvalidResponse                 = 2300,
    
    /// No official Band information can be found
    BDKErrorCodeOfficialBandInformationNotFound = 2401,
    
    /// Invalid call
    BDKErrorCodeInvalidRequest                  = 3000,
    
    /// Content length exceeds the limit
    BDKErrorCodeTextParameterMaxLengthExceeded  = 3001,
    
    /// Not a test Band; the permission is only available for test Bands
    BDKErrorCodeNotTestBand                     = 5001,
    
    /// Authentication failure; no access token exists or it has expired
    BDKErrorCodeAuth                            = 10401,
    
    /// BAND app is not installed
    BDKErrorCodeBandAppNotInstalled             = 40040,
    
    /// Wrong API call; the API called is only valid for guild Bands
    BDKErrorCodeNotGuildBand                    = 40050,
    
    /// An error occurs within the BAND SDK
    BDKErrorCodeSDKInternal                     = 42000,
    
    /// Login cancelled by user
    BDKErrorCodeLoginCancelled                  = 42020,
    
    /// Invalid parameter is used
    BDKErrorCodeInvalidParameter                = 60000,
    
    /// User does not exist
    BDKErrorCodeUnregisteredUser                = 60100,
    
    /// User is not found in the friend list
    BDKErrorCodeNotFriend                       = 60101,
    
    /// Wrong API call; the API called is only valid for Bands that a user has joined
    BDKErrorCodeNotJoinedBand                   = 60102,
    
    /// Wrong API call; the API called is only valid for users whose BAND account is connected with the app
    BDKErrorCodeNotConnectedUser                = 60103,
    
    /// Wrong API call; the API called is only valid for users whose BAND account is not connected with the app
    BDKErrorCodeAlreadyConnectedUser            = 60104,
    
    /// Band owner tries to leave a Band
    BDKErrorCodeBandLeaderCannotLeaveBand       = 60105,
    
    /// Band does not exist or is invalid
    BDKErrorCodeInvalidBand                     = 60200,
    
    /// Wrong API call; the API called is only valid for Bands that a user has not joined
    BDKErrorCodeAlreadyJoinedBand               = 60201,
    
    /// Exceeded the maximum number of Bands a user is allowed to join
    BDKErrorCodeBandMaxCountExceeded            = 60202,
    
    /// Wrong API call; the API called is valid for either guild Bands or official Bands
    BDKErrorCodeNotConnectedBand                = 60203,
    
    /// Message is not accepted by the recipient
    BDKErrorCodeMessageNotAllowed               = 60300,
    
    /// Invalid message format
    BDKErrorCodeInvalidMessage                  = 60301,
    
    /// Message service failure
    BDKErrorCodeMessageServiceInoperable        = 60302,
    
    /// No write permission
    BDKErrorCodePostNotPermitted                = 60400,
    
    /// Invalid image URL format
    BDKErrorCodeInvalidImageURL                 = 60800
};


/**
 *  This class defines the BAND SDK's API.
 */
@interface BDKAPI : NSObject

@end


@interface BDKAPI (Connection)

/**
 *  Enables the app to get permissions to use the BAND SDK's API by using a BAND account and connects it to the BAND app.
 *
 *  This method enables users of the app integrated with the BAND SDK to log in to BAND with their accounts and the app to get permissions to use the BAND SDK's API with those accounts.
 *  When they successfully log in, the app is connected with their BAND accounts.
 *
 *  If users have the BAND app 3.0 or later version installed, the BAND SDK opens it to let them log in and gets permissions.
 *
 *  If users have an earlier version of the BAND app installed or if they don't have any BAND app installed, the webview of the BAND SDK is executed to let them log in. 
 *  A user can use one of four methods to log in through the webview.
 *
 *  - Telephone number
 *  - Email address
 *  - Facebook account
 *  - NAVER account
 *
 *  @param completion (nullable) Block code to be executed after login. An error occurred during execution is passed as a parameter.
 */
+ (void)loginWithCompletion:(void (^)(NSError *error))completion;

/**
 *  Removes permissions to access the BAND SDK.
 *
 *  When the API call succeeds, the authentication information stored in the BADN SDK is removed. 
 *  The access permissions to the BAND SDK are removed, but the app's connection with the BAND account is maintained.
 *  Therefore, when the login API is called again, no additional authentication process is required for users to log in to the BAND app. 
 *
 *  @param completion (nullable) Block code to be executed after logout.
 *
 *  @see disconnectWithCompletion:
 */
+ (void)logoutWithCompletion:(void (^)(void))completion;

/**
 *  Removes permissions to access the BAND SDK and disconnects BAND accounts from the app integrated with the BAND SDK.
 *
 *  When the API call succeeds, the authentication information stored in the BAND SDK is removed and the BAND account is disconnected from the app. 
 *  Therefore, when users try to log in after being disconnected from BAND, they should go through the authentication process again.
 *
 *  @param completion (nullable) Block code to be executed after disconnecting the BAND account from the app. An error occurred during execution is passed as a parameter. 
 *
 *  @see logoutWithCompletion:
 */
+ (void)disconnectWithCompletion:(void (^)(NSError *error))completion;

/**
 *  Gets an access token.
 *
 *  @param completion (nullable) Block code to be executed after getting an access token. The access token and an error occurred during execution are passed as parameters.
 */
+ (void)getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

@end


@interface BDKAPI (User)

/**
 *  Gets profile information of a user whose BAND account is connected. 
 *
 *  When the API call succeeds, it returns the BDKProfile object that includes the profile information.
 *
 *  @param completion (nullable) Block code to be executed after getting profile information. The profile information and an error code occurred during execution are passed as parameters. 
 *
 *  @see BDKProfile
 */
+ (void)getProfileWithCompletion:(void (^)(BDKProfile *profile, NSError *error))completion;

/**
 *  Gets an API quota, which refers to a daily spend limits on API requests such as writing a post, sending an invitation, and sending a chat message.
 *
 *  When the API call succeeds, it returns Dictionary that includes the API quota information concerning the functions: writing a post in a Band, sending an invitation, and sending a chat message. The following table shows keys defined in Dictionary.
 *
 *  - BDKQuotaNamePost: Quota for writing a post
 *  - BDKQuotaNameMessage: Quota for sending a chat message
 *  - BDKQuotaNameInvitation: Quota for sending an invitation
 *
 *  Values for the corresponding keys are included in the BDKQuota object where the API quota information belongs.
 *
 *  @param completion (nullable) Block code to be executed after getting an API quota. The retrieved result and an error occurred during execution are passed as parameters.
 *
 *  @see BDKQuota
 */
+ (void)getQuotasWithCompletion:(void (^)(NSDictionary /* <NSString (BDKQuotaName...), BDKQuota> */ *quotas, NSError *error))completion;

@end


@interface BDKAPI (FriendList)

/**
 *  Gets members who have connected their BAND accounts with the app integrated with the BAND SDK, among members of all Bands that the user has joined.
 *
 *  When the API call succeeds, it returns the retrieved list in an array. Elements for the array are included in the BDKProfile object where the profile information of retrieved members belongs.
 *
 *  @param completion (nullable) Block code to be executed after getting members. The retrieved result and an error occurred during execution are passed as parameters.
 *
 *  @see BDKProfile
 */
+ (void)getFriendsWithCompletion:(void (^)(NSArray /* <BDKProfile> */ *friends, NSError *error))completion;

/**
 *  Gets members of a specified Band.
 *
 *  When the API call succeeds, it returns the retrieved list in an array.
 *  Elements for the array are included in the BDKProfile object where the profile information of retrieved members belongs.
 *
 *  @param bandKey           (nonnull) Band ID that indicates a Band whose members are to be returned.
 *  @param allowsDisplaySelf Indicates whether to include myself in the result.
 *  @param completion        (nullable) Block code to be executed after getting members. The retrieved result and an error occurred during execution are passed as parameters.
 *
 *  @see BDKProfile
 */
+ (void)getBandMembersWithBandKey:(NSString *)bandKey allowsDisplaySelf:(BOOL)allowsDisplaySelf completion:(void (^)(NSArray *members, NSError *error))completion;

@end


@interface BDKAPI (BandCreation)

/**
 *  Creates a guild Band.
 *
 *  When the API call succeeds, it returns the BDKBand object that includes the Band information. 
 *  The following values are valid: bandKey, name, and guildBand.
 *
 *  The BAND SDK does not provide function to retrieve a guild Band by user.
 *  Therefore, you must manually manage the Band ID (value for the bandKey property) returned after you create a guild Band.
 *
 *  @param bandName   (nonnull) Name of a Band to be created (max: 50 characters)
 *  @param completion (nullable) Block code to be executed after creating a guild Band. The information of a new Band and an error occurred during execution are passed as parameters. 
 *
 *  @see BDKBand
 */
+ (void)createGuildBandWithBandName:(NSString *)bandName completion:(void (^)(BDKBand *band, NSError *error))completion;

@end


@interface BDKAPI (BandJoin)

/**
 *  Joins a guild Band.
 *
 *  @param bandKey      (nonnull) Band ID that indicates a guild Band to join.
 *  @param nickName     (nullable) User name to be used in the Band (max: 20 characters). If the parameter value is nil, the default profile name of a user is returned.
 *  @param profileImage (nullable) URL of a profile image to be used in the Band. If the parameter value is nil, the default profile image URL of a user is returned.
 *  @param completion   (nullable) Block code to be executed after joining a guild Band. An error occurred during execution is passed as a parameter.
 */
+ (void)joinGuildBandWithBandKey:(NSString *)bandKey nickname:(NSString *)nickname profileImage:(UIImage *)profileImage completion:(void (^)(NSError *error))completion;

/**
 *  Joins an official Band.
 *
 *  @param completion (nullable) Block code to be executed after joining an official Band. An error occurred during execution is passed as a parameter.
 */
+ (void)joinOfficialBandWithCompletion:(void (^)(NSError *error))completion;

@end


@interface BDKAPI (BandInformation)

/**
 *  Gets all Bands that a user joined. 
 *
 *  When the API call succeeds, it returns the retrieved list in an array. Element for the array are included in the BDKBand object where the Band information belongs.
 *
 *  @param completion (nullable) Block code to be executed after getting Bands. The retrieved result and an error occurred during execution are passed as parameters.
 *
 *  @see BDKBand
 */
+ (void)getBandsWithCompletion:(void (^)(NSArray /* <BDKBand> */ *bands, NSError *error))completion;

/**
 *  Gets posts on a guild Band.
 *
 *  When the API call succeeds, it returns a maximum of 20 posts in an array. Elements for the array are instances of the BDKPost class where posts are abstracted.
 *
 *  @param bandKey    (nonnull) Band ID that indicates a Band whose posts are to be returned.
 *  @param after      (nullable) Next occurrence of an ID. nil is returned in the first place.
 *  @param completion (nullable) Block code to be executed after getting posts on a guild Band. The retrieved result, ID of a next post, and an error occurred during execution are passed as parameters.
 *
 *  @see BDKPost, BDKAuthor
 */
+ (void)getGuildBandPostsWithBandKey:(NSString *)bandKey nextPostKey:(NSString *)nextPostKey completion:(void (^)(NSArray /* <BDKPost> */ *posts, NSString *nextPostKey, NSError *error))completion;

/**
 *  Gets notices on a guild Band.
 *
 *  When the API call succeeds, it returns a maximum of 20 notices in an array. Elements for the array are instances of the BDKPost class where posts are abstracted.
 *
 *  @param bandKey    (nonnull) Band ID that indicates a Band whose notices are to be returned.
 *  @param after      (nullable) Next occurrence of an ID. nil is returned in the first place.
 *  @param completion (nullable) Block code to be executed after getting notices on a guild Band. The retrieved result, ID of a next notice, and an error occurred during execution are passed as parameters.
 *
 *  @see BDKPost, BDKAuthor
 */
+ (void)getGuildBandNoticesWithBandKey:(NSString *)bandKey nextPostKey:(NSString *)nextPostKey completion:(void (^)(NSArray /* <BDKPost> */ *notices, NSString *nextPostKey, NSError *error))completion;

/**
 *  Gets an official Band's information.
 *
 *  If no official Band exists, nil is returned as the ID.
 *
 *  @param completion (nullable) Code block to be executed after getting information. The official Band ID, whether a user is a member, and an error occurred during execution are passed as parameters.
 */
+ (void)getOfficialBandInformationWithCompletion:(void (^)(NSString *bandKey, BOOL isJoined, NSError *error))completion;

/**
 *  Gets posts on an official Band.
 *
 *  When the API call succeeds, it returns a maximum of 20 posts in an array. Elements for the array are included in the BDKPost object where the information on the BAND posts belongs.
 *
 *  This API allows a maximum of 20 posts to be retrieved at once. Therefore, it requires information on from which to start upon an API call, which refers to nextPostKey.
 * To get next 20 posts from the list, set the nextPostKey value, which is returned in a block code on the previous call, as a parameter.
 *  No return value from the previous call exists when the first list is retrieved. Therefore, set the nextPostKey parameter as nil to make the 20 most recent posts displayed when the API calls.
 *
 *  @param after      (nullable) Next occurrence of an ID. nil is returned in the first place.
 *  @param completion (nullable) Block code to be executed after getting posts on an official Band. The retrieved result, ID of a next post, and an error occurred during execution are passed as parameters.
 *
 *  @see BDKPost, BDKAuthor
 */
+ (void)getOfficialBandPostsWithNextPostKey:(NSString *)nextPostKey completion:(void (^)(NSArray /* <BDKPost> */ *posts, NSString *nextPostKey, NSError *error))completion;

/**
 *  Get notices on an official Band.
 *
 *  When the API call succeeds, it returns a maximum of 20 notices in an array. Elements for the array are included in the BDKPost object where the information on BAND posts belongs.
 *
 *  @param after      (nullable) Next occurrence of an ID. nil is returned in the first place.
 *  @param completion (nullable) Block code to be executed after getting notices on an official Band. The retrieved result, ID of a next notice, and an error occurred during execution are passed as parameters.
 *
 *  @see BDKPost, BDKAuthor
 */
+ (void)getOfficialBandNoticesWithNextPostKey:(NSString *)nextPostKey completion:(void (^)(NSArray /* <BDKPost> */ *notices, NSString *nextPostKey, NSError *error))completion;

@end


@interface BDKAPI (Post)

/**
 *  Writes a post on a Band.
 *
 *  A post consists of body, one image attachment, and snippet.
 *
 *  The snippet parameter is an instance of the BDKSnippet class where the snippet's UI elements and links are abstracted.
 *  The imageURL property for snippet is not used when using this API.
 *
 *  When the API call succeeds, a post is written and quota information on write request is returned. You can use this information to check the number of quota available to the daily limit. The BDKQuota object is used to return the quota information on write request.
 *
 *  @param bandKey    (nonnull) Band ID that indicates a Band where a post is to be written.
 *  @param body       (nonnull) Body of a post.
 *  @param imageURL   (nullable) URL of an image attachment.
 *  @param snippet    (nonnull) Snippet to be attached.
 *  @param completion (nullable) Block code to be executed after writing a post. The quota information on write request and an error occurred during execution are passed as parameters.
 *
 *  @see BDKSnippet, BDKQuota
 */
+ (void)writePostWithBandKey:(NSString *)bandKey body:(NSString *)body imageURL:(NSURL *)imageURL snippet:(BDKSnippet *)snippet completion:(void (^)(BDKQuota *postQuota, NSError *error))completion;

@end


@interface BDKAPI (Message)

/**
 *  Sends an invitation to Band members who do not connect their Band accounts to the app integrated with the BAND SDK. 
 *
 *  An invitation consists of title, content, image, link name, and link that works with Android or iOS.
 *  These components correspond to the properties of the BDKSnippet class such as title, text, imageURL, linkName, androidLink, and iOSLink.
 *
 *  When the API call succeeds, an invitation is sent and quota information on invitation request is returned. You can use this information to check the number of quota available to the daily limit. The BDKQuota object is used to return the quota information on invitation request.
 *
 *  @param  bandKey     (nonnull) Band ID that indicates a Band which the recipient belongs to.
 *  @param  receiverKey (nonnull) User ID that indicates a recipient who is going to receive an invitation.
 *  @param  snippet     (nonnull) Invitation snippet.
 *  @param  completion  (nullable) Block code to be executed after sending an invitation. The quota information on invitation request and an error occurred during execution are passed as parameters.
 *
 *  @see BDKSnippet, BDKQuota
 */
+ (void)sendInvitationWithBandKey:(NSString *)bandKey receiverKey:(NSString *)receiverKey snippet:(BDKSnippet *)snippet completion:(void (^)(BDKQuota *messageQuota, NSError *error))completion;

/**
 *  Sends a chat message to Band members who have connected their Band account to the app.
 *
 *  A chat message consists of title, content, image, link name, and link that works with Android or iOS.
 *  These components correspond to the properties of the BDKSnippet class such as title, text, imageURL, linkName, and androidLink, iOSLink.
 *
 *  When the API call succeeds, a chat message is sent and quota information on message request is returned. You can use this information to check the number of quota available to the daily limit. The BDKQuota object is used to return the quota information on message request.
 *
 *  @param  bandKey     (nonnull) Band ID that indicates a Band which the recipient belongs to.
 *  @param  receiverKey (nonnull) User ID that indicates a recipient who is going to receive a chat message.
 *  @param  snippet     (nonnull) Chat message snippet.
 *  @param  completion  (nullable) Block code to be executed after sending a chat message. The quota information on message request and an error occurred during execution are passed as parameters.
 *
 *  @see BDKSnippet, BDKQuota
 */
+ (void)sendMessageWithBandKey:(NSString *)bandKey receiverKey:(NSString *)receiverKey snippet:(BDKSnippet *)snippet completion:(void (^)(BDKQuota *messageQuota, NSError *error))completion;

@end


@interface BDKAPI (Open)

/**
 *  Runs the BAND app and opens the BAND home. 
 *
 *  @param  bandKey    (nonnull) Band ID that indicates a Band to be opened.
 *  @param  completion (nullable) Block code to be executed after opening the Band. An error occurred during execution is passed as a parameter.
 */
+ (void)openBandWithBandKey:(NSString *)bandKey completion:(void (^)(NSError *error))completion;

/**
 *  Runs the BAND app and opens a specified post on a Band.
 *
 *  @param  bandKey    (nonnull) Band ID that indicates a Band where a post to be opened exists.
 *  @param  postKey    (nonnull) Post ID that indicates a post to be opened.
 *  @param  completion (nullable) Block code to be executed after opening a post. An error occurred during execution is passed as a parameter.
 */
+ (void)openPostWithBandKey:(NSString *)bandKey postKey:(NSString *)postKey completion:(void (^)(NSError *error))completion;

/**
 *  Runs the BAND app and opens the default chatroom of the specified Band. 
 *
 *  @param  bandKey    (nonnull) Band ID that indicates a Band to be opened.
 *  @param  completion (nullable) Block code to be executed after opening a default chatroom. An error occurred during execution is passed as a parameter.
 */
+ (void)openBandChatWithBandKey:(NSString *)bandKey completion:(void (^)(NSError *error))completion;

/**
 *  Opens the BAND app download page on App Store.
 */
+ (void)installBandApp;

@end


@interface BDKAPI (BandLeave)

/**
 *  Leaves a guild Band. 
 *
 *  @param bandKey    (nonnull) Band ID that indicates a Band that the user is going to leave.
 *  @param completion (nullable) Block code to be executed after leaving a guild Band. An error occurred during execution is passed as a parameter.
 */
+ (void)leaveGuildBandWithBandKey:(NSString *)bandKey completion:(void (^)(NSError *error))completion;

@end
