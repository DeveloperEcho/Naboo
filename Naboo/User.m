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

- (void)registerUser:(NSDictionary *)userDict withCompletion:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    
    
    // treba da se naprave tuka registracija na user
    // treba da se definire kakvo dictionary ke ode do server.
    NabooApp *app = [NabooApp sharedInstance];
    
    NSString *targetUrl = [NSString stringWithFormat:@"%@/RegisterUser", app.configuration.server];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Make an NSDictionary that would be converted to an NSData object sent over as JSON with the request body
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];

    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:targetUrl]];

    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data,
       NSURLResponse * _Nullable response,
       NSError * _Nullable error) {
         if (!error) {
             NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSData* jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];

             NSError *error = nil;
             NSDictionary  *responseDict = [NSJSONSerialization
                                      JSONObjectWithData:jsonData
                                      options:0
                                      error:&error];
             NSLog(@"Data received: %@", responseDict);
             NSLog(@"Register User");
             completitionHandler(YES,responseDict);
         } else {
             completitionHandler(NO,[[NSDictionary alloc] init]);
         }
     }];
    
}

- (void)forgotPasswordWithCompletion:(void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
    // treba da se definire so tochno ke sa deshave tuka
    NSLog(@"FORGOT PASSWORD");
}

- (void)loginWithSocialConnector:(NSString *)socialConnector completitionHandler:(nonnull void (^)(BOOL, NSDictionary * _Nonnull))completitionHandler {
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

/*
 // making a GET request to /init
 NSString *targetUrl = [NSString stringWithFormat:@"%@/init", baseUrl];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setHTTPMethod:@"GET"];
 [request setURL:[NSURL URLWithString:targetUrl]];
 
 [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
 ^(NSData * _Nullable data,
 NSURLResponse * _Nullable response,
 NSError * _Nullable error) {
 
 NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"Data received: %@", myString);
 }] resume];
 */

/*
 // making a POST request to /init
 NSString *targetUrl = [NSString stringWithFormat:@"%@/init", baseUrl];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 
 //Make an NSDictionary that would be converted to an NSData object sent over as JSON with the request body
 NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
 @"basic_attribution", @"scenario_type",
 nil];
 NSError *error;
 NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
 
 [request setHTTPBody:postData];
 [request setHTTPMethod:@"POST"];
 [request setURL:[NSURL URLWithString:targetUrl]];
 
 [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
 ^(NSData * _Nullable data,
 NSURLResponse * _Nullable response,
 NSError * _Nullable error) {
 
 NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"Data received: %@", responseStr);
 }] resume];
 */
@end
