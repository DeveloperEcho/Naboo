//
//  User.m
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import "User.h"
#import "NabooApp.h"
#import <MicrosoftAzureMobile.h>
#import "Naboo.h"
#import "Constants.h"

@implementation User

-(instancetype)init {
    self = [super init];
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)userDict {
    self = [super init];
    if (self) {
        self.username = userDict[@"username"];
        self.userId = [userDict[@"userId"] longValue];
    }
    return self;
}


#pragma mark - User Authentication
- (void)registerUser:(NSDictionary *)userDict withCompletion:(nonnull void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kRegisterUser]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

- (void)forgotPasswordForEmail:(NSString*)email withCompletitionHandler:(void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kForgotPassword]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"Email" : email,
                                };
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
        }
    }];
    [postDataTask resume];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password deviceId:(NSString*)deviceId completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kLoginUser]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"Email" : email,
                                 @"Password" : password,
                                 @"DeviceId" : deviceId,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

- (void)loginWithSocialConnector:(NSString *)socialConnector urlScheme:(NSString*)urlScheme controller:(UIViewController*)controller completitionHandler:(nonnull void (^)(BOOL, NSString * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    MSClient *client = app.configuration.client;
    [client loginWithProvider:socialConnector urlScheme:urlScheme controller:controller animated:YES completion:^(MSUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Login failed with error: %@, %@", error, [error userInfo]);
            completitionHandler(NO,nil);
        } else {
            client.currentUser = user;
            NSString* token = client.currentUser.mobileServiceAuthenticationToken;
            completitionHandler(YES,token);
        }
    }];
    // treba da se naprave povik do azure najverojatno za social network login, istoto so e na tvizzy
    NSLog(@"Login with social connector %@",socialConnector);
}

- (void)changePasswordWithAccessToken:(NSString*)accessToken oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler{
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kChangePassword]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:accessToken forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"OldPassword" : oldPassword,
                                 @"NewPassword" : newPassword,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

-(void)logoutUserWithAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kLogoutUser]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:accessToken forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    [request setHTTPMethod:@"POST"];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

-(void)refreshToken:(NSString*)accessToken andDeviceId:(NSString*)deviceId withCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kRefreshToken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"RefreshToken" : accessToken,
                                 @"DeviceId" : deviceId,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

-(void)setPassword:(NSString*)password withAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kSetPassword]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:accessToken forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"Password" : password,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}


#pragma mark - User Account
- (void)getUserAccount:(NSString *)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kGetUserAccount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:accessToken forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    [request setHTTPMethod:@"GET"];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

- (void)updateUserAccount:(NSDictionary *)userDict accessToken:(NSString*)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler{
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kUpdateUserAccount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:accessToken forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

#pragma mark - Additional Data
- (void)getSocialConnectors:(NSString *)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler{
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kSocialConnectors]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    [request setHTTPMethod:@"GET"];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

- (void)userInterests:(NSString *)searchValue completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable ))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kUserInterests]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"SearchValue" : searchValue,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

#pragma mark - Device Operations
- (void)subscribeDevice:(NSDictionary *)dictionary completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable ))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kSubscribeDevice]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(NO,responseDict);
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict);
            } else {
                completitionHandler(NO,responseDict);
            }
        }
    }];
    [postDataTask resume];
}

- (void)logConfiguration {
    NabooApp *app = [NabooApp sharedInstance];
    NSLog(@"server %@",app.configuration.server);
    NSLog(@"clientKey %@",app.configuration.clientKey);
    NSLog(@"applicationKey %@",app.configuration.applicationId);
}

- (void)activateUserAccountWithCompletion:(void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    NSLog(@"Activate user account");
}

@end
