//
//  DFSPRestResponse.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@interface DFSPRestResponse : NSObject
@property (readonly,nonatomic,strong) NSError* error;
@property (readonly,nonatomic,strong) id<DFSPModel> model;
@end
