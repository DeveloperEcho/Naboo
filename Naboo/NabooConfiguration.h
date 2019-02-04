//
//  NabooConfiguration.h
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicrosoftAzureMobile.h>

NS_ASSUME_NONNULL_BEGIN

@interface NabooConfiguration : NSObject

@property (nonatomic,strong) NSString* applicationId;
@property (nonatomic,strong) NSString* clientKey;
@property (nonatomic,strong) NSString* server;

@property (strong,nonatomic) MSClient *client;

-(id)initWithApplicationKey:(NSString *)applicationKey server:(NSString *)server microsoftLoginConnectorsUrl:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
