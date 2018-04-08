//
//  ZDMeetPoint.m
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ZDMeetPoint.h"

@implementation ZDMeetPoint

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"";
        self.subtitle = @"";
    }
    return self;
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle {
    self = [self init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}

@end
