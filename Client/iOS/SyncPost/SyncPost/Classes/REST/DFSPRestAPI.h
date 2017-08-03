//
//  DFSPRestAPI.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestMap.h"


@interface DFSPRestAPI : NSObject
@property (readonly,nonatomic,strong) DFSPRequestMap* requestMap;
@property (readonly,nonatomic) BOOL isInProcess;
- (instancetype) initWithRequestMap:(DFSPRequestMap*)requestMap NS_DESIGNATED_INITIALIZER;
- (void) startWithRequestName:(NSString*)requestName andCompletionHandler:(void(^)(NSError*,id<DFSPModel>))handler;
@end
