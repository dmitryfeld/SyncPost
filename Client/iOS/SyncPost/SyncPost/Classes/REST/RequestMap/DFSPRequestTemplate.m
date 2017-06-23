//
//  DFSPRequestTemplate.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestTemplate.h"
#import "DFSPSettings.h"
#import "NSError+Rest.h"

@interface DFSPRequestTemplate() {
@private
    __strong NSString* _name;
    __strong NSString* _contentType;
    __strong NSString* _requestPath;
    __strong NSString* _method;
    BOOL _simulated;
    __strong NSString* _simulatedDataPath;
    __strong NSDictionary<NSString*,NSString*>* _parameters;
    __strong NSDictionary<NSString*,NSString*>* _body;
}

@end

@implementation DFSPRequestTemplate
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
- (NSURLRequest*) prepareRequestWithContext:(id)context withError:(NSError * _Nullable *)error {
    DFSPEnvironment* environmenr = DFSPSettingsGet().environment;
    NSURL* requestURL = [environmenr.accessURL URLByAppendingPathComponent:_requestPath];
    NSMutableURLRequest* result = [NSMutableURLRequest requestWithURL:requestURL];
    result.HTTPMethod = @"GET";
    if (_method.length) {
        result.HTTPMethod = _method;
    }
    [self resolveHeadersForRequest:result withContext:context];
    if ([result.HTTPMethod isEqualToString:@"POST"] || [result.HTTPMethod isEqualToString:@"PUT"]) {
        [self resolveBodyForContext:context];
    }
    return result;
}
- (id<DFSPModel>) processResponse:(NSDictionary*)response withError:(NSError * _Nullable *)error {
    id<DFSPModel> result = [self contentForType:_contentType andContent:response[@"content"]];
    NSError* restError = [self errorForContent:response[@"error"]];
    if (!restError && !result) {
        restError = [NSError restErrorWithCode:kTPMGRestErrorInvalidResponseObject];
    }
    *error = restError;
    return result;
}
- (void) resolveHeadersForRequest:(NSMutableURLRequest*)request withContext:(id)context {
    if (_parameters.count) {
        NSArray<NSString*>* keys = _parameters.allKeys;
        NSString* keyPath = nil;
        id value = nil;
        for (NSString* key in keys) {
            keyPath = _parameters[key];
            if (keyPath.length) {
                value = [context valueForKeyPath:keyPath];
                if (value) {
                    [request setValue:value forHTTPHeaderField:key];
                }
            }
        }
    }
}
- (void) resolveBodyForRequest:(NSMutableURLRequest*)request withContext:(id)context {
    NSDictionary<NSString*,NSString*>* bodyDict = [self resolveBodyForContext:context];
    if (bodyDict.count) {
        NSError* error = nil;
        NSData* bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:&error];
        NSNumber* length = [NSNumber numberWithInteger:bodyData.length];
        [request setValue:length.description forHTTPHeaderField:@"Content-Lenght"];
    }
}
- (NSDictionary<NSString*,NSString*>*) resolveBodyForContext:(id) context {
    NSDictionary<NSString*,NSString*>* result = nil;
    if (_body.count) {
        NSArray<NSString*>* keys = _parameters.allKeys;
        NSString* keyPath = nil;
        NSMutableDictionary<NSString*,NSString*>* temp = [NSMutableDictionary<NSString*,NSString*> new];
        id value = nil;
        for (NSString* key in keys) {
            keyPath = _body[key];
            if (keyPath.length) {
                value = [context valueForKeyPath:keyPath];
                if (value) {
                    [temp setValue:value forKey:key];
                }
            }
        }
        result = [NSDictionary<NSString*,NSString*> dictionaryWithDictionary:temp];
    }
    return result;
}

- (id<DFSPModel>) contentForType:(NSString*)type andContent:(NSDictionary<NSString*,NSString*>*)content {
    id<DFSPModel> result = nil;
    if ([content isKindOfClass:[NSDictionary<NSString*,NSString*> class]]) {
        Class loadingClass = NSClassFromString(type);
        id<DFSPModelKVP> model = [loadingClass new];
        if ([model conformsToProtocol:@protocol(DFSPModelKVP)]) {
            if ([model respondsToSelector:@selector(setValuesForKeysWithDictionary:)]) {
                [model performSelector:@selector(setValuesForKeysWithDictionary:) withObject:content];
                result = [model immutableCopy];
            }
        }
    }
    return result;
}
- (NSError*) errorForContent:(NSDictionary<NSString*,NSString*>*)content {
    NSError* result = nil;
    if ([content isKindOfClass:[NSDictionary<NSString*,NSString*> class]]) {
        NSUInteger code = content[@"code"].integerValue;
        NSString* message = content[@"message"];
        if (code) {
            result = [NSError restErrorWithCode:code andMessage:message];
        }
    }
    return result;
}

@end
