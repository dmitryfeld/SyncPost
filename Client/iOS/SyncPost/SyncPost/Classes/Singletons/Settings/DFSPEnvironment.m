//
//  DFSPEnvironment.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPEnvironment.h"

@interface DFSPEnvironment() {
@private
    NSURL* _accessURL;
    NSString* _name;
    BOOL _isSimulated;
}

@end

@implementation DFSPEnvironment
@synthesize accessURL = _accessURL;
@synthesize name = _name;
- (instancetype) init {
    if (self = [self initWithDictionary:nil]) {
        _name = nil;
        _accessURL = nil;
        _isSimulated = NO;
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        NSString* urlString = dictionary[@"accessURL"];
        NSString* isSimulatedString = dictionary[@"simulated"];
        _name = dictionary[@"name"];
        _accessURL = [NSURL URLWithString:urlString];
        _isSimulated = isSimulatedString.boolValue;
    }
    return self;
}
- (BOOL) isEqual:(id)object {
    BOOL result = YES;
    
    if (![object isKindOfClass:[DFSPEnvironment class]]) {
        result = NO;
    } else {
        DFSPEnvironment* obj = (DFSPEnvironment*)object;
        if (![_name isEqualToString:obj.name]) {
            result = NO;
        } else if (![_accessURL isEqual:obj.accessURL]) {
            result = NO;
        } else {
            result = (_isSimulated == obj.isSimulated);
        }
    }
    return result;
}
+ (NSMutableArray<DFSPEnvironment*>*) listWithArrayOfDictionaries:(NSArray<NSDictionary<NSString*,NSString*>*>*)array {
    NSMutableArray<DFSPEnvironment*>* result = [NSMutableArray<DFSPEnvironment*> new];
    if ([array isKindOfClass:[NSArray class]]) {
        DFSPEnvironment* temp = nil;
        for (NSDictionary* dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                temp = [[DFSPEnvironment alloc] initWithDictionary:dict];
                [result addObject:temp];
            }
        }
    }
    return result;
}
@end
