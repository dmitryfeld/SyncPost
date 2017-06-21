//
//  DFSPAuthorizationRequest.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/20/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DFSPAuthorizationRequest.h"
#import "DFSPSettings.h"

@implementation DFSPAuthorizationRequest
- (NSMutableURLRequest*) formURLRequest {
    DFSPAccessPoint* accessPoint = self.accessPoint;
    DFSPEnvironment* environmenr = DFSPSettingsGet().environment;
    NSURL* requestURL = [environmenr.accessURL URLByAppendingPathComponent:accessPoint.requestPath];
    
    NSMutableURLRequest* result = [NSMutableURLRequest requestWithURL:requestURL];
    result.HTTPMethod = @"GET";
    
    if (accessPoint.authorization.authorizationToken.length) {
        [result setValue:accessPoint.authorization.authorizationToken forHTTPHeaderField:@"authorizationToken"];
    } else {
        [result setValue:accessPoint.credentials.userName forHTTPHeaderField:@"userName"];
        [result setValue:accessPoint.credentials.password forHTTPHeaderField:@"password"];
    }
    if (DFSPSettingsGet().appVersionString.length) {
        [result setValue:DFSPSettingsGet().appVersionString forHTTPHeaderField:@"appVersion"];
    }
    if (DFSPSettingsGet().applicationName.length) {
        [result setValue:DFSPSettingsGet().applicationName forHTTPHeaderField:@"appName"];
    }
    [result setValue:[[UIDevice currentDevice]localizedModel] forHTTPHeaderField:@"deviceType"];
    [result setValue:[[UIDevice currentDevice]systemVersion] forHTTPHeaderField:@"osVersion"];
    
    return result;
}
- (NSString*) simulatedFileName {
    return @"token";
}

@end
