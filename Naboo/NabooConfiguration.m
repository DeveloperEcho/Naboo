//
//  NabooConfiguration.m
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import "NabooConfiguration.h"

@implementation NabooConfiguration

-(id)initWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey server:(NSString *)server {
    self = [super init];
    if (self) {
        self.applicationId = applicationId;
        self.clientKey = clientKey;
        self.server = server;
    }
    return self;
}
@end
