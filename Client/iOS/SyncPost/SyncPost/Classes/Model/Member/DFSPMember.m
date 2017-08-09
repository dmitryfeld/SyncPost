//
//  DFSPMember.m
//  SyncPost
//
//  Created by Dmitry Feld on 8/8/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPMember.h"

@interface DFSPMember() {
@protected
    NSString* _memberName;
    NSString* _firstName;
    NSString* _lastName;
    NSString* _displayName;
    NSString* _comment;
}
@end

@implementation DFSPMember
@synthesize memberName = _memberName;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize displayName = _displayName;
@synthesize comment = _comment;
- (instancetype) init {
    if (self = [super init]) {
        _memberName = @"";
        _firstName = @"";
        _lastName = @"";
        _displayName = @"";
        _comment = @"";
    }
    return self;
}
- (instancetype) initWithTemplate:(DFSPMember*)model {
    if (self = [self init]) {
        _memberName = [model.memberName copy];
        _firstName = [model.firstName copy];
        _lastName = [model.lastName copy];
        _displayName = [model.displayName copy];
        _comment = [model.comment copy];
    }
    return self;
    
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        _memberName = [aDecoder decodeObjectForKey:@"memberName"];
        _firstName = [aDecoder decodeObjectForKey:@"firstName"];
        _lastName = [aDecoder decodeObjectForKey:@"lastName"];
        _displayName = [aDecoder decodeObjectForKey:@"displayName"];
        _comment = [aDecoder decodeObjectForKey:@"comment"];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFSPMember allocWithZone:zone] initWithTemplate:self];
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_memberName forKey:@"memberName"];
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    [aCoder encodeObject:_displayName forKey:@"displayName"];
    [aCoder encodeObject:_comment forKey:@"comment"];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFSPMember class]]) {
        return NO;
    }
    DFSPMember* obj = (DFSPMember*)object;
    if (![_memberName isEqualToString:obj.memberName]) {
        return NO;
    }
    if (![_firstName isEqualToString:obj.firstName]) {
        return NO;
    }
    if (![_lastName isEqualToString:obj.lastName]) {
        return NO;
    }
    if (![_displayName isEqualToString:obj.displayName]) {
        return NO;
    }
    return [_comment isEqualToString:obj.comment];
}
-(NSUInteger)hash {
    return [self.memberName hash] ^ [self.firstName  hash] ^ [self.lastName hash] ^ [self.displayName hash] ^ [self.comment hash];
}
- (DFSPMutableMember*) mutableCopy {
    return [[DFSPMutableMember alloc] initWithTemplate:self];
}
@end

@implementation DFSPMutableMember
@dynamic memberName;
@dynamic firstName;
@dynamic lastName;
@dynamic displayName;
@dynamic comment;
- (void) setMemberName:(NSString*)memberID {
    _memberName = [memberID copy];
}
- (void) setFirstName:(NSString *)firstName {
    _firstName = [firstName copy];
}
- (void) setLastName:(NSString *)lastName {
    _lastName = [lastName copy];
}
- (void) setDisplayName:(NSString *)displayName {
    _displayName = [displayName copy];
}
- (void) setComment:(NSString *)comment {
    _comment = [comment copy];
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
