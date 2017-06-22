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
- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
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
