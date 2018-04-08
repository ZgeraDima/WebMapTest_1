//
//  ViewController.m
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 27.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ViewController.h"
#import "ZDStudent.h"
#import "ZDMeetPoint.h"
#import "DetailsTVC.h"
#import <MapKit/MKAnnotationView.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView;

@end

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
    }
    if (!self.superview) {
        return nil;
    }
    return [self.superview superAnnotationView];
}
@end

typedef enum {
   ZDMapTypeStandard,
    ZDMapTypeSattelite,
    ZDMapTypeHybrid
} ZDMapType;

@interface ViewController ()

@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) MKDirections* directions;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) ZDMeetPoint* meetPoint;
@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) NSMutableArray* selectedStudents;
@property (assign, nonatomic) Boolean isDrawStudentsRoutes;
@property (strong, nonatomic) NSDictionary* address;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.students = [NSMutableArray array];
    self.selectedStudents = [NSMutableArray array];
    self.isDrawStudentsRoutes = NO;
    [self reloadNumberOfStudentsInCircles];
    
    // Core Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
    // Geocoder
    self.geoCoder = [[CLGeocoder alloc] init];
    // Meet point
    self.meetPoint = [[ZDMeetPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(55.75, 37.615) title:@"Meet point" subtitle:@""];
    [self.mapView addAnnotation:self.meetPoint];
    [self reloadOnlyCircleOverlays];
    
    // MapView rect
    self.mapView.delegate = self;
    MKMapPoint point = MKMapPointForCoordinate(self.meetPoint.coordinate);
    CGFloat delta = 100000;
    MKMapRect rect = MKMapRectMake(point.x - delta, point.y - delta, 2 * delta, 2 * delta);
    [self.mapView setVisibleMapRect:rect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}

- (void) dealloc {
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
}

- (void) addRoutesToMapBeetwenSourceCoordinate:(CLLocationCoordinate2D)source andDestination:(CLLocationCoordinate2D)destination {
    
    MKPlacemark* sourceMark = [[MKPlacemark alloc] initWithCoordinate:source];
    MKMapItem* sourceItem = [[MKMapItem alloc] initWithPlacemark:sourceMark];
    MKPlacemark* destinationMark = [[MKPlacemark alloc] initWithCoordinate:destination];
    MKMapItem* destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationMark];
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    request.source = sourceItem;
    request.destination = destinationItem;
    request.transportType = MKDirectionsTransportTypeWalking;
    request.requestsAlternateRoutes = YES;
    
    NSMutableArray* array = [NSMutableArray array];
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            
        } else if ([response.routes count] == 0) {
            
        } else {
            for (MKRoute* route in response.routes) {
                [array addObject:route.polyline];
            }
            [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
        }
    }];
}

- (void) reloadOverlays {
    [self reloadOnlyCircleOverlays];
    
    if (self.isDrawStudentsRoutes) {
        [self.selectedStudents removeAllObjects];
        for (ZDStudent* student in self.students){
            if ([self isDrawRouteBeetwenCoordinates:student.coordinate and:self.meetPoint.coordinate]) {
                [self.selectedStudents addObject:student];
            }
        }
        for (ZDStudent* student in self.selectedStudents){
            [self addRoutesToMapBeetwenSourceCoordinate:student.coordinate andDestination:self.meetPoint.coordinate];
        }
    }
}

- (void) reloadOnlyCircleOverlays {
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self.mapView addOverlays:[self circlesArroundCoordinate:self.meetPoint.coordinate]];
}

- (void) reloadNumberOfStudentsInCircles {
    NSInteger inFirstCircle = 0;
    NSInteger inSecondCircle = 0;
    NSInteger inThirdCircle = 0;
    for (ZDStudent* student in self.students){
        double distance = [self metersBeetwenCoordinates:student.coordinate and:self.meetPoint.coordinate];
        if (distance < 5000.0) {
            inFirstCircle += 1;
        } else if (distance < 10000.0) {
            inSecondCircle += 1;
        } else if (distance < 15000.0) {
            inThirdCircle += 1;
        }
    }
    self.firstCircleValue.text = [NSString stringWithFormat:@"%ld", (long)inFirstCircle];
    self.secondCircleValue.text = [NSString stringWithFormat:@"%ld", (long)inSecondCircle];
    self.thirdCircleValue.text = [NSString stringWithFormat:@"%ld", (long)inThirdCircle];
}

- (NSArray*) circlesArroundCoordinate:(CLLocationCoordinate2D)coordinate {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:[MKCircle circleWithCenterCoordinate:coordinate radius:5000.0]];
    [array addObject:[MKCircle circleWithCenterCoordinate:coordinate radius:10000.0]];
    [array addObject:[MKCircle circleWithCenterCoordinate:coordinate radius:15000.0]];
    return array;
}

- (double) metersBeetwenCoordinates:(CLLocationCoordinate2D)coordinate1 and:(CLLocationCoordinate2D)coordinate2 {
    MKMapPoint point1 = MKMapPointForCoordinate(coordinate1);
    MKMapPoint point2 = MKMapPointForCoordinate(coordinate2);
    return MKMetersBetweenMapPoints(point1, point2);
}

- (bool)isDrawRouteBeetwenCoordinates:(CLLocationCoordinate2D)coordinate1 and:(CLLocationCoordinate2D)coordinate2 {
    double distance = [self metersBeetwenCoordinates:coordinate1 and:coordinate2];
    if (distance < 5000.0) {
        NSLog(@"90pc");
        return arc4random_uniform(101) < 90;
    } else if (distance < 10000.0) {
        NSLog(@"50pc");
        return arc4random_uniform(101) < 50;
    } else if (distance < 15000.0) {
        NSLog(@"10pc");
        return arc4random_uniform(101) < 10;
    } else {
        NSLog(@"0pc");
        return NO;
    }
}

# pragma mark - Popover

- (void)showPopoverWithStudent:(ZDStudent*)student nearRect:(CGRect)rect withAddress:(NSString*)address {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsTVC* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailsTVC"];
    [vc setValuesWithStudent:student];
    vc.studentAddress = address;
    vc.preferredContentSize = CGSizeMake(300, 300);
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                             style:UIBarButtonItemStylePlain
                                                            target:vc
                                                            action:@selector(closePopover:)];
    vc.navigationItem.rightBarButtonItem = item;
    
    nc.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:nc animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [nc popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    popController.sourceView = self.view;
    popController.sourceRect = rect;
}

# pragma mark - Actions

- (IBAction)mapTypeChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case ZDMapTypeStandard:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case ZDMapTypeSattelite:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case ZDMapTypeHybrid:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

- (IBAction)addStudents:(UIBarButtonItem *)sender {
    [self.mapView removeAnnotations:self.students];
    self.isDrawStudentsRoutes = NO;
    [self.students removeAllObjects];
    for (int i = 0; i < 30 ; i += 1) {
        ZDStudent* student = [[ZDStudent alloc] initWithRandomCoordinateWithCenterIn:self.meetPoint.coordinate inRectWitnSide:300000];
        [self.students addObject:student];
        [self.mapView addAnnotation:student];
    }
    [self reloadOnlyCircleOverlays];
    [self reloadNumberOfStudentsInCircles];
}

- (IBAction)addRoutes:(UIBarButtonItem *)sender {
    self.isDrawStudentsRoutes = YES;
    [self reloadOverlays];
}

- (void)showInfo:(UIButton*) sender {
    MKAnnotationView* annotationView = [sender superAnnotationView];
    if ([annotationView.annotation isKindOfClass:[ZDStudent class]]) {
        ZDStudent* student = (ZDStudent*)annotationView.annotation;
        CLLocationCoordinate2D coordinate = student.coordinate;
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                          longitude:coordinate.longitude];
        if ([self.geoCoder isGeocoding]) {
            [self.geoCoder cancelGeocode];
        }
        
        [self.geoCoder
         reverseGeocodeLocation:location
         completionHandler:^(NSArray *placemarks, NSError *error) {
             if (error) {
                 NSLog(@"%@", [error localizedDescription]);
             } else if ([placemarks count] > 0) {
                 MKPlacemark* placeMark = [placemarks firstObject];
                 NSString* address = @"";
                 address = [placeMark.addressDictionary objectForKey:@"Street"];
                 if (address == nil) {
                     address = [placeMark.addressDictionary objectForKey:@"State"];
                 }
                 if (address == nil) {
                     address = [placeMark.addressDictionary objectForKey:@"Country"];
                 }
                 UIView* view = [[[sender superview] superview] superview];
                 CGRect rect = [view convertRect:view.bounds toView:self.view];
                 [self showPopoverWithStudent:student nearRect:rect withAddress:address];
             }
         }];
    }
}

# pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[ZDStudent class]]) {
        static NSString* identifier = @"Student annotation";
        MKAnnotationView* pin = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        ZDStudent* student = (ZDStudent*)annotation;
        if (!pin) {
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pin.canShowCallout = YES;
            pin.draggable = NO;
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
            pin.rightCalloutAccessoryView = infoButton;
        } else {
            pin.annotation = annotation;
        }
        pin.image = student.image;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        imageView.image = student.image;
        pin.leftCalloutAccessoryView = imageView;
        
        return pin;
    } else if ([annotation isKindOfClass:[ZDMeetPoint class]]) {
        static NSString* identifier = @"Meet point annotation";
        MKAnnotationView* pin = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        pin.image = [UIImage imageNamed:@"cocktail.png"];
        
        if (!pin) {
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pin.canShowCallout = YES;
            pin.draggable = YES;
        } else {
            pin.annotation = annotation;
        }
        pin.image = [UIImage imageNamed:@"cocktail.png"];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        imageView.image = pin.image;
        pin.leftCalloutAccessoryView = imageView;
        
        return pin;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer* render = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        render.fillColor = [UIColor.blueColor colorWithAlphaComponent:0.15];
        render.strokeColor = UIColor.blueColor;
        render.lineWidth = 0.1;
        return render;
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        render.strokeColor = [UIColor.greenColor colorWithAlphaComponent:0.7];
        render.lineWidth = 3;
        return render;
    } else {
        return [[MKOverlayRenderer alloc] init];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState == MKAnnotationViewDragStateStarting){
        NSLog(@"Starting");
        [self.mapView removeOverlays:[self.mapView overlays]];
    } else if (newState == MKAnnotationViewDragStateDragging) {
        NSLog(@"Dragging");
    } else if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        NSLog(@"Starting");
        [self reloadOverlays];
        [self reloadNumberOfStudentsInCircles];
    }
}

@end
