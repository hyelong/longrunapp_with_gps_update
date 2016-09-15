//
//  LocationService.m
//  socketiotest
//
//  Created by Huang Yelong on 8/5/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "LocationService.h"


@implementation LocationService

+ (CLLocationManager *)sharedLocationManager {
  static CLLocationManager *_locationManager;
  
  @synchronized(self) {
    if (_locationManager == nil) {
      _locationManager = [[CLLocationManager alloc] init];
      _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
      _locationManager.allowsBackgroundLocationUpdates = YES;
      _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
  }
  return _locationManager;
}

static LocationService *singletonObject = nil;

+ (LocationService*) sharedLocationService
{
  if (! singletonObject) {
    
    singletonObject = [[LocationService alloc] init];
  }
  return singletonObject;
}

- (id)init
{
  if (! singletonObject) {
    
    singletonObject = [super init];

  }
  return singletonObject;
}


-(void)startLocationService:(NSString*) userId cookie:(NSString*)cookie
                  channelId:(NSString*)channelId
                       name:(NSString*)name logo: (NSString*)logo{
                       
  CLLocationManager *locationManager = [LocationService sharedLocationManager];
  [locationManager requestAlwaysAuthorization] 
  
  self.userId = userId;
  self.cookie = cookie;
  self.channelId = channelId;
  self.name = name;
  self.logo = logo;
  
  NSURL* url = [[NSURL alloc] initWithString:@"https://www.topichat.com:3333"];
  self.socketio = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forceWebsockets": @YES,
                                                                          @"connectParams":@{@"cookie":self.cookie}}];
  
  [self.socketio on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
    NSLog(@"socket connected");
    /*
     [self.socketio emit:@"join gps channel" withItems:@[@{@"channelId": @"6aff2d40-53ab-11e6-9555-f6284ea49312",
     @"author":@{@"id":@"zhengdong",
     @"name":@"zhengdong",
     @"logo":@""}}]];
     */
  }];
  
  [self.socketio on:@"gpsRequest" callback:^(NSArray* data, SocketAckEmitter* ack) {
    NSLog(@"receive gps channel message");
    
    /*
     [self.socketio emit:@"reply GPS" withItems:@[@{@"channelId": @"6aff2d40-53ab-11e6-9555-f6284ea49312",
     @"author":@{@"id":@"zhengdong",
     @"name":@"zhengdong",
     @"logo":@""},
     @"content":@{@"latitude":self.latitude,
     @"longitude":self.longitude
     }
     }]];
     */
    
  }];
  
  [self.socketio connect];


  dispatch_async( dispatch_get_main_queue(), ^{
    
    UIApplication  *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
      [app endBackgroundTask:bgTask];
      bgTask = UIBackgroundTaskInvalid;
    }];
    

    self.silenceTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                                       selector:@selector(updateLocation) userInfo:nil repeats:YES];
    
  });
  self.inService = TRUE;
  
}

-(void)stopLocationService {
  dispatch_async( dispatch_get_main_queue(), ^{
    
    [self.socketio disconnect];
    [self.silenceTimer invalidate];
    self.silenceTimer = nil;
    
    [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];
  
    self.inService = FALSE;
  });
}

-(void)updateLocation{
 
    CLLocationManager *locationManager = [LocationService sharedLocationManager];
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    
    NSLog(@"latitude:%@", self.latitude);
    NSLog(@"longitude: %@ ", self.longitude);
  
   [self.socketio emit:@"reply GPS" withItems:@[@{@"channelId": self.channelId,
   @"author":@{@"id":self.userId,
   @"name":self.name,
   @"logo":self.logo},
   @"content":@{@"latitude":self.latitude,
   @"longitude":self.longitude
   }
   }]];
   
  
    [locationManager stopUpdatingLocation];

}

@end
