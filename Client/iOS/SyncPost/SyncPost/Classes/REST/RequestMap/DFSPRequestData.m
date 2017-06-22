//
//  DFSPRequestData.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestData.h"

@interface DFSPRequestData() {
@private
    __strong NSString* _name;
    __strong NSString* _contentType;
    __strong NSString* _requestPath;
    __strong NSString* _method;
    BOOL _simulated;
    __strong NSString* _simulatedDataPath;
    __strong NSDictionary<NSString*,id>* _parameters;
    __strong NSDictionary<NSString*,id>* _body;
}

@end

@implementation DFSPRequestData
@synthesize name = _name;
@synthesize contentType = _contentType;
@synthesize requestPath = _requestPath;
@synthesize method = _method;
@synthesize simulated = _simulated;
@synthesize simulatedDataPath = _simulatedDataPath;
@synthesize parameters = _parameters;
@synthesize body = _body;
- (instancetype) init {
    if (self = [self initWithDisctionary:nil]) {
    }
    return self;
}
- (instancetype) initWithDisctionary:(NSDictionary<NSString*,id>*)dictionary {
    if (self = [super init]) {
        _name = dictionary[@"name"];
        _contentType = dictionary[@"contentType"];
        _requestPath = dictionary[@"requestPath"];
        _method = dictionary[@"method"];
        _simulatedDataPath = dictionary[@"simulatedDataPath"];
        _simulated = [dictionary[@"simulated"] boolValue];
        _parameters = dictionary[@"parameters"];
        _body = dictionary[@"body"];
    }
    return self;
}
@end
