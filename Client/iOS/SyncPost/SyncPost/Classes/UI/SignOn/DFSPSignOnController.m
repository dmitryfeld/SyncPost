//
//  DFSPSignOnController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSignOnController.h"
#import "DFSPSignOnViewController.h"
#import "DFSPSpinnerController.h"
#import "DFSPService.h"
#import "DFSPErrorController.h"
#import "DFSPApplicationData.h"
#import "NSError+Rest.h"

@interface DFSPSignOnController ()<DFSPSignOnViewControllerDelegate> {
    __strong void(^_controlHandler)(NSError*);
    __strong NSError* _error;
    __strong DFSPSpinnerController* _spinner;
    __strong UIViewController* _parentController;
    __strong DFSPErrorController* _errorController;
    __strong NSError* _invalidModelError;
    __strong DFSPService* _service;
    BOOL _isPresented;
}
@property (readonly,nonatomic,strong) DFSPSpinnerController* spinner;
@property (readonly,nonatomic,strong) DFSPErrorController* errorController;
@property (readonly,nonatomic,strong) NSError* invalidModelError;
@property (readonly,nonatomic,strong) DFSPService* service;
@property (readonly,nonatomic) DFSPSignOnViewController* signonController;
@end

@implementation DFSPSignOnController
@synthesize isPresented = _isPresented;
@synthesize spinner = _spinner;
@synthesize errorController = _errorController;
@synthesize invalidModelError = _invalidModelError;
@synthesize service = _service;
@dynamic signonController;
- (void)viewDidLoad {
    [super viewDidLoad];
    _isPresented = NO;
    self.signonController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentForController:(UIViewController*)controller withHandler:(void(^)(NSError*))handler {
    if (!_isPresented) {
        _controlHandler = handler;
        _parentController = controller;
        [controller presentViewController:self animated:YES completion:^{
            _isPresented = YES;
        }];
    }
}
- (void) signOnViewControllerDidTapUpdateButton:(DFSPSignOnViewController*)controller {
    [self.spinner presentForController:self withHandler:^{
        
        [self.service requestWithName:@"authorization" andCompletionHandler:^(NSError *error_, id<DFSPModel>model_) {
            [self.spinner dismissWithHandler:^{
                if (error_) {
                    self.errorController.error = error_;
                    [self.errorController presentForController:self withHandler:^{
                        
                    }];
                } else {
                    _isPresented = NO;
                    if ([self checkAuthorization:model_]) {
                        DFSPApplicationDataGet().authorization = (DFSPAuthorization*)model_;
                    } else {
                        self.errorController.error = self.invalidModelError;
                        [self.errorController presentForController:self withHandler:^{
                            
                        }];
                    }
                    [_parentController dismissViewControllerAnimated:YES completion:^{
                        if (_controlHandler) {
                            if ([NSThread isMainThread]) {
                                _controlHandler(_error);
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    _controlHandler(_error);
                                });
                            }
                        }
                    }];
                }
            }];
        }];
    }];
}

- (BOOL) checkAuthorization:(id<DFSPModel>)authorization {
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


+ (DFSPSignOnController*) newController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignOnController" bundle:nil];
    NSString* identifier = @"DFSPSignOnController";
    return (DFSPSignOnController*)[storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (DFSPSpinnerController*) spinner {
    if (!_spinner) {
        _spinner = [DFSPSpinnerController newController];
    }
    return _spinner;
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
- (DFSPService*) service {
    if (!_service) {
        _service = [DFSPService new];
    }
    return _service;
}
- (DFSPSignOnViewController*) signonController {
    return (DFSPSignOnViewController*)self.viewControllers.firstObject;
}
@end
