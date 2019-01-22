//
//  User.m
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import "User.h"
#import "NabooApp.h"

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

- (void)registerUser:(NSDictionary *)userDict {
    NSLog(@"Register User");
}

- (void)forgotPassword {
    NSLog(@"FORGOT PASSWORD");
}

- (void)loginWithSocialConnector:(NSString *)socialConnector {
    NSLog(@"Login with social connector %@",socialConnector);
}

- (void)loginWithUserName:(NSString *)username password:(NSString *)password {
    NSLog(@"Login with username %@, and password %@",username,password);
}

- (void)changePasswordWithUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    NSLog(@" chagne password username %@,old password %@ , new password %@",username,oldPassword,newPassword);
}

- (void)getUserAccount:(NSString *)username {
    NSLog(@"get user account %@",username);
}

- (void)updateUserAccount:(NSDictionary *)dictionary {
    NSLog(@"Update user account %@",dictionary);
}

- (void)logConfiguration {
    NabooApp *app = [NabooApp sharedInstance];
    NSLog(@"server %@",app.configuration.server);
    NSLog(@"clientKey %@",app.configuration.clientKey);
    NSLog(@"applicationKey %@",app.configuration.applicationId);
}

- (void)activateUserAccount {
    NSLog(@"Activate user account");
}
@end
