//
//  DFSPSignOnController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSignOnController.h"
#import "DFSPSignOnViewController.h"
#import "DFSPApplicationData.h"
#import "DFSPAuthorizationService.h"

@interface DFSPSignOnController ()<DFSPSignOnViewControllerDelegate> {
    __strong void(^_controlHandler)(NSError*);
    __strong NSError* _error;
    __strong UIViewController* _parentController;
    __strong DFSPAuthorizationService* _authorizationService;
    BOOL _isPresented;
}
@property (readonly,nonatomic,strong) DFSPAuthorizationService* authorizationService;
@property (readonly,nonatomic) DFSPSignOnViewController* signonController;
@end

@implementation DFSPSignOnController
@synthesize isPresented = _isPresented;
@synthesize authorizationService = _authorizationService;
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
- (void) signOnViewControllerDidTapSignonButton:(DFSPSignOnViewController*)controller {
    
    DFSPApplicationDataGet().credentials = controller.credentials;
    
    [self.authorizationService signOnWithHandler:^{
        _isPresented = NO;
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
    }];
}



+ (DFSPSignOnController*) newController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignOnController" bundle:nil];
    NSString* identifier = @"DFSPSignOnController";
    return (DFSPSignOnController*)[storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (DFSPAuthorizationService*) authorizationService {
    if (!_authorizationService) {
        _authorizationService = [[DFSPAuthorizationService alloc] initWithController:self];
    }
    return _authorizationService;
}
- (DFSPSignOnViewController*) signonController {
    return (DFSPSignOnViewController*)self.viewControllers.firstObject;
}
@end
