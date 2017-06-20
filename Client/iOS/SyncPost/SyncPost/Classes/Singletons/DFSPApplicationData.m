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
    __strong DFSPCredentials* _credentials;
    __strong DFSPAuthorization* _authorization;
}

@end

@implementation DFSPApplicationData
@synthesize credentials = _credentials;
@synthesize authorization = _authorization;
- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}
- (void) authentifyWithCredentials:(DFSPCredentials*)credentials {
    if (![_credentials isEqual:credentials]) {
        _credentials = credentials;
    }
}
- (void) authorizeWithAuthorization:(DFSPAuthorization*)authorization {
    if (![_authorization isEqual:authorization]) {
        _authorization = authorization;
    }
}

- (id) tag {
    return __kDFSPApplicationDataTag;
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
