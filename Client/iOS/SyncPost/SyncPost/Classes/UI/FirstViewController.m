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

@interface FirstViewController () {
@private
    __strong DFSPSignOnController* _signOnController;
}
@property (readonly,nonatomic,strong) DFSPSignOnController* signOnController;
@end

@implementation FirstViewController
@synthesize signOnController = _signOnController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!DFSPApplicationDataGet().authorization) {
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
@end
