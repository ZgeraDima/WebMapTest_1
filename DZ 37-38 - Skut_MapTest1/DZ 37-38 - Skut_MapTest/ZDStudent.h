//
//  ZDStudent.h
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    ZDGenderMale,
    ZDGenderFemale
} ZDGender;

@interface ZDStudent : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* genderDescription;
@property (strong, nonatomic) NSDate* dateOfBirth;
@property (assign, nonatomic) ZDGender gender;
@property (nonatomic, strong) UIImage* image;

- (instancetype)initWithRandomCoordinateWithCenterIn:(CLLocationCoordinate2D)coordinate inRectWitnSide:(double)side;

@end
