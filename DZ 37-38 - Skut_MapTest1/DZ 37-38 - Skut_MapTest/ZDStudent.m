//
//  ZDStudent.m
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ZDStudent.h"

@interface ZDStudent()

@property (assign, nonatomic) NSInteger minAge;
@property (assign, nonatomic) NSInteger maxAge;

@end

@implementation ZDStudent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minAge = 16;
        self.maxAge = 50;
        self.gender = arc4random_uniform(2);
        self.genderDescription = self.gender == ZDGenderMale ? @"Male" : @"Female";
        self.image = self.gender == ZDGenderMale ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
        self.firstName = [ZDStudent randomNameByGender:self.gender];
        self.lastName = [ZDStudent randomLastNameByGender:self.gender];
        self.title = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        
        self.dateOfBirth = [self randomDateOfBirth];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.YYYY"];
        self.subtitle = [dateFormatter stringFromDate:self.dateOfBirth];
    }
    return self;
}

- (instancetype)initWithRandomCoordinateWithCenterIn:(CLLocationCoordinate2D)coordinate inRectWitnSide:(double)side {
    self = [self init];
    if (self) {
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        point.x = [ZDStudent randomDoubleFrom:point.x - side / 2 to:point.x + side/ 2 withDecimalPlaces:3];
        point.y = [ZDStudent randomDoubleFrom:point.y - side / 2 to:point.y + side/ 2 withDecimalPlaces:3];
        self.coordinate = MKCoordinateForMapPoint(point);
    }
    return self;
}

+ (double)randomDoubleFrom:(double) startNumber to:(double) endNumber withDecimalPlaces:(double)decimalPlaces{
    double multiplier = pow(10, decimalPlaces);
    return startNumber + (double)(arc4random_uniform((endNumber - startNumber) * (multiplier + 1))) / multiplier;
}

# pragma mark - Randoms

+ (NSString*) randomNameByGender:(ZDGender) gender {
    NSArray* mensNames = [NSArray arrayWithObjects: @"Sergey", @"Alexander", @"Pavel", @"Anatoliy", @"Alexey", @"Ivan", @"Victor", @"Boris", @"Dmitriy", @"Evgeniy", @"Anton", @"Igor", nil];
    NSArray* womensNames = [NSArray arrayWithObjects:@"Eva", @"Maria", @"Elena", @"Alina", @"Ekaterina", @"Victoria", @"Galina", @"Yana", @"Anna", @"Alla", @"Svetlana", @"Marina", nil];
    
    switch (gender) {
        case ZDGenderMale:
            return mensNames[arc4random_uniform([mensNames count])];
        case ZDGenderFemale:
            return womensNames[arc4random_uniform([womensNames count])];
    }
}

+ (NSString*) randomLastNameByGender:(ZDGender) gender {
    NSArray* mensLastNames = [NSArray arrayWithObjects:@"Ivanov", @"Petrov", @"Davidov", @"Kuzmenko", @"Nikitin", @"Sergienko", @"Popov", @"Knyazev", @"Suvorov", @"Kozlov", @"Lukyanov", @"Djachenko", nil];
    NSArray* womensLastNames = [NSArray arrayWithObjects:@"Ivanova", @"Petrova", @"Davidova", @"Kuzmenko", @"Nikitina", @"Sergienko", @"Popova", @"Knyazeva", @"Suvorova", @"Kozlova", @"Lukyanova", @"Djachenko", nil];
    
    switch (gender) {
        case ZDGenderMale:
            return mensLastNames[arc4random_uniform([mensLastNames count])];
        case ZDGenderFemale:
            return womensLastNames[arc4random_uniform([womensLastNames count])];
    }
}

- (NSDate*) randomDateOfBirth {
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY"];
    NSInteger currentYear = [[dateFormatter stringFromDate:date] integerValue];
    
    [dateFormatter setDateFormat:@"M"];
    NSInteger currentMonth = [[dateFormatter stringFromDate:date] integerValue];
    
    [dateFormatter setDateFormat:@"d"];
    NSInteger currentDay = [[dateFormatter stringFromDate:date] integerValue];
    
    [dateFormatter setDateFormat:@"YYYY/M/d"];
    NSString* minDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld",   currentYear - self.maxAge - 1,
                            currentMonth,
                            currentDay + 1];
    
    NSDate* minDate = [dateFormatter dateFromString:minDateStr];
    
    NSString* maxDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld",   currentYear - self.minAge,
                            currentMonth,
                            currentDay];
    NSDate* maxDate = [dateFormatter dateFromString:maxDateStr];
    
    NSTimeInterval interval = [maxDate timeIntervalSinceDate:minDate];
    NSDate* randomDate = [minDate dateByAddingTimeInterval:arc4random_uniform(interval)];
    return randomDate;
}


@end
