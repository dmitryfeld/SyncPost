//
//  DFSPRestRequest.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestRequest.h"
#import "DFSPEnvironment.h"

@interface DFSPRestRequest() {
@private
    __strong DFSPAccessPoint* _accessPoint;
}

@end

@implementation DFSPRestRequest
@synthesize accessPoint = _accessPoint;
- (instancetype) init {
    if (self = [self initWithAccessPoint:nil]) {
        _accessPoint = nil;
    }
    return self;
}
- (instancetype) initWithAccessPoint:(DFSPAccessPoint*)accessPoint {
    if (self = [super init]) {
        _accessPoint = accessPoint;
    }
    return self;
}
- (NSMutableURLRequest*) formURLRequest {
    return nil;
}
- (NSString*) simulatedFileName {
    return nil;
}
@end
