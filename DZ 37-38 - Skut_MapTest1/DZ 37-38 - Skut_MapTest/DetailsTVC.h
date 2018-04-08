//
//  DetailsTVC.h
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDStudent.h"

@interface DetailsTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) NSString* studentAddress;

- (void) closePopover:(UIViewController*) sender;
- (void)setValuesWithStudent:(ZDStudent*)student;



@end
