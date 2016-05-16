//
//  ViewController.m
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import "ViewController.h"
#import "CAAlertView.h"
#import "CACustomAlertObject.h"

@interface ViewController () <CAAlertViewDelegate>

@property (nonatomic, strong) CAAlertView *alertView;

@end


@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnShowDataAlert:(id)sender {
    
    NSMutableArray *objectToShow = [[NSMutableArray alloc] init];
    for (int i = 0; i<=10; i++) {
        CACustomAlertObject *object = [[CACustomAlertObject alloc] initWithObjectName:[NSString stringWithFormat:@"chandan %d",i] AndID:i];
        [objectToShow addObject:object];
    }
    
    _alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeTable andData:objectToShow];
    [_alertView setDelegate:self];
    [_alertView showAlertView:sender];
}


- (IBAction)btnShowDateAlert:(id)sender {
    
    _alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeDatePicker andData:nil];
    [_alertView setDelegate:self];
    [_alertView showAlertView:sender];
}


- (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data {
    NSLog(@"%@", data);
}

- (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSString *) info {
    NSLog(@"%@", info);
}


@end
