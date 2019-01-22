//
//  User.h
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// User Properties
@property (nonatomic,assign) long userId;
@property (nonatomic,strong) NSString* username;


-(instancetype)initWithDictionary:(NSDictionary*)userDict;

-(void)registerUser:(NSDictionary*)userDict;
-(void)forgotPassword;
-(void)activateUserAccount;
-(void)loginWithSocialConnector:(NSString*)socialConnector;
-(void)loginWithUserName:(NSString*)username password:(NSString*)password;
-(void)changePasswordWithUsername:(NSString*)username oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword;
-(void)getUserAccount:(NSString*)username;
-(void)updateUserAccount:(NSDictionary*)dictionary;
-(void)logConfiguration;

@end

NS_ASSUME_NONNULL_END
