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

@property(nonatomic, strong) CAAlertView *alertView;
@property(nonatomic, weak) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (IBAction)btnShowDataAlert:(id)sender {
    
    NSMutableArray *objectToShow = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        CACustomAlertObject *object = [[CACustomAlertObject alloc]
                                       initWithObjectName:[NSString stringWithFormat:@"chandan %d", i]
                                       AndID:i];
        [objectToShow addObject:object];
    }
    
    _alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeTable
                                           andData:objectToShow];
    _alertView.delegate = self;
    [_alertView showAlertView:sender];
}

- (IBAction)btnShowDateAlert:(id)sender {
    
    _alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeDatePicker andData:nil];
    _alertView.delegate = self;
    [_alertView showAlertView:sender];
}

- (void)alertView:(CAAlertView *)obj completedWithData:(NSArray <CACustomAlertObject*> *)data {
    NSLog(@"%@", data);
    [self updateResultOnLabel:data];
}

- (void)alertView:(CAAlertView *)obj cancelledWithNoData:(NSString *)info {
    NSLog(@"%@", info);
}

- (void)updateResultOnLabel:(NSArray <CACustomAlertObject*> *)result {
    
    if (result == nil || result.count == 0) {
        return;
    }
    
    _resultLabel.text = result.firstObject.objName;
}

@end
