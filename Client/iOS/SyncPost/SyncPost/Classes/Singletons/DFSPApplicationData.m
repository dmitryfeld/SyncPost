//
//  DFSPApplicationData.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPApplicationData.h"
#import "DFSPSingleton.h"

const static NSString *__kDFSPApplicationDataTag = @"__kDFSPApplicationDataTag";

@interface DFSPApplicationData()<DFSPTagged> {
}

@end

@implementation DFSPApplicationData
@synthesize credentials = _credentials;
@synthesize authorization = _authorization;
@synthesize apnsPushToken = _apnsPushToken;
@synthesize voipPushToken = _voipPushToken;
@dynamic isAuthorized;
- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}
- (id) tag {
    return __kDFSPApplicationDataTag;
}
- (BOOL) isAuthorized {
    BOOL result = NO;
    if (_authorization.token.length) {
        NSDate* now = [NSDate new];
        NSDate* created = [NSDate dateWithTimeIntervalSince1970:_authorization.createdTime];
        NSDate* expire = [NSDate dateWithTimeInterval:_authorization.timeToLive sinceDate:created];
        if ([expire compare:now] == NSOrderedDescending) {
            return YES;
        }
    }
    return result;
}
@end
DFSPApplicationData* DFSPApplicationDataGet() {
    DFSPApplicationData* result = [DFSPSingleton objectForTag:__kDFSPApplicationDataTag];
    if (!result) {
        result = [DFSPApplicationData new];
        [DFSPSingleton addObject:result];
    }
    return result;
}
