//
//  DFSPRestAPI.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestAPI.h"
#import "DFSPSettings.h"
#import "NSError+Rest.h"

@interface DFSPRestAPI() {
@private
    __strong DFSPRestRequest* _request;
    __strong DFSPRestResponse* _response;
    __strong DFSPRestMapper* _mapper;
    __strong void (^_completionHandler)(NSError*,DFSPRestResponse*);
    __strong NSError* _systemError;
    BOOL _isInProcess;
}
@property (strong,readonly,nonatomic) DFSPRestMapper* mapper;
@end

@implementation DFSPRestAPI
@synthesize isInProcess = _isInProcess;
@synthesize response = _response;
@synthesize systemError = _systemError;
@synthesize mapper = _mapper;
- (instancetype) init {
    if (self = [self initWithMapper:nil]) {
        _mapper = nil;
    }
    return self;
}
- (instancetype) initWithMapper:(DFSPRestMapper*)mapper {
    if (self = [super init]) {
        _mapper = mapper;
    }
    return self;
}
- (void) startWithRequest:(DFSPRestRequest*)request andCompletionHandler:(void(^)(NSError*,DFSPRestResponse*))handler {
    if (!_isInProcess) {
        if (request) {
            _request = request;
            _completionHandler = handler;
            _response = nil;
            _systemError = nil;
            if (DFSPSettingsGet().environment.isSimulated) {
                [self processSimulated];
            } else {
                [self startAPICall];
            }
        } else {
            
        }
    }
}

- (void) processSimulated {
    NSString *path = [[NSBundle mainBundle] pathForResource:_request.simulatedFileName ofType:@"json"];
    if (path) {
        NSData *_data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
        if (_data.length) {
            NSError* error = nil;
            NSDictionary* _jsonDictionary = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            if (error) {
                _systemError = error;
            } else if (!_jsonDictionary) {
                _systemError = [NSError restErrorWithCode:kTPMGRestErrorFailureToParseJSONError];
            } else {
                _response = [self.mapper mapDictionaryToResponse:_jsonDictionary];
            }
        } else {
            _systemError = [NSError restErrorWithCode:kTPMGRestErrorCodeNoData];
        }
        [self processHandleWithSystemError:_systemError andResponse:_response];
    }
}

- (void) startAPICall {
    
}
- (void) processHandleWithSystemError:(NSError*)systemError andResponse:(DFSPRestResponse*)response {
    if ([NSThread isMainThread]) {
        _completionHandler(systemError,response);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionHandler(systemError,response);
        });
    }
}
@end
