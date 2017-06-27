//
//  DFSPErrorController.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModalController.h"

@interface DFSPErrorController : DFSPModalController
@property (strong,nonatomic) NSError* error;
+ (DFSPErrorController*) newController;
@end
