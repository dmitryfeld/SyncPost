//
//  DFSPAuthorizationService.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/27/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPAuthorizationService.h"
#import "DFSPSignOnController.h"
#import "DFSPApplicationData.h"
#import "DFSPSpinnerController.h"
#import "DFSPRESTService.h"
#import "DFSPErrorController.h"
#import "NSError+Rest.h"


@interface DFSPAuthorizationService() {
@protected
    __strong UIViewController* _controller;
    __strong DFSPSignOnController* _signOnController;
    __strong DFSPSpinnerController* _spinnerController;
    __strong DFSPRESTService* _restService;
    __strong DFSPErrorController* _errorController;
    __strong NSError* _invalidModelError;
}
@property (readonly,nonatomic,strong) DFSPSignOnController* signOnController;
@property (readonly,nonatomic,strong) DFSPSpinnerController* spinnerController;
@property (readonly,nonatomic,strong) DFSPRESTService* restService;
@property (readonly,nonatomic,strong) DFSPErrorController* errorController;
@property (readonly,nonatomic,strong) NSError* invalidModelError;
@end

@implementation DFSPAuthorizationService
@synthesize signOnController = _signOnController;
@synthesize spinnerController = _spinnerController;
@synthesize restService = _restService;
@synthesize errorController = _errorController;
@synthesize invalidModelError = _invalidModelError;
- (instancetype) init {
    if (self = [self initWithController:nil]) {
        [NSException raise:@"DFSPAuthorizationService Init" format:@"Invalid Arguments"];
    }
    return self;
}
- (instancetype) initWithController:(UIViewController*)controller {
    if (self == [super init]) {
        _controller = controller;
    }
    return self;
}
- (void) signOnWithHandler:(void(^)())handler {
    [self.spinnerController presentForController:_controller withHandler:^{
        [self.restService requestWithName:@"signon" andCompletionHandler:^(NSError *error_, id<DFSPModel>model_) {
            [self.spinnerController dismissWithHandler:^{
                if (error_) {
                    self.errorController.error = error_;
                    [self.errorController presentForController:_controller withHandler:^{
                        
                    }];
                } else {
                    if ([self checkSignonAuthorization:model_]) {
                        DFSPApplicationDataGet().authorization = (DFSPAuthorization*)model_;
                        [self performHandler:handler];
                    } else {
                        self.errorController.error = self.invalidModelError;
                        [self.errorController presentForController:_controller withHandler:^{
                            [self performHandler:handler];
                        }];
                    }
                }
            }];
        }];
    }];
}
- (void) signOffWithHandler:(void(^)())handler {
    [self.spinnerController presentForController:_controller withHandler:^{
        [self.restService requestWithName:@"signoff" andCompletionHandler:^(NSError *error_, id<DFSPModel> model_) {
            [self.spinnerController dismissWithHandler:^{
                if (error_) {
                    self.errorController.error = error_;
                    [self.errorController presentForController:_controller withHandler:^{
                        
                    }];
                } else {
                    if ([self checkSignoffAuthorization:model_]) {
                        DFSPApplicationDataGet().authorization = nil;
                        [self performHandler:handler];
                    } else {
                        self.errorController.error = self.invalidModelError;
                        [self.errorController presentForController:_controller withHandler:^{
                            [self performHandler:handler];
                        }];
                    }
                }
            }];
        }];
    }];
}

- (BOOL) checkSignonAuthorization:(id<DFSPModel>)authorization {
    BOOL result = YES;
    DFSPAuthorization* auth = (DFSPAuthorization*)authorization;
    if (![auth isKindOfClass:[DFSPAuthorization class]]) {
        result = NO;
    }
    if (!auth.authorizationToken.length) {
        result = NO;
    }
    if (!auth.userID.length) {
        result = NO;
    }
    if (!auth.timeToLive) {
        result = NO;
    }
    return result;
}
- (BOOL) checkSignoffAuthorization:(id<DFSPModel>)authorization {
    BOOL result = YES;
    DFSPAuthorization* auth = (DFSPAuthorization*)authorization;
    if (![auth isKindOfClass:[DFSPAuthorization class]]) {
        result = NO;
    }
    if (!auth.userID.length) {
        result = NO;
    }
    return result;
}
- (void) performHandler:(void(^)())handler {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler();
            });
        }
    }
}

- (DFSPSpinnerController*) spinnerController {
    if (!_spinnerController) {
        _spinnerController = [DFSPSpinnerController newController];
    }
    return _spinnerController;
}
- (DFSPErrorController*) errorController {
    if (!_errorController) {
        _errorController = [DFSPErrorController newController];
    }
    return _errorController;
}
- (NSError*) invalidModelError {
    if (!_invalidModelError) {
        _invalidModelError = [NSError restErrorWithCode:kDFSPRestErrorUnexpectedResponseObjectType];
    }
    return _invalidModelError;
}
- (DFSPRESTService*) restService {
    if (!_restService) {
        _restService = [DFSPRESTService new];
    }
    return _restService;
}
@end
