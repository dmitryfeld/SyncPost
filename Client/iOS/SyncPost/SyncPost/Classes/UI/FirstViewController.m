//
//  FirstViewController.m
//  SyncPost
//
//  Created by Dmitry Feld on 4/6/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "FirstViewController.h"
#import "DFSPSignOnController.h"
#import "DFSPApplicationData.h"
#import "DFSPAuthorizationService.h"

@interface FirstViewController () {
@private
    __strong DFSPSignOnController* _signOnController;
    __strong DFSPAuthorizationService* _authorizationService;
}
@property (readonly,nonatomic,strong) DFSPSignOnController* signOnController;
@property (readonly,nonatomic,strong) DFSPAuthorizationService* authorizationService;
@end

@implementation FirstViewController
@synthesize signOnController = _signOnController;
@synthesize authorizationService = _authorizationService;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!DFSPApplicationDataGet().isAuthorized) {
        [self.signOnController presentForController:self withHandler:^(NSError *error_) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DFSPSignOnController*) signOnController {
    if (!_signOnController) {
        _signOnController = [DFSPSignOnController newController];
    }
    return _signOnController;
}
- (DFSPAuthorizationService*) authorizationService {
    if (!_authorizationService) {
        _authorizationService = [[DFSPAuthorizationService alloc] initWithController:self];
    }
    return _authorizationService;
}

- (IBAction)onSignOut:(id)sender {
    [self.authorizationService signOffWithHandler:^{
        [self.signOnController presentForController:self withHandler:^(NSError *error_) {
            
        }];
    }];
}
@end
