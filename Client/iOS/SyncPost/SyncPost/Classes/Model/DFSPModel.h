//
//  DFSPModel.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFSPMutableModel;
@protocol DFSPModel<NSObject,NSCopying,NSCoding>
@required
- (instancetype) initWithTemplate:(id<DFSPModel>)model;
- (id<DFSPMutableModel>) mutableCopy;
@end
@protocol DFSPMutableModel<DFSPModel>
@required
- (id<DFSPModel>) immutableCopy;
@end
@protocol DFSPModelKVP<DFSPMutableModel>
@required
@property (readonly,nonatomic,strong) NSError* error;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (id<DFSPMutableModel>) fromDictionary:(NSDictionary*)dictionary;
@end

@protocol DFSPModelAUX<DFSPMutableModel>
@end

