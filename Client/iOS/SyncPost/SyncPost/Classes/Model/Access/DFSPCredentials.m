//
//  DFSPCredentials.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPCredentials.h"

@interface DFSPCredentials() {
@protected
    NSString* _memberName;
    NSString* _password;
}
@end

@implementation DFSPCredentials
@synthesize memberName = _memberName;
@synthesize password = _password;
- (instancetype) init {
    if (self = [super init]) {
        _memberName = @"";
        _password = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPCredentials*)model {
    if (self = [self init]) {
        _memberName = [model.memberName copy];
        _password = [model.password copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _memberName = [aDecoder decodeObjectForKey:@"memberName"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPCredentials allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_memberName forKey:@"memberName"];
    [aCoder encodeObject:_password forKey:@"password"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPCredentials class]]) {
        return NO;
    }
    DFSPCredentials* obj = (DFSPCredentials*)object;
    if (![_memberName isEqualToString:obj.memberName]) {
        return NO;
    }
    return [_password isEqualToString:obj.password];
}
-(NSUInteger)hash {
    return [self.memberName hash] ^ [self.password hash];
}
- (DFSPMutableCredentials*) mutableCopy {
    return [[DFSPMutableCredentials alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableCredentials
@dynamic memberName;
@dynamic password;
- (void) setUserName:(NSString *)memberName {
    _memberName = [memberName copy];
}
- (void) setPassword:(NSString *)password {
    _password = [password copy];
}
- (DFSPCredentials*) immutableCopy {
    return [[DFSPCredentials alloc] initWithTemplate:self];
}
@end

@implementation DFSPCredentialsKVP
@synthesize error = _error;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefinedKey:%@ Value:%@ pair",key,value);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
+ (DFSPCredentials*) fromDictionary:(NSDictionary*)dictionary {
    DFSPCredentialsKVP* result = [DFSPCredentialsKVP new];
    [result setValuesForKeysWithDictionary:dictionary];
    return [result immutableCopy];
}
@end
