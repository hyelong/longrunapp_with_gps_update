//
//  LocationServiceBridge.m
//  socketiotest
//
//  Created by Huang Yelong on 8/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTBridgeModule.h"
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(LocationService, NSObject)

RCT_EXTERN_METHOD(startLocationService:(NSString*) userId cookie:(NSString*)cookie channelId:(NSString*)channelId)
RCT_EXTERN_METHOD(stopLocationService)


@end