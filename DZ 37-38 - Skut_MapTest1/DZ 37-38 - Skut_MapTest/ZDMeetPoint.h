//
//  ZDMeetPoint.h
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZDMeetPoint : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle;

@end
