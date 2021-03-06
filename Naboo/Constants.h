//
//  Constants.h
//  Naboo
//
//  Created by Filip Stevanoski on 2/4/19.
//  Copyright © 2019 Echo. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static NSString * const kApiKey = @"APIAccessKey";
static NSString * const kAuthorization = @"Authorization"; 
static NSString * const kMobileToken = @"MOBILE-SERVICE-AUTH-TOKEN";

//User Authentication Endpoints
static NSString * const kLoginUser = @"LoginUser";
static NSString * const kLogoutUser = @"LogoutUser";
static NSString * const kRefreshToken = @"RefreshToken";
static NSString * const kSocialConnectorSignIn = @"SocialConnectorSignin";
static NSString * const kFacebookLogin = @"FacebookSignin";

//Password Endpoints
static NSString * const kForgotPassword = @"ForgotPassword";
static NSString * const kChangePassword = @"ChangePassword";
static NSString * const kSetPassword = @"SetPassword";

//User Account
static NSString * const kGetUserAccount = @"GetUserAccount";
static NSString * const kUpdateUserAccount = @"UpdateUserAccount";
static NSString * const kUserUploadImage = @"UserUploadImage";

//Registration Endpoints
static NSString * const kRegisterUser = @"RegisterUser";
static NSString * const kSubscribeDevice = @"SubscribeDevice";

//Additional Data Endpoints
static NSString * const kSocialConnectors = @"SocialConnectors";
static NSString * const kUserInterests = @"UserInterests";
static NSString * const kCountries = @"Countries";

static NSString * const kCheckIfUserExists = @"SocialConnectorCheckIfUserExists";
static NSString * const kGetPrivacyPolicy = @"GetPrivacyPolicy";

//Messages for nil Data error
static NSString * const kDefaultErrorMessage = @"An error occurred, please try again later";

#endif /* Constants_h */
