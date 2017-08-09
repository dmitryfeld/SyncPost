//
//  DFSPRequestMap.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestTemplate.h"
#import "DFSPModel.h"

@interface DFSPRequestMap : NSObject
@property (readonly,nonatomic,strong) NSString* name;
@property (readonly,nonatomic,strong) NSString* version;
@property (readonly,nonatomic,strong) NSError* error;
@property (readonly,nonatomic,strong) id context;
@property (readonly,nonatomic) BOOL isSimulated;
@property (readonly,nonatomic,strong) NSArray<DFSPRequestTemplate*>* requestTemplates;
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary NS_DESIGNATED_INITIALIZER;
- (NSURLRequest*) prepareRequestWithName:(NSString*)name;
- (id<DFSPModel>) processResponse:(NSDictionary*)response withError:(NSError **)error;
- (NSString*) simulatedDataPathWithName:(NSString*)name;
@end
