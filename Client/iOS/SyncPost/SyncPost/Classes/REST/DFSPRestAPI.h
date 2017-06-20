//
//  DFSPRestAPI.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestRequest.h"
#import "DFSPRestMapper.h"


@interface DFSPRestAPI : NSObject
@property (readonly,nonatomic) BOOL isInProcess;
@property (readonly,nonatomic,strong) DFSPRestResponse* response;
@property (readonly,nonatomic,strong) NSError* systemError;
- (instancetype) initWithMapper:(DFSPRestMapper*)mapper NS_DESIGNATED_INITIALIZER;
- (void) startWithRequest:(DFSPRestRequest*)request andCompletionHandler:(void(^)(NSError*,DFSPRestResponse*))handler;
@end
