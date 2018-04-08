//
//  ViewController.h
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 27.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *firstCircleValue;
@property (weak, nonatomic) IBOutlet UILabel *secondCircleValue;
@property (weak, nonatomic) IBOutlet UILabel *thirdCircleValue;



@end

