//
//  NabooConfiguration.m
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import "NabooConfiguration.h"

@implementation NabooConfiguration

-(id)initWithApplicationKey:(NSString *)applicationKey server:(NSString *)server microsoftLoginConnectorsUrl:(NSString*)url{
    self = [super init];
    if (self) {
        self.applicationId = applicationKey;
        self.server = server;
        self.client = [MSClient clientWithApplicationURL:[NSURL URLWithString:url]];
    }
    return self;
}
@end
