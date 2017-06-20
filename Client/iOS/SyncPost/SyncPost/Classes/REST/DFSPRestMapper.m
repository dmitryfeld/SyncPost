//
//  DFSPRestMapper.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestMapper.h"
#import "DFSPRestResponse.h"
#import "NSError+Rest.h"

@interface DFSPRestResponse(DFSPRestMapper)
- (instancetype) initWithError:(NSError*)error andModel:(id<DFSPModel>)model;
@end

@interface DFSPRestMapper() {
@private
    __strong NSDictionary<NSString*,NSString*>* _map;
    __strong NSError* _mappingError;
}
@end

@implementation DFSPRestMapper
@synthesize map = _map;
@synthesize mappingError = _mappingError;
- (instancetype) init {
    if (self = [self initWithMap:nil]) {
        _map = nil;
    }
    return self;
}
- (instancetype) initWithMap:(NSDictionary<NSString*,NSString*>*)map {
    if (self = [super init]) {
        _map = map;
    }
    return self;
}
- (DFSPRestResponse*) mapDictionaryToResponse:(NSDictionary*)dictionary {
    DFSPRestResponse* result = nil;
    id<DFSPModel> model = [self contentForType:dictionary[@"type"] andContent:dictionary[@"content"]];
    NSError* error = [self errorForContent:dictionary[@"error"]];
    _mappingError = nil;
    if (!model) {
        _mappingError = [NSError restErrorWithCode:kTPMGRestErrorInvalidResponseObject];
    } else {
        result = [[DFSPRestResponse alloc] initWithError:error andModel:model];
    }    
    return result;
}
- (id<DFSPModel>) contentForType:(NSString*)type andContent:(NSDictionary<NSString*,NSString*>*)content {
    id<DFSPModel> result = nil;
    if ([content isKindOfClass:[NSDictionary<NSString*,NSString*> class]]) {
        NSString* className = _map[type];
        Class loadingClass = NSClassFromString(className);
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
