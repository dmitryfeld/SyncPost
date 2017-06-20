//
//  DFSPSingleton.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSingleton.h"

@interface DFSPSingleton() {
@private
    NSMutableDictionary<id,id>* _content;
    NSLock* _lock;
}
@property (readonly,nonatomic) NSMutableDictionary<id,id>* content;
@property (readonly,nonatomic) NSLock* lock;
+ (DFSPSingleton*) sharedInstance;
@end

@implementation DFSPSingleton
static DFSPSingleton  *__kDFSPSingletonSharedInstance = nil;

@synthesize content = _content;
@synthesize lock = _lock;
+ (DFSPSingleton*) sharedInstance {
    @synchronized(self) {
        if (nil == __kDFSPSingletonSharedInstance) {
            __kDFSPSingletonSharedInstance = [[DFSPSingleton alloc] init];
        }
    }
    return __kDFSPSingletonSharedInstance;
}

+ (id) allocWithZone:(NSZone*)_zone {
    @synchronized(self) {
        NSAssert(__kDFSPSingletonSharedInstance == nil,@"Attempted to allocate a second instance of a DFSPSingleton.");
        __kDFSPSingletonSharedInstance = [super allocWithZone:_zone];
    }
    return __kDFSPSingletonSharedInstance;
}

- (id) copyWithZone:(NSZone*)zone {
    return self;
}


- (__null_unspecified instancetype) init {
    if( nil != (self = [super init]) ) {
        _content = [NSMutableDictionary new];
        _lock = [NSLock new];
    }
    return self;
}

- (void) dealloc {
}

+ (id<DFSPTagged>) objectForTag: (__nonnull id)tag {
    id<DFSPTagged> result = nil;
    DFSPSingleton* singleton = [DFSPSingleton sharedInstance];
    if( nil != singleton ) {
        NSMutableDictionary* cnt = singleton.content;
        result = cnt[tag];
    }
    return result;
}
+ (void) addObject: (id<DFSPTagged>)inst {
    DFSPSingleton* singleton = [DFSPSingleton sharedInstance];
    id tag = [inst tag];
    if( (nil != singleton) && (nil != tag) ) {
        NSMutableDictionary *cnt = singleton.content;
        if( nil == cnt[inst] ) {
            [singleton.lock lock];
            cnt[tag] = inst;
            [singleton.lock unlock];
        }
    }
}
+ (void) removeObject: (id<DFSPTagged>)inst {
    DFSPSingleton* singleton = [DFSPSingleton sharedInstance];
    id tag = [inst tag];
    if( (nil != singleton) && (nil != tag) ) {
        NSMutableDictionary *cnt = singleton.content;
        [singleton.lock lock];
        [cnt removeObjectForKey:tag];
        [singleton.lock unlock];
    }    
}
@end
