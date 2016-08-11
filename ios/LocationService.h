//
//  LocationService.h
//  socketiotest
//
//  Created by Huang Yelong on 8/5/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "socketiotest-Swift.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


@interface LocationService : NSObject

@property (nonatomic, retain) SocketIOClient* socketio;

@property (nonatomic, retain) NSTimer *silenceTimer;

@property (nonatomic, retain) NSString *channelId;

@property (nonatomic, retain) NSString *userId;

@property (nonatomic, retain) NSString *cookie;

@property (nonatomic) NSTimeInterval *interval;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *longitude;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationService:(NSString*) userId cookie:(NSString*)cookie channelId:(NSString*)channelId ;

- (void)stopLocationService;

- (void)updateLocation;

@end
