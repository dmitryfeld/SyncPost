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
    __strong NSString* _name;
    __strong NSString* _version;
    __strong NSError* _error;
    __strong id _context;
    BOOL _isSimulated;
    __strong NSArray<DFSPRequestTemplate*>* _requestTemplates;
}

@end

@implementation DFSPRequestMap
@synthesize name = _name;
@synthesize version = _version;
@synthesize error = _error;
@synthesize context = _context;
@synthesize isSimulated = _isSimulated;
@synthesize requestTemplates = _requestTemplates;
- (instancetype) init {
    if (self = [self initWithDictionary:nil]) {
        
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary {
    if (self = [super init]) {
        _name = dictionary[@"name"];
        _version = dictionary[@"version"];
        _error = nil;
        _context = [self contextForClassName:dictionary[@"context"]];
        _isSimulated = [self simulatedForValue:dictionary[@"isSimulated"]];
        _requestTemplates = [self templatesForArray:dictionary[@"requests"]];
    }
    return self;
}
- (NSURLRequest*) prepareRequestWithName:(NSString*)name {
    DFSPRequest* result = nil;
    if (_requestTemplates.count) {
        DFSPRequestTemplate* template = [self findTemplateWithName:name];
        if (template) {
            result = [template prepareRequestWithContext:_context];
            if (result.error) {
                _error = result.error;
            }
        } else {
            //error template not found
        }
    } else {
        //error empty templates list
    }
    return result.request;
}

- (id<DFSPModel>) processResponse:(NSDictionary*)response {
    DFSPResponse* result = nil;
    if (response.count) {
        NSString* name = response[@"name"];
        if (name.length) {
            DFSPRequestTemplate* template = [self findTemplateWithName:name];
            if (template) {
                result = [template processResponse:response];
                if (result.error) {
                    _error = result.error;
                }
            } else {
                //error template not found
            }
        } else {
            //error invalid response structure
        }
    } else {
        //error invalid response structure
    }
    return result.model;
}
- (NSString*) simulatedDataPathWithName:(NSString*)name {
    NSString* result = nil;
    DFSPRequestTemplate* template = [self findTemplateWithName:name];
    if (template) {
        result = template.simulatedDataPath;
    } else {
        //error template not found
    }
    return result;
}

- (id) contextForClassName:(NSString*)contextClassName {
    id result = nil;
    if ([contextClassName isKindOfClass:[NSString class]]) {
        Class loadingClass = NSClassFromString(contextClassName);
        result = [loadingClass new];
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidTemplateContext];
    }
    return result;
}
- (BOOL) simulatedForValue:(NSString*)value {
    BOOL result = NO;
    NSString* description = value.description;
    if (description.length) {
        result = description.boolValue;
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
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidTemplateList];
    }
    return result;
}
- (DFSPRequestTemplate*) findTemplateWithName:(NSString*)name {
    DFSPRequestTemplate* result = nil;
    for (DFSPRequestTemplate* template in _requestTemplates) {
        if ([template.name isEqualToString:name]) {
            result = template;
            break;
        }
    }
    return result;
}
@end
