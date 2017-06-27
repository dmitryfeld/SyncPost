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
    __strong NSString* _simulatedDataPath;
    __strong NSDictionary<NSString*,NSString*>* _parameters;
    __strong NSDictionary<NSString*,NSString*>* _body;
    __strong NSError* _error;
}

@end

@implementation DFSPRequestTemplate
@synthesize name = _name;
@synthesize contentType = _contentType;
@synthesize requestPath = _requestPath;
@synthesize method = _method;
@synthesize simulatedDataPath = _simulatedDataPath;
@synthesize parameters = _parameters;
@synthesize body = _body;
@synthesize error = _error;
- (instancetype) init {
    if (self = [self initWithDisctionary:nil]) {
        [NSException raise:@"DFSPRequestTemplate Init" format:@"Invalid Arguments"];
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
        _parameters = dictionary[@"parameters"];
        _body = dictionary[@"body"];
        _error = [self checkParameters];
    }
    return self;
}

#pragma mark Prepare Request
- (NSURLRequest*) prepareRequestWithContext:(id)context {
    DFSPEnvironment* environment = DFSPSettingsGet().environment;
    NSURL* requestURL = [environment.accessURL URLByAppendingPathComponent:_requestPath];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    if (_method.length) {
        request.HTTPMethod = _method;
    }
    _error = nil;
    [self resolveHeadersForRequest:request withContext:context];
    if ([request.HTTPMethod isEqualToString:@"POST"] || [request.HTTPMethod isEqualToString:@"PUT"]) {
        _error = [self resolveBodyForRequest:request withContext:context];
    }
    return request;
}

#pragma mark Process Response
- (id<DFSPModel>) processResponse:(NSDictionary*)response {
    id<DFSPModel> model = nil;
    _error = [self errorForContent:response[@"error"]];
    if (!_error) {
        model = [self contentForType:_contentType andDictionary:response[@"content"]];
    }
    return model;
}

#pragma mark Resolvers
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
                } else {
                    _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andMessage:[NSString stringWithFormat:@"Undefined Request Parameters Context Value for Key Path: %@",keyPath]];
                }
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andComment:@"Undefined Request Parameters Key"];
            }
        }
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andComment:@"Undefined Request Parameters Map"];
    }
}
- (NSError*) resolveBodyForRequest:(NSMutableURLRequest*)request withContext:(id)context {
    NSDictionary<NSString*,NSString*>* bodyDict = [self resolveBodyForContext:context];
    NSError* error = nil;
    if (bodyDict.count) {
        NSData* bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSNumber* length = [NSNumber numberWithInteger:bodyData.length];
            [request setValue:length.description forHTTPHeaderField:@"Content-Lenght"];
            request.HTTPBody = bodyData;
        } else {
            _error = error;
        }
    }
    return error;
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
                } else {
                    _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andMessage:[NSString stringWithFormat:@"Undefined Request Body Context Value for Key Path: %@",keyPath]];
                }
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andComment:@"Undefined Request Body Key"];
            }
        }
        result = [NSDictionary<NSString*,NSString*> dictionaryWithDictionary:temp];
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateContent andComment:@"Undefined Request Body Map"];
    }
    return result;
}

#pragma mark Utility methods
- (id<DFSPModel>) contentForType:(NSString*)type andDictionary:(NSDictionary<NSString*,NSString*>*)content {
    id<DFSPModel> result = nil;
    if ([content isKindOfClass:[NSDictionary<NSString*,NSString*> class]]) {
        NSString* adjustedType = [self adjustType:type];
        Class loadingClass = NSClassFromString([self adjustType:adjustedType]);
        if (loadingClass) {
            id<DFSPModelKVP> model = [loadingClass new];
            if ([model conformsToProtocol:@protocol(DFSPModelKVP)]) {
                if ([model respondsToSelector:@selector(setValuesForKeysWithDictionary:)]) {
                    [model performSelector:@selector(setValuesForKeysWithDictionary:) withObject:content];
                    if (model.error) {
                        _error = model.error;
                    }
                    result = [model immutableCopy];
                } else {
                    _error = [NSError restErrorWithCode:kDFSPRestErrorRestTemplateResponseMapping andComment:[NSString stringWithFormat:@"Model Maping Class(%@) does not confirm to KVP protocol",type]];
                }
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorRestTemplateResponseMapping andComment:[NSString stringWithFormat:@"Model Maping Class(%@) does not confirm to KVP protocol",type]];
            }
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorRestTemplateResponseMapping andComment:[NSString stringWithFormat:@"Can not load Model Maping Class(%@)",adjustedType]];
        }
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorRestTemplateResponseMapping andComment:@"Undefined Content Dictionary"];
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
- (NSString*) adjustType:(NSString*)type {
    NSString* result = type;
    NSRange range = [result rangeOfString:@"KVP"];
    if (range.location == NSNotFound) {
        result = [NSString stringWithFormat:@"%@KVP",result];
    }
    return result;
}
- (NSError*) checkParameters {
    NSError* result = nil;
    if (!_name.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateParameter andComment:@"name"];
    } else if (!_contentType.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateParameter andComment:@"contentType"];
    } else if (!_requestPath.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateParameter andComment:@"requestPath"];
    } else if (!_method.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateParameter andComment:@"method"];
    } else if (!_simulatedDataPath.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRestTemplateParameter andComment:@"simulatedDataPath"];
    }
    return result;
}
@end
