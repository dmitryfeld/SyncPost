//
//  DFSPAuthorization.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPAuthorization.h"

@interface DFSPAuthorization() {
@protected
    NSString* _authorizationId;
    NSString* _credentialsId;
    NSString* _token;
    NSTimeInterval _createdTime;
    NSTimeInterval _expiredTime;
    NSTimeInterval _timeToLive;
}
@end

@implementation DFSPAuthorization
@synthesize authorizationId = _authorizationId;
@synthesize credentialsId = _credentialsId;
@synthesize token = _token;
@synthesize createdTime = _createdTime;
@synthesize expiredTime = _expiredTime;
@synthesize timeToLive = _timeToLive;
- (instancetype) init {
    if (self = [super init]) {
        _authorizationId = @"";
        _credentialsId = @"";
        _token = @"";
        _createdTime = [NSDate new].timeIntervalSince1970;
        _expiredTime = 0;
        _timeToLive = 3600;
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAuthorization*)model {
    if (self = [self init]) {
        _authorizationId = [model.authorizationId copy];
        _credentialsId = [model.credentialsId copy];
        _token = [model.token copy];
        _createdTime = model.createdTime;
        _expiredTime = model.expiredTime;
        _timeToLive = model.timeToLive;
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _authorizationId = [aDecoder decodeObjectForKey:@"authorizationId"];
        _credentialsId = [aDecoder decodeObjectForKey:@"credentialsId"];
        _token = [aDecoder decodeObjectForKey:@"token"];
        _createdTime = [aDecoder decodeFloatForKey:@"createdTime"];
        _expiredTime = [aDecoder decodeFloatForKey:@"expiredTime"];
        _timeToLive = [aDecoder decodeFloatForKey:@"timeToLive"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAuthorization allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_authorizationId forKey:@"authorizationId"];
    [aCoder encodeObject:_credentialsId forKey:@"credentialsId"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeFloat:_createdTime forKey:@"createdTime"];
    [aCoder encodeFloat:_expiredTime forKey:@"expiredTime"];
    [aCoder encodeFloat:_timeToLive forKey:@"timeToLive"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPAuthorization class]]) {
        return NO;
    }
    DFSPAuthorization* obj = (DFSPAuthorization*)object;
    if (![_authorizationId isEqualToString:obj.authorizationId]) {
        return NO;
    }
    if (![_credentialsId isEqualToString:obj.credentialsId]) {
        return NO;
    }
    if (![_token isEqualToString:obj.token]) {
        return NO;
    }
    
    if (_createdTime != obj.createdTime) {
        return NO;
    }
    if (_expiredTime != obj.expiredTime) {
        return NO;
    }
    return _timeToLive == obj.timeToLive;
}
-(NSUInteger)hash {
    return [self.authorizationId hash] ^ [self.token hash];
}
- (DFSPMutableAuthorization*) mutableCopy {
    return [[DFSPMutableAuthorization alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableAuthorization
@dynamic authorizationId;
@dynamic credentialsId;
@dynamic token;
@dynamic createdTime;
@dynamic expiredTime;
@dynamic timeToLive;
- (void) setAuthorizationId:(NSString *)authorizationId {
    _authorizationId = [authorizationId copy];
}
- (void) setCredentialsId:(NSString *)credentialsId {
    _credentialsId = credentialsId;
}
- (void) setToken:(NSString *)token {
    _token = [token copy];
}
- (void) setCreatedTime:(NSTimeInterval)createdTime {
    _createdTime = createdTime;
}
- (void) setExpiredTime:(NSTimeInterval)removedTime {
    _expiredTime = removedTime;
}
- (void) setTimeToLive:(NSTimeInterval)timeToLive {
    _timeToLive = timeToLive;
}
- (DFSPAuthorization*) immutableCopy {
    return [[DFSPAuthorization alloc] initWithTemplate:self];
}
@end

@implementation DFSPAuthorizationKVP
@synthesize error = _error;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"createdTime"]) {
        NSString* ctT = [value description];
        _createdTime = ctT.floatValue;
    } else if ([key isEqualToString:@"expiredTime"]) {
        NSString* ctT = [value description];
        _expiredTime = ctT.floatValue;
    } else if ([key isEqualToString:@"timeToLive"]) {
        NSString* ctT = [value description];
        _timeToLive = ctT.floatValue;
    } else {
        [super setValue:value forKey:key];
    }
}
+ (DFSPAuthorization*) fromDictionary:(NSDictionary*)dictionary {
    DFSPAuthorizationKVP* result = [DFSPAuthorizationKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
