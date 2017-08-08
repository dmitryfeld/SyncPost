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
    NSTimeInterval _createdTime;
    NSTimeInterval _removedTime;
    NSDate* _received;
}
@end

@implementation DFSPAuthorization
@synthesize userID = _userID;
@synthesize authorizationToken = _authorizationToken;
@synthesize createdTime = _createdTime;
@synthesize removedTime = _removedTime;
@synthesize received = _received;
- (instancetype) init {
    if (self = [super init]) {
        _userID = @"";
        _authorizationToken = @"";
        _createdTime = [NSDate new].timeIntervalSince1970;
        _removedTime = [NSDate new].timeIntervalSince1970;
        _received = [NSDate new];
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAuthorization*)model {
    if (self = [self init]) {
        _userID = [model.userID copy];
        _authorizationToken = [model.authorizationToken copy];
        _createdTime = model.createdTime;
        _removedTime = model.removedTime;
        _received = [model.received copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _userID = [aDecoder decodeObjectForKey:@"memberID"];
        _authorizationToken = [aDecoder decodeObjectForKey:@"authorizationToken"];
        _createdTime = [aDecoder decodeFloatForKey:@"createdTime"];
        _removedTime = [aDecoder decodeFloatForKey:@"removedTime"];
        _received = [aDecoder decodeObjectForKey:@"received"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAuthorization allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userID forKey:@"memberID"];
    [aCoder encodeObject:_authorizationToken forKey:@"authorizationToken"];
    [aCoder encodeFloat:_createdTime forKey:@"createdTime"];
    [aCoder encodeFloat:_removedTime forKey:@"removedTime"];
    [aCoder encodeObject:_received forKey:@"received"];
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
        return NO;
    }
    if (![_received isEqual:obj.received]) {
        return NO;
    }
    if (_createdTime != obj.createdTime) {
        return NO;
    }
    return _removedTime == obj.removedTime;
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
@dynamic createdTime;
@dynamic removedTime;
@dynamic received;
- (void) setUserID:(NSString*)userID {
    _userID = [userID copy];
}
- (void) setAuthorizationToken:(NSString *)authorizationToken {
    _authorizationToken = [authorizationToken copy];
}
- (void) setCreatedTime:(NSTimeInterval)createdTime {
    _createdTime = createdTime;
}
- (void) setRemovedTime:(NSTimeInterval)removedTime {
    _removedTime = removedTime;
}
- (void) setReceived:(NSDate *)received {
    _received = received;
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
    } else if ([key isEqualToString:@"removedTime"]) {
        NSString* ctT = [value description];
        _removedTime = ctT.floatValue;
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
