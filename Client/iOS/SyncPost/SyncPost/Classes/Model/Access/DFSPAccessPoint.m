//
//  DFSPAccessPoint.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPAccessPoint.h"

@interface DFSPAccessPoint() {
@protected
    DFSPCredentials* _credentials;
    DFSPAuthorization* _authorization;
    NSString* _requestString;
}
@end

@implementation DFSPAccessPoint
@synthesize credentials = _credentials;
@synthesize authorization = _authorization;
@synthesize requestString = _requestString;
- (instancetype) init {
    if (self = [super init]) {
        _credentials = [DFSPCredentials new];
        _authorization = [DFSPAuthorization new];
        _requestString = nil;
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAccessPoint*)model {
    if (self = [self init]) {
        _credentials = [model.credentials copy];
        _authorization = [model.authorization copy];
        _requestString = [model.requestString copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _credentials = [aDecoder decodeObjectForKey:@"credentials"];
        _authorization = [aDecoder decodeObjectForKey:@"authorization"];
        _requestString = [aDecoder decodeObjectForKey:@"requestString"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAccessPoint allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_credentials forKey:@"credentials"];
    [aCoder encodeObject:_authorization forKey:@"authorization"];
    [aCoder encodeObject:_requestString forKey:@"requestString"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPAccessPoint class]]) {
        return NO;
    }
    DFSPAccessPoint* obj = (DFSPAccessPoint*)object;
    if (![_credentials isEqual:obj.credentials]) {
        return NO;
    }
    if (![_authorization isEqual:obj.authorization]) {
        return NO;
    }
    return [_requestString isEqual:obj.requestString];
}
-(NSUInteger)hash {
    return [self.credentials hash] ^ [self.authorization hash] ^ [self.requestString hash];
}
- (DFSPMutableAccessPoint*) mutableCopy {
    return [[DFSPMutableAccessPoint alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableAccessPoint
@dynamic credentials;
@dynamic authorization;
@dynamic requestString;
- (void) setCredentials:(DFSPCredentials *)credentials {
    _credentials = [credentials copy];
}
- (void) setAuthorization:(DFSPAuthorization *)authorization {
    _authorization = [authorization copy];
}
- (void) setRequestString:(NSString *)requestString {
    _requestString = [requestString copy];
}
- (DFSPAccessPoint*) immutableCopy {
    return [[DFSPAccessPoint alloc] initWithTemplate:self];
}
@end

@implementation DFSPAccessPointKVP
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
    } else if ([key isEqualToString:@"authorization"]) {
        NSDictionary* dict = (NSDictionary*)value;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            DFSPAuthorizationKVP* temp = [DFSPAuthorizationKVP new];
            [temp setValuesForKeysWithDictionary:dict];
            _authorization = [temp immutableCopy];
        } else if ([value isKindOfClass:[DFSPAuthorization class]]) {
            _authorization = [value copy];
        } else {
            NSLog(@"InvalidFormatKey:%@ Value:%@ pair",key,value);
        }
    } else if ([key isEqualToString:@"accessURL"]) {
        if ([value isKindOfClass:[NSString class]]) {
            _requestString = value;
        } else {
            NSLog(@"InvalidFormatKey:%@ Value:%@ pair",key,value);
        }
    } else {
        [super setValue:value forKey:key];
    }
}
+ (DFSPAccessPoint*) fromDictionary:(NSDictionary*)dictionary {
    DFSPAccessPointKVP* result = [DFSPAccessPointKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
