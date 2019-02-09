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

//User Authentication
static NSString * const kRegisterUser = @"RegisterUser";
static NSString * const kForgotPassword = @"ForgotPassword";
static NSString * const kLoginUser = @"LoginUser";
static NSString * const kChangePassword = @"ChangePassword";
static NSString * const kLogoutUser = @"LogoutUser";
static NSString * const kRefreshToken = @"RefreshToken";
static NSString * const kSetPassword = @"SetPassword";

static NSString * const kSocialConnectorSignIn = @"SocialConnectorSignin";

//User Account
static NSString * const kGetUserAccount = @"GetUserAccount";
static NSString * const kUpdateUserAccount = @"UpdateUserAccount";

//Additional Data
static NSString * const kSocialConnectors = @"SocialConnectors";
static NSString * const kUserInterests = @"UserInterests";

//Device Operations
static NSString * const kSubscribeDevice = @"SubscribeDevice";

#endif /* Constants_h */
