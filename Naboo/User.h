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

-(void)registerUser:(NSDictionary*)userDict withCompletion:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;
-(void)forgotPasswordWithCompletion:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;
-(void)activateUserAccountWithCompletion:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;
- (void)loginWithSocialConnector:(NSString *)socialConnector urlScheme:(NSString*)urlScheme controller:(UIViewController*)controller completitionHandler:(nonnull void (^)(BOOL, NSString * _Nullable))completitionHandler;
-(void)loginWithUserName:(NSString*)username password:(NSString*)password completitionHandler:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;;
-(void)changePasswordWithUsername:(NSString*)username oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword completitionHandler:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;;
-(void)getUserAccount:(NSString*)username completitionHandler:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;;
-(void)updateUserAccount:(NSDictionary*)dictionary completitionHandler:(void (^)(BOOL success,NSDictionary* dictionary))completitionHandler;;
-(void)logConfiguration;
//test bitcode
@end

NS_ASSUME_NONNULL_END
