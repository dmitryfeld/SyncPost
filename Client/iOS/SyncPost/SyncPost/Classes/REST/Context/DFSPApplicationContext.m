//
//  DFSPApplicationContext.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/22/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DFSPApplicationContext.h"
#import "DFSPApplicationData.h"
#import "DFSPSettings.h"

@implementation DFSPApplicationContext
@dynamic credentials;
@dynamic authorization;
@dynamic appName;
@dynamic deviceType;
@dynamic osVersion;
@dynamic apnsPushToken;
@dynamic voipPushToken;
- (instancetype) init {
    if (self = [super init]) {
    }
    return self;
}
- (DFSPCredentials*) credentials {
    return DFSPApplicationDataGet().credentials;
}
- (DFSPAuthorization*) authorization {
    return DFSPApplicationDataGet().authorization;
}
- (NSString*) appName {
    return DFSPSettingsGet().applicationName;
}
- (NSString*) deviceType {
    return [[UIDevice currentDevice] localizedModel];
}
- (NSString*) osVersion {
    return [[UIDevice currentDevice] systemVersion];
}
- (NSString*) apnsPushToken {
    return DFSPApplicationDataGet().apnsPushToken;
}
- (NSString*) voipPushToken {
    return DFSPApplicationDataGet().voipPushToken;
}
@end
