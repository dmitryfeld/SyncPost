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
        [NSException raise:@"DFSPRequestMap Init" format:@"Invalid Arguments"];
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary {
    if (self = [self initWithDictionary:dictionary underlyingError:nil]) {
        _name = dictionary[@"name"];
        _version = dictionary[@"version"];
        _error = [self checkParameters];
        _context = [self contextForClassName:dictionary[@"context"]];
        _isSimulated = [self simulatedForValue:dictionary[@"isSimulated"]];
        _requestTemplates = [self templatesForArray:dictionary[@"requests"]];
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary underlyingError:(NSError*)error {
    if (self = [super init]) {
        _name = dictionary[@"name"];
        _version = dictionary[@"version"];
        _error = [self checkParameters];
        _context = [self contextForClassName:dictionary[@"context"]];
        _isSimulated = [self simulatedForValue:dictionary[@"isSimulated"]];
        _requestTemplates = [self templatesForArray:dictionary[@"requests"]];
        if (error) {
            _error = error;
        }
    }
    return self;
}
- (NSURLRequest*) prepareRequestWithName:(NSString*)name {
    NSURLRequest* result = nil;
    if (_requestTemplates.count) {
        DFSPRequestTemplate* template = [self findTemplateWithName:name];
        if (template) {
            result = [template prepareRequestWithContext:_context];
            if (template.error) {
                _error = template.error;
            }
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorRequestMapCanNotFindTemplate andComment:[NSString stringWithFormat:@" request: %@",name]];
        }
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent andComment:@"Empty Templates List"];
    }
    return result;
}

- (id<DFSPModel>) processResponse:(NSDictionary*)response {
    id<DFSPModel> result = nil;
    if (response.count) {
        NSString* name = response[@"name"];
        if (name.length) {
            DFSPRequestTemplate* template = [self findTemplateWithName:name];
            if (template) {
                result = [template processResponse:response];
                if (template.error) {
                    _error = template.error;
                }
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorRequestMapCanNotFindTemplate andComment:[NSString stringWithFormat:@" response: %@",name]];
            }
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorRequestInvalidResponse andComment:@"Undefined Response Type"];
        }
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorRequestInvalidResponse andComment:@"Empty Templates Response Data"];
    }
    return result;
}
- (NSString*) simulatedDataPathWithName:(NSString*)name {
    NSString* result = nil;
    DFSPRequestTemplate* template = [self findTemplateWithName:name];
    if (template) {
        result = template.simulatedDataPath;
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorRequestMapCanNotFindTemplate andComment:[NSString stringWithFormat:@" name:%@",name]];
    }
    return result;
}

- (id) contextForClassName:(NSString*)contextClassName {
    id result = nil;
    if ([contextClassName isKindOfClass:[NSString class]]) {
        Class loadingClass = NSClassFromString(contextClassName);
        if (loadingClass) {
            result = [loadingClass new];
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent andComment:[NSString stringWithFormat:@"Can not load Map Context Class(%@)",contextClassName]];
        }
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent andComment:@"Invalid Map Context Class Name"];
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
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent andComment:@"Invalid Template"];
            }
        }
        result = [NSArray<DFSPRequestTemplate*> arrayWithArray:tempA];
    } else {
        _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent andComment:@"Invalid Templates List"];
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
- (NSError*) checkParameters {
    NSError* result = nil;
    if (!_name.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapParameter andComment:@"name"];
    } else if (!_version.length) {
        result = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapParameter andComment:@"version"];
    }
    return result;
}
@end
