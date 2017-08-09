//
//  DFSPSubscriber.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSubscriber.h"

@interface DFSPSubscriber() {
@protected
    NSString* _memberName;
    NSString* _deviceID;
    NSString* _pushToken;
}
@end

@implementation DFSPSubscriber
@synthesize memberName = _memberName;
@synthesize deviceID = _deviceID;
@synthesize pushToken = _pushToken;
- (instancetype) init {
    if (self = [super init]) {
        _memberName = @"";
        _deviceID = @"";
        _pushToken = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPSubscriber*)model {
    if (self = [self init]) {
        _memberName = [model.memberName copy];
        _deviceID = [model.deviceID copy];
        _pushToken = [model.pushToken copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _memberName = [aDecoder decodeObjectForKey:@"memberName"];
        _deviceID = [aDecoder decodeObjectForKey:@"deviceID"];
        _pushToken = [aDecoder decodeObjectForKey:@"pushToken"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPSubscriber allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_memberName forKey:@"memberName"];
    [aCoder encodeObject:_deviceID forKey:@"deviceID"];
    [aCoder encodeObject:_pushToken forKey:@"pushToken"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPSubscriber class]]) {
        return NO;
    }
    DFSPSubscriber* obj = (DFSPSubscriber*)object;
    if (![_memberName isEqualToString:obj.memberName]) {
        return NO;
    }
    if (![_deviceID isEqualToString:obj.deviceID]) {
        return NO;
    }
    return [_pushToken isEqualToString:obj.pushToken];
}
-(NSUInteger)hash {
    return [self.memberName hash] ^ [self.deviceID  hash] ^ [self.pushToken hash];
}
- (DFSPMutableSubscriber*) mutableCopy {
    return [[DFSPMutableSubscriber alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableSubscriber
@dynamic memberName;
@dynamic deviceID;
@dynamic pushToken;
- (void) setMemberName:(NSString*)memberID {
    _memberName = [memberID copy];
}
- (void) setDeviceID:(NSString*)deviceID {
    _deviceID = [deviceID copy];
}
- (void) setPushToken:(NSString*)pushToken {
    _pushToken = [pushToken copy];
}
- (DFSPSubscriber*) immutableCopy {
    return [[DFSPSubscriber alloc] initWithTemplate:self];
}
@end

@implementation DFSPSubscriberKVP
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
+ (DFSPSubscriber*) fromDictionary:(NSDictionary*)dictionary {
    DFSPSubscriberKVP* result = [DFSPSubscriberKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
