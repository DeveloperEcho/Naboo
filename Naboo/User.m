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

- (void)registerUser:(NSDictionary *)userDict withCompletion:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    // treba da se naprave tuka registracija na user
    // treba da se definire kakvo dictionary ke ode do server.
}

- (void)forgotPasswordWithCompletion:(void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    // treba da se definire so tochno ke sa deshave tuka
    NSLog(@"FORGOT PASSWORD");
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

- (void)loginWithUserName:(NSString *)username password:(NSString *)password completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    // treba da se naprave povik za login so username i password
    NSLog(@"Login with username %@, and password %@",username,password);
}

- (void)changePasswordWithUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler{
    // treba da se naprave povik za da se smeni passwordot na userot so parametrite primeni vo funkcijata
    NSLog(@" chagne password username %@,old password %@ , new password %@",username,oldPassword,newPassword);
}

- (void)getUserAccount:(NSString *)username completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler{
    NSLog(@"get user account %@",username);
}

- (void)updateUserAccount:(NSDictionary *)dictionary completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler{
    NSLog(@"Update user account %@",dictionary);
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
