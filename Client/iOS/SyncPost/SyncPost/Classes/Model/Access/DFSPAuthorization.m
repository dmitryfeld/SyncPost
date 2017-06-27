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
    NSString* _userID;
    NSString* _authorizationToken;
    NSTimeInterval _timeToLive;
}
@end

@implementation DFSPAuthorization
@synthesize userID = _userID;
@synthesize authorizationToken = _authorizationToken;
@synthesize timeToLive = _timeToLive;
- (instancetype) init {
    if (self = [super init]) {
        _userID = @"";
        _authorizationToken = @"";
        _timeToLive = 3600.;
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAuthorization*)model {
    if (self = [self init]) {
        _userID = [model.userID copy];
        _authorizationToken = [model.authorizationToken copy];
        _timeToLive = model.timeToLive;
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _userID = [aDecoder decodeObjectForKey:@"memberID"];
        _authorizationToken = [aDecoder decodeObjectForKey:@"authorizationToken"];
        _timeToLive = [aDecoder decodeFloatForKey:@"timeToLive"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAuthorization allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userID forKey:@"memberID"];
    [aCoder encodeObject:_authorizationToken forKey:@"authorizationToken"];
    [aCoder encodeFloat:_timeToLive forKey:@"timeToLive"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPAuthorization class]]) {
        return NO;
    }
    DFSPAuthorization* obj = (DFSPAuthorization*)object;
    if (![_userID isEqualToString:obj.userID]) {
        return NO;
    }
    if (![_authorizationToken isEqualToString:obj.authorizationToken]) {
        
    }
    return _timeToLive == obj.timeToLive;
}
-(NSUInteger)hash {
    return [self.userID hash] ^ [self.authorizationToken hash];
}
- (DFSPMutableAuthorization*) mutableCopy {
    return [[DFSPMutableAuthorization alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableAuthorization
@dynamic userID;
@dynamic authorizationToken;
@dynamic timeToLive;
- (void) setUserID:(NSString*)userID {
    _userID = [userID copy];
}
- (void) setAuthorizationToken:(NSString *)authorizationToken {
    _authorizationToken = [authorizationToken copy];
}
- (void) setTimeToLive:(NSTimeInterval)timeToLive {
    _timeToLive = timeToLive;
}
- (DFSPAuthorization*) immutableCopy {
    return [[DFSPAuthorization alloc] initWithTemplate:self];
}
@end

@implementation DFSPAuthorizationKVP
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"timeToLive"]) {
        NSString* ttlS = [value description];
        _timeToLive = ttlS.floatValue;
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
