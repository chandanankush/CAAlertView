//
//  CAAlertView.m
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import "CAAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "CAPickerViewController.h"
#import "CAPopOverViewController.h"

#define isiPhone5 YES
#define DATE_FORMATTER  @"MM-dd-yyyy HH:mm"
//UIPopover+Iphone.m
@implementation UIPopoverController (overrides)
+ (BOOL)_popoversDisabled {
    return NO;
}
@end

@implementation CACustomAlertObject

- (id) initWithObjectName:(NSString *) objName AndID:(NSInteger ) obID {
    if (self = [super init]) {
        self.objName = objName;
        self.objID = obID;
        self.isSelectable = YES;
        self.isDefaultSelected = NO;
    }
    return self;
}

- (void) dealloc {
    self.objName = nil;
}
@end


@interface CAAlertView()<UIAlertViewDelegate, CAPopOverViewControllerDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate> {
    NSArray *objectArray;
    UIPopoverController *myPopOver;
}

@property (nonatomic, strong) CAPopOverViewController *tablePopOver;
@property (nonatomic, strong) CAPickerViewController *datePickerPopOver;

- (void) configureAlertView;

NSString *kformatDateToString(NSDate *date);
NSString *kformatDateAndTimeToString(NSDate *date);
@end

#pragma mark
#pragma mark setter getter
@implementation CAAlertView
@synthesize delegate = _delegate;
@synthesize myType = _myType;
@synthesize isMultipleSelectionAllowed = _isMultipleSelectionAllowed;
@synthesize  isDatePickerTypeDOB = _isDatePickerTypeDOB;


#pragma mark
#pragma mark Class constructor
- (id) initWithType:(CAAlertViewType) type andData:(NSArray *) array {
    if (self = [super init]) {
        _myType = type;
        if (_myType == CAAlertViewTypeTable) {
            objectArray = [[NSArray alloc] initWithArray:(array && array.count > 0 ? array : [NSArray arrayWithObject:@"No Data To Display"])];
        }
        _isDatePickerTypeDOB = YES;
        _isDateAndTineBoth = NO;
        _isMultipleSelectionAllowed = NO;
    }
    return self;
}

#pragma mark
#pragma mark Configuring Alert
- (void) configureAlertView {
     if (_myType == CAAlertViewTypeDatePicker) {
          _datePickerPopOver = [self datePickerPopOver];
     }else {
          _tablePopOver = [self tablepopOver];
     }
}

- (void) showAlertView:(id) sender {
    [self configureAlertView];
    UIViewController *controller = (UIViewController *) _delegate;
    
    if (_myType == CAAlertViewTypeDatePicker) {
        
        UIView *v = (UIView *) sender;
        UIPopoverPresentationController *ppc = _datePickerPopOver.popoverPresentationController;
        [ppc setDelegate:self];
        
        _datePickerPopOver.popoverPresentationController.sourceView = v;
        _datePickerPopOver.popoverPresentationController.sourceRect = v.bounds;
        [controller presentViewController:_datePickerPopOver animated:YES completion:^{
            
        }];
    }
    else {
        
        UIView *v = (UIView *) sender;
        UIPopoverPresentationController *ppc = _tablePopOver.popoverPresentationController;
        [ppc setDelegate:self];
        
        _tablePopOver.popoverPresentationController.sourceView = v;
        _tablePopOver.popoverPresentationController.sourceRect = v.bounds;
        [controller presentViewController:_tablePopOver animated:YES completion:^{
            
        }];
    }
}

//CGRectMake(250, isiPhone5 ? 500 : 400, 50, 50)
- (void) showAlertViewWithFrame:(CGRect) frame {
    [self configureAlertView];
    UIViewController *controller = (UIViewController *) _delegate;
     [myPopOver presentPopoverFromRect:frame inView:controller.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    controller = nil;
}

- (CAPopOverViewController *) tablepopOver {
    
   if (!_tablePopOver) {
        _tablePopOver = [[CAPopOverViewController alloc] initWithDataSource:objectArray];
        [_tablePopOver setDelegate:self];
    }else {
        _tablePopOver = (CAPopOverViewController *)myPopOver.contentViewController;
        [_tablePopOver modefyDataSource:objectArray];
    }
    _tablePopOver.isMultipleSelectionAllowed = _isMultipleSelectionAllowed;
    _tablePopOver.modalPresentationStyle = UIModalPresentationPopover;
    return _tablePopOver;
}

- (CAPickerViewController *) datePickerPopOver {
    
    if (!_datePickerPopOver) {
        _datePickerPopOver = [[CAPickerViewController alloc] init];
    }
    
    [_datePickerPopOver.myDatePicker setDatePickerMode: _isDateAndTineBoth ? UIDatePickerModeDateAndTime : UIDatePickerModeDate];
    
    if (_isDatePickerTypeDOB) {
        [_datePickerPopOver.myDatePicker setMaximumDate:[NSDate date]];
    }
    else{
        [_datePickerPopOver.myDatePicker setMinimumDate:[NSDate date]];
    }
    _datePickerPopOver.modalPresentationStyle = UIModalPresentationPopover;
    
    return _datePickerPopOver;
}

- (void) CAPopover:(CAPopOverViewController *) obj selectedData:(id) data {
    if ([_delegate respondsToSelector:@selector(CAAlertView:completedWithData:)]) {
        if (_myType == CAAlertViewTypeTable) {
            [_delegate CAAlertView:self completedWithData:@[data]];
        }
    }
    if (!_isMultipleSelectionAllowed) {
        if ([myPopOver isPopoverVisible]) {
            [myPopOver dismissPopoverAnimated:YES];
        }
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    if (_myType == CAAlertViewTypeDatePicker) {
        if ([_delegate respondsToSelector:@selector(CAAlertView:completedWithData:)]) {
            CAPickerViewController *caPopOverViewController = (CAPickerViewController *)myPopOver.contentViewController;
            NSString *d = nil;
            if (_isDateAndTineBoth) {
                d = kformatDateAndTimeToString(caPopOverViewController.myDatePicker.date);
            }
            else {
                d = kformatDateToString(caPopOverViewController.myDatePicker.date);
            }
            if (d) {
                CACustomAlertObject *obj = [[CACustomAlertObject alloc] initWithObjectName:d AndID:1];
                [_delegate CAAlertView:self completedWithData:[NSArray arrayWithObject:obj]];
            }
        }
    } else {
        if (_isMultipleSelectionAllowed) {
          CAPopOverViewController *caPopOverViewController = (CAPopOverViewController *)myPopOver.contentViewController;
            if ([_delegate respondsToSelector:@selector(CAAlertView:completedWithData:)]) {
                [_delegate CAAlertView:self completedWithData:caPopOverViewController.selectedObjects.allObjects];
            }
        }
    }
    return YES;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

NSString *kformatDateToString(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}


NSString *kformatDateAndTimeToString(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMATTER];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

#pragma mark
#pragma mark releasing object
- (void) dealloc {
    if ([myPopOver isPopoverVisible]) {
         [myPopOver dismissPopoverAnimated:YES];
    }
    objectArray = nil;
    myPopOver = nil;
}

@end