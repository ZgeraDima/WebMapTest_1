//
//  DetailsTVC.m
//  DZ 37-38 - Skut_MapTest
//
//  Created by mac on 31.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "DetailsTVC.h"

@interface DetailsTVC ()

@property (strong, nonatomic) NSString* studentName;
@property (strong, nonatomic) NSString* studentLastName;
@property (strong, nonatomic) NSString* studentDateOfBirth;
@property (strong, nonatomic) NSString* studentGender;

@end

@implementation DetailsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.studentName;
    self.lastName.text = self.studentLastName;
    self.dateOfBirth.text = self.studentDateOfBirth;
    self.gender.text = self.studentGender;
    self.address.text = self.studentAddress;
}

- (void)setValuesWithStudent:(ZDStudent*)student {
    self.studentName = student.firstName;
    self.studentLastName = student.lastName;
    self.studentDateOfBirth = student.subtitle;
    self.studentGender = student.genderDescription;
}

# pragma mark - Actions

- (void) closePopover:(UIViewController*) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
