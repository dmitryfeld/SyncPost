//
//  DFSPAuthorizationPoint.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPAuthorizationPoint.h"

@interface DFSPAuthorizationPoint() {
@protected
    DFSPCredentials* _credentials;
    NSURL* _accessURL;
}
@end

@implementation DFSPAuthorizationPoint
@synthesize credentials = _credentials;
@synthesize accessURL = _accessURL;
- (instancetype) init {
    if (self = [super init]) {
        _credentials = [DFSPCredentials new];
        _accessURL = nil;
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAuthorizationPoint*)model {
    if (self = [self init]) {
        _credentials = [model.credentials copy];
        _accessURL = [model.accessURL copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _credentials = [aDecoder decodeObjectForKey:@"credentials"];
        _accessURL = [aDecoder decodeObjectForKey:@"accessURL"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAuthorizationPoint allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_credentials forKey:@"credentials"];
    [aCoder encodeObject:_accessURL forKey:@"accessURL"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPAuthorizationPoint class]]) {
        return NO;
    }
    DFSPAuthorizationPoint* obj = (DFSPAuthorizationPoint*)object;
    if (![_credentials isEqual:obj.credentials]) {
        return NO;
    }
    return [_accessURL isEqual:obj.accessURL];
}
-(NSUInteger)hash {
    return [self.credentials hash] ^ [self.accessURL hash];
}
- (DFSPMutableAuthorizationPoint*) mutableCopy {
    return [[DFSPMutableAuthorizationPoint alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableAuthorizationPoint
@dynamic credentials;
@dynamic accessURL;
- (void) setCredentials:(DFSPCredentials *)credentials {
    _credentials = [credentials copy];
}
- (void) setAccessURL:(NSURL *)accessURL {
    _accessURL = [accessURL copy];
}
- (DFSPAuthorizationPoint*) immutableCopy {
    return [[DFSPAuthorizationPoint alloc] initWithTemplate:self];
}
@end

@implementation DFSPAuthorizationPointKVP
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"credentials"]) {
        NSDictionary* dict = (NSDictionary*)value;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            DFSPCredentialsKVP* temp = [DFSPCredentialsKVP new];
            [temp setValuesForKeysWithDictionary:dict];
            _credentials = [temp immutableCopy];
        } else if ([value isKindOfClass:[DFSPCredentials class]]) {
            _credentials = [value copy];
        } else {
            NSLog(@"InvalidFormatKey:%@ Value:%@ pair",key,value);
        }
    } else if ([key isEqualToString:@"accessURL"]) {
        NSDictionary* dict = (NSDictionary*)value;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _accessURL = [NSURL new];
            [_accessURL setValuesForKeysWithDictionary:dict];
        } else if ([value isKindOfClass:[NSURL class]]) {
            _accessURL = [value copy];
        } else if ([value isKindOfClass:[NSString class]]) {
            _accessURL = [NSURL URLWithString:[value description]];
        } else {
            NSLog(@"InvalidFormatKey:%@ Value:%@ pair",key,value);
        }
    } else {
        [super setValue:value forKey:key];
    }
}
+ (DFSPAuthorizationPoint*) fromDictionary:(NSDictionary*)dictionary {
    DFSPAuthorizationPointKVP* result = [DFSPAuthorizationPointKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
