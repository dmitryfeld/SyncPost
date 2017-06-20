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
}
@end

@implementation DFSPAuthorization
@synthesize userID = _userID;
@synthesize authorizationToken = _authorizationToken;
- (instancetype) init {
    if (self = [super init]) {
        _userID = @"";
        _authorizationToken = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPAuthorization*)model {
    if (self = [self init]) {
        _userID = [model.userID copy];
        _authorizationToken = [model.authorizationToken copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _userID = [aDecoder decodeObjectForKey:@"memberID"];
        _authorizationToken = [aDecoder decodeObjectForKey:@"authorizationToken"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPAuthorization allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userID forKey:@"memberID"];
    [aCoder encodeObject:_authorizationToken forKey:@"authorizationToken"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPAuthorization class]]) {
        return NO;
    }
    DFSPAuthorization* obj = (DFSPAuthorization*)object;
    if (![_userID isEqualToString:obj.userID]) {
        return NO;
    }
    return [_authorizationToken isEqualToString:obj.authorizationToken];
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
- (void) setUserID:(NSString*)userID {
    _userID = [userID copy];
}
- (void) setAuthorizationToken:(NSString *)authorizationToken {
    _authorizationToken = [authorizationToken copy];
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
    [super setValue:value forKey:key];
}
+ (DFSPAuthorization*) fromDictionary:(NSDictionary*)dictionary {
    DFSPAuthorizationKVP* result = [DFSPAuthorizationKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
