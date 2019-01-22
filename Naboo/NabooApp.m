//
//  NabooApp.m
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import "NabooApp.h"

static NabooApp* _sharedInstance = nil;

@implementation NabooApp

+ (NabooApp*)sharedInstance {
    @synchronized([NabooApp class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[NabooApp alloc] init];
        });
        return _sharedInstance;
    }
    return nil;
}

-(void)initializeConfiguration:(NabooConfiguration *)configuration {
    self.configuration = configuration;
}

@end
