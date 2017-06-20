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


@interface DFSPSignOnController ()<DFSPSignOnViewControllerDelegate> {
    __strong void(^_controlHandler)(NSError*);
    __strong NSError* _error;
    __strong DFSPSpinnerController* _spinner;
    __strong UIViewController* _parentController;
    BOOL _isPresented;
}
@property (readonly,nonatomic,strong) DFSPSpinnerController* spinner;
@property (readonly,nonatomic) DFSPSignOnViewController* signonController;
@end

@implementation DFSPSignOnController
@synthesize isPresented = _isPresented;
@synthesize spinner = _spinner;
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

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self.spinner dismissWithHandler:^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
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
                    
                    
                });

                
                
            }];
            
        });
        
        
        
        
        
    }];
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


- (DFSPSignOnViewController*) signonController {
    return (DFSPSignOnViewController*)self.viewControllers.firstObject;
}
@end
