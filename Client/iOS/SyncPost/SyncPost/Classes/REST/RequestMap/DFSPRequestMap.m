//
//  DFSPRequestMap.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestMap.h"
#import "NSError+Rest.h"

@interface DFSPRequestMap() {
@private
    __strong NSError* _error;
    __strong id _context;
    __strong NSArray<DFSPRequestTemplate*>* _requestTemplates;
}

@end

@implementation DFSPRequestMap
@synthesize error = _error;
@synthesize context = _context;
@synthesize requestTemplates = _requestTemplates;
- (instancetype) init {
    if (self = [self initWithDictionary:nil]) {
        
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary {
    if (self = [super init]) {
        _error = nil;
        _context = [self contextForClassName:dictionary[@"context"]];
        _requestTemplates = [self templatesForArray:dictionary[@"requests"]];
    }
    return self;
}
- (NSURLRequest*) prepareRequestWithName:(NSString*)name {
    NSURLRequest* result = nil;
    if (_requestTemplates.count) {
        for (DFSPRequestTemplate* template in _requestTemplates) {
            if ([template.name isEqualToString:name]) {
                NSError* error;
                result = [template prepareRequestWithContext:_context withError:&error];
                if (error) {
                    _error = error;
                }
                break;
            }
        }
    }
    return result;
}
- (id<DFSPModel>) processResponse:(NSDictionary*)response{
    return nil;
}
+ (DFSPRequestMap*) requestMapWithContentOfURL:(NSURL*)url {
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:url];
    DFSPRequestMap* result = nil;
    if (dict) {
        return [[DFSPRequestMap alloc] initWithDictionary:dict];
    }
    return result;
}
+ (DFSPRequestMap*) requestMapWithContentOfMainBundleFile:(NSString*)fileName {
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
    DFSPRequestMap* result = nil;
    if (dict) {
        return [[DFSPRequestMap alloc] initWithDictionary:dict];
    }
    return result;}

- (id) contextForClassName:(NSString*)contextClassName {
    id result = nil;
    if ([contextClassName isKindOfClass:[NSString class]]) {
        Class loadingClass = NSClassFromString(contextClassName);
        result = [loadingClass new];
    } else {
        _error = [NSError restErrorWithCode:kTPMGRestErrorInvalidTemplateContext];
    }
    return result;
}
- (NSArray<DFSPRequestTemplate*>*) templatesForArray:(NSArray<NSDictionary*>*)array {
    NSArray<DFSPRequestTemplate*>* result = nil;
    if ([array isKindOfClass:[NSArray<NSDictionary<NSString*,id>*> class]]) {
        NSMutableArray<DFSPRequestTemplate*>* tempA = [NSMutableArray<DFSPRequestTemplate*> new];
        DFSPRequestTemplate* temp = nil;
        for (NSDictionary<NSString*,id>* dict in array) {
            if ([dict isKindOfClass:[NSDictionary<NSString*,id> class]]) {
                temp = [[DFSPRequestTemplate alloc] initWithDisctionary:dict];
                [tempA addObject:temp];
            }
        }
        result = [NSArray<DFSPRequestTemplate*> arrayWithArray:tempA];
    } else {
        _error = [NSError restErrorWithCode:kTPMGRestErrorInvalidTemplateList];
    }
    return result;
}
@end
