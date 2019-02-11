//
//  User.h
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject <NSURLSessionDelegate>

// User Properties
@property (nonatomic,assign) long userId;
@property (nonatomic,strong) NSString* username;


-(instancetype)initWithDictionary:(NSDictionary*)userDict;

-(void)registerUser:(NSDictionary *)userDict withCompletion:(nonnull void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler;
-(void)forgotPasswordForEmail:(NSString*)email withCompletitionHandler:(void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler;
-(void)loginWithEmail:(NSString *)email password:(NSString *)password deviceId:(NSString*)deviceId completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)connectWithSocialConnector:(NSString *)socialConnector urlScheme:(NSString*)urlScheme controller:(UIViewController*)controller completitionHandler:(nonnull void (^)(BOOL, NSString * _Nullable))completitionHandler;
-(void)changePasswordWithAccessToken:(NSString*)accessToken oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)logoutUserWithAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)refreshToken:(NSString*)accessToken andDeviceId:(NSString*)deviceId  withCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)setPassword:(NSString*)password withAccessToken:(NSString*)accessToken andCompletitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)loginWithSocialConnector:(NSString*)authToken withDictionary:(NSDictionary*)dictionary  withCompletitionHandler:(void (^)(BOOL success, NSDictionary * _Nullable))completitionHandler;

-(void)getUserAccount:(NSString *)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)updateUserAccount:(NSDictionary *)userDict accessToken:(NSString*)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)logConfiguration;

-(void)getSocialConnectors:(NSString *)accessToken completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completitionHandler;
-(void)userInterests:(NSString *)searchValue completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable ))completitionHandler;

-(void)subscribeDevice:(NSDictionary *)dictionary completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nullable ))completitionHandler;
 
//test bitcode
@end

NS_ASSUME_NONNULL_END
