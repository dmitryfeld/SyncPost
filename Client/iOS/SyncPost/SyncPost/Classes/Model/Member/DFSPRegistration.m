//
//  DFSPRegistration.m
//  SyncPost
//
//  Created by Dmitry Feld on 8/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRegistration.h"



@interface DFSPRegistration() {
@protected
    NSString* _registrationId;
    NSString* _memberId;
    NSString* _pushNotificationId;
}
@end

@implementation DFSPRegistration
@synthesize registrationId = _registrationId;
@synthesize memberId = _memberId;
@synthesize pushNotificationId = _pushNotificationId;
- (instancetype) init {
    if (self = [super init]) {
        _registrationId = @"";
        _memberId = @"";
        _pushNotificationId = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPRegistration*)model {
    if (self = [self init]) {
        _registrationId = [model.registrationId copy];
        _memberId = [model.memberId copy];
        _pushNotificationId = [model.pushNotificationId copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _registrationId = [aDecoder decodeObjectForKey:@"registrationId"];
        _memberId = [aDecoder decodeObjectForKey:@"memberId"];
        _pushNotificationId = [aDecoder decodeObjectForKey:@"pushNotificationId"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPRegistration allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_registrationId forKey:@"registrationId"];
    [aCoder encodeObject:_memberId forKey:@"memberId"];
    [aCoder encodeObject:_pushNotificationId forKey:@"pushNotificationId"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPRegistration class]]) {
        return NO;
    }
    DFSPRegistration* obj = (DFSPRegistration*)object;
    if (![_registrationId isEqualToString:obj.registrationId]) {
        return NO;
    }
    if (![_memberId isEqualToString:obj.memberId]) {
        return NO;
    }
    return [_pushNotificationId isEqualToString:obj.pushNotificationId];
}
-(NSUInteger)hash {
    return [self.memberId hash] ^ [self.registrationId hash] ^ [self.pushNotificationId hash];
}
- (DFSPMutableRegistration*) mutableCopy {
    return [[DFSPMutableRegistration alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableRegistration
@dynamic registrationId;
@dynamic memberId;
@dynamic pushNotificationId;
- (void) setRegistryId:(NSString *)registrationId {
    _registrationId = [registrationId copy];
}
- (void) setMemberId:(NSString *)memberId {
    _memberId = [memberId copy];
}
- (void) setPushNotificationId:(NSString *)pushNotificationId {
    _pushNotificationId = [pushNotificationId copy];
}

- (DFSPRegistration*) immutableCopy {
    return [[DFSPRegistration alloc] initWithTemplate:self];
}
@end

@implementation DFSPRegistrationKVP
@synthesize error = _error;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
+ (DFSPRegistration*) fromDictionary:(NSDictionary*)dictionary {
    DFSPRegistrationKVP* result = [DFSPRegistrationKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
