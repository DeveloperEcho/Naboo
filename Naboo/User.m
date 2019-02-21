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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

-(void)logoutUserWithAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger ))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kLogoutUser]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:kAuthorization];
    
    //Method and Parameters
    [request setHTTPMethod:@"POST"];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            if (statusCode == 401) {
               completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict,0);
            } else {
                completitionHandler(NO,responseDict,0);
            }
        }
    }];
    [postDataTask resume];
}

- (void)connectWithSocialConnector:(NSString *)socialConnector urlScheme:(NSString*)urlScheme controller:(UIViewController*)controller completitionHandler:(nonnull void (^)(BOOL, NSString * _Nullable))completitionHandler {
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

- (void)loginWithSocialConnector:(NSString*)authToken withDictionary:(NSDictionary*)dictionary  withCompletitionHandler:(void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kSocialConnectorSignIn]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:authToken forHTTPHeaderField:kMobileToken];
    
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

-(void)refreshToken:(NSString*)refreshToken andDeviceId:(NSString*)deviceId withCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler {
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"RefreshToken" : refreshToken,
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

#pragma mark - Password Operations
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    }];
    [postDataTask resume];
}

- (void)changePasswordWithAccessToken:(NSString*)accessToken oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler{
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:kAuthorization];
    
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
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(YES,responseDict,0);
        }
    }];
    [postDataTask resume];
}

-(void)setPassword:(NSString*)password withAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler {
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:kAuthorization];
    
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
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict,0);
            } else {
                completitionHandler(NO,responseDict,0);
            }
        }
    }];
    [postDataTask resume];
}

#pragma mark - Registration Operations
-(void)registerUser:(NSDictionary *)userDict withCompletion:(nonnull void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler {
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

#pragma mark - User Account Operations
- (void)getUserAccount:(NSString *)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kGetUserAccount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:@"APIAccessKey"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken]  forHTTPHeaderField:@"Authorization"];
    
    //Method and Parameters
    [request setHTTPMethod:@"GET"];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict,0);
            } else {
                completitionHandler(NO,responseDict,0);
            }
        }
    }];
    [postDataTask resume];
}

-(void)updateUserAccount:(NSMutableDictionary*)dict andAccessToken:(NSString*)accessToken withCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    NSError *error;
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kUpdateUserAccount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id key in dict) {
        NSString* string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
        if ([string isEqualToString:@""]) {
            [array addObject:key];
        }
    }
    
    if (array.count > 0) {
        [dict removeObjectsForKeys:array];
    }
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken]  forHTTPHeaderField:@"Authorization"];
    
    //Method and Parameters
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completitionHandler(YES,responseDict,0);
        }
    }];
    [postDataTask resume];
}

- (void)updateUserImage:(NSString*)base64String andAccessToken:(NSString*)accessToken withCompletition:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kUserUploadImage]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken]  forHTTPHeaderField:@"Authorization"];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"ImageBase64Data" : base64String,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict,0);
            } else {
                completitionHandler(NO,responseDict,0);
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getCountries:(NSString*)searchValue andAccessToken:(NSString*)accessToken withCompletition:(nonnull void (^)(BOOL, NSDictionary * _Nullable, NSInteger))completitionHandler {
    NabooApp *app = [NabooApp sharedInstance];
    
    //Configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.configuration.server,kCountries]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //Header Fields
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:app.configuration.applicationId forHTTPHeaderField:kApiKey];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accessToken]  forHTTPHeaderField:@"Authorization"];
    
    //Method and Parameters
    NSDictionary *parameters = @{
                                 @"SearchValue" : searchValue,
                                 };
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    [request setHTTPBody:postData];
    
    //Session Task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            if (statusCode == 401) {
                completitionHandler(NO,nil,401);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                completitionHandler(NO,responseDict,0);
            }
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString* message = [responseDict valueForKey:@"Message"];
            if (message == (id)[NSNull null] || message.length == 0 ) {
                completitionHandler(YES,responseDict,0);
            } else {
                completitionHandler(NO,responseDict,0);
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
