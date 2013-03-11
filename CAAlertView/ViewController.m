//
//  ViewController.m
//  CAAlertView
//
//  Created by Chandan on 11/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

CAAlertView *alertView;
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnShowAlert:(id)sender {
    alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeDatePicker andData:[NSArray arrayWithObjects:@"Apple", @"Banana",@"Mango",@"Papaya",@"Grapes", nil]];
    [alertView setDelegate:self];
    [alertView showAlertView];
}

- (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data {
    NSLog(@"%@",data);
}

- (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSArray *) info {
    
}


@end
