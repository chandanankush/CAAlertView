//
//  CAPickerViewController.m
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import "CAPickerViewController.h"

@interface CAPickerViewController ()

@end

@implementation CAPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [_myDatePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void) pickerValueChanged:(id) sender {
    
}


- (void) dealloc {
    _myDatePicker = nil;
}

@end
