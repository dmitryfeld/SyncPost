//
//  DFSPMember.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPMember.h"

@interface DFSPMember() {
@protected
    NSString* _memberID;
    NSString* _deviceID;
    NSString* _pushToken;
}
@end

@implementation DFSPMember
@synthesize memberID = _memberID;
@synthesize deviceID = _deviceID;
@synthesize pushToken = _pushToken;
- (instancetype) init {
    if (self = [super init]) {
        _memberID = @"";
        _deviceID = @"";
        _pushToken = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPMember*)model {
    if (self = [self init]) {
        _memberID = [model.memberID copy];
        _deviceID = [model.deviceID copy];
        _pushToken = [model.pushToken copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _memberID = [aDecoder decodeObjectForKey:@"memberID"];
        _deviceID = [aDecoder decodeObjectForKey:@"deviceID"];
        _pushToken = [aDecoder decodeObjectForKey:@"pushToken"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPMember allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_memberID forKey:@"memberID"];
    [aCoder encodeObject:_deviceID forKey:@"deviceID"];
    [aCoder encodeObject:_pushToken forKey:@"pushToken"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPMember class]]) {
        return NO;
    }
    DFSPMember* obj = (DFSPMember*)object;
    if (![_memberID isEqualToString:obj.memberID]) {
        return NO;
    }
    if (![_deviceID isEqualToString:obj.deviceID]) {
        return NO;
    }
    return [_pushToken isEqualToString:obj.pushToken];
}
-(NSUInteger)hash {
    return [self.memberID hash] ^ [self.deviceID  hash] ^ [self.pushToken hash];
}
- (DFSPMutableMember*) mutableCopy {
    return [[DFSPMutableMember alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableMember
@dynamic memberID;
@dynamic deviceID;
@dynamic pushToken;
- (void) setMemberID:(NSString*)memberID {
    _memberID = [memberID copy];
}
- (void) setDeviceID:(NSString*)deviceID {
    _deviceID = [deviceID copy];
}
- (void) setPushToken:(NSString*)pushToken {
    _pushToken = [pushToken copy];
}
- (DFSPMember*) immutableCopy {
    return [[DFSPMember alloc] initWithTemplate:self];
}
@end

@implementation DFSPMemberKVP
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
+ (DFSPMember*) fromDictionary:(NSDictionary*)dictionary {
    DFSPMemberKVP* result = [DFSPMemberKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
