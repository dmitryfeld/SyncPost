//
//  DFSPRequestMap.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestData.h"

@interface DFSPRequestMap : NSObject
@property (readonly,nonatomic,strong) NSError* error;
@property (readonly,nonatomic,strong) id context;
@property (readonly,nonatomic,strong) NSArray<DFSPRequestData*>* requestData;
@property (readonly,nonatomic,strong) NSURL* accessURL;
- (instancetype) initWithDictionary:(NSDictionary*)dictionary NS_DESIGNATED_INITIALIZER;
@end
