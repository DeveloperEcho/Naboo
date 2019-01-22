//
//  NabooApp.h
//  Naboo
//
//  Created by Echo on 22/01/2019.
//  Copyright © 2019 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NabooConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface NabooApp : NSObject

+(NabooApp*)sharedInstance;

-(void)initializeConfiguration:(NabooConfiguration *)configuration;

@property (nonatomic,strong) NabooConfiguration* configuration;

@end

NS_ASSUME_NONNULL_END
