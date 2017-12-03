//
//  CAAlertView.m
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import "CAAlertView.h"
#import "CAPickerViewController.h"
#import "CAPopoverViewController.h"
#import "CACustomAlertObject.h"

#define isiPhone5 YES
#define DATE_FORMATTER @"MM-dd-yyyy HH:mm"

@interface CAAlertView () <CAPopOverViewControllerDelegate, UIPopoverPresentationControllerDelegate>

@property(nonatomic, strong) NSArray <CACustomAlertObject*>*objectArray;
@property(nonatomic, strong) CAPopoverViewController *tablePopoverRef;
@property(nonatomic, strong) CAPickerViewController *datePickerPopOver;

- (void)configureAlertView;

NSString *kformatDateToString(NSDate *date);
NSString *kformatDateAndTimeToString(NSDate *date);
@end

@implementation CAAlertView

// MARK: -
// MARK: - Class constructor
- (instancetype)initWithType:(CAAlertViewType)type andData:(NSArray *)array {
    if (self = [super init]) {
        _pickerType = type;
        if (_pickerType == CAAlertViewTypeTable) {
            _objectArray = [[NSArray alloc] initWithArray:(array && array.count > 0 ? array : @[ @"No Data To Display" ])];
        }
        _isDatePickerTypeDOB = YES;
        _isDateAndTimeBoth = NO;
        _isMultipleSelectionAllowed = NO;
    }
    return self;
}

// MARK: -
// MARK: - Configuring Alert
- (void)configureAlertView {
    if (_pickerType == CAAlertViewTypeDatePicker) {
        _datePickerPopOver = self.datePickerPopOver;
    } else {
        _tablePopoverRef = [self tablePopover];
    }
}

- (void)showAlertView:(id)sender { // sender should be a UIView Object
    [self configureAlertView];
    
    UIViewController *controller = (UIViewController *)_delegate;
    
    if (_pickerType == CAAlertViewTypeDatePicker) {
        
        UIView *v = (UIView *)sender;
        UIPopoverPresentationController *ppc =
        _datePickerPopOver.popoverPresentationController;
        ppc.delegate = self;
        
        _datePickerPopOver.popoverPresentationController.sourceView = v;
        _datePickerPopOver.popoverPresentationController.sourceRect = v.bounds;
        [controller presentViewController:_datePickerPopOver
                                 animated:YES
                               completion:^{
                                   // any logic after view presented
                               }];
    } else {
        
        UIView *v = (UIView *)sender;
        UIPopoverPresentationController *ppc = _tablePopoverRef.popoverPresentationController;
        ppc.delegate = self;
        
        _tablePopoverRef.popoverPresentationController.sourceView = v;
        _tablePopoverRef.popoverPresentationController.sourceRect = v.bounds;
        [controller presentViewController:_tablePopoverRef
                                 animated:YES
                               completion:^{
                                   // any logic after view presented
                               }];
    }
}

// MARK: - Configure Table Popover
- (CAPopoverViewController *)tablePopover {
    
    if (!_tablePopoverRef) {
        _tablePopoverRef =
        [[CAPopoverViewController alloc] initWithDataSource:_objectArray];
        _tablePopoverRef.delegate = self;
    } else {
        [_tablePopoverRef modifyDataSource:_objectArray];
    }
    _tablePopoverRef.isMultipleSelectionAllowed = _isMultipleSelectionAllowed;
    
    _tablePopoverRef.preferredContentSize = CGSizeMake(200.0f, 300.0f);
    _tablePopoverRef.modalPresentationStyle = UIModalPresentationPopover;
    return _tablePopoverRef;
}

// MARK: - Configure Date Picker
- (CAPickerViewController *)datePickerPopOver {
    
    if (!_datePickerPopOver) {
        _datePickerPopOver = [[CAPickerViewController alloc] init];
    }
    
    (_datePickerPopOver.myDatePicker).datePickerMode =
    _isDateAndTimeBoth ? UIDatePickerModeDateAndTime : UIDatePickerModeDate;
    
    if (_isDatePickerTypeDOB) {
        (_datePickerPopOver.myDatePicker).maximumDate = [NSDate date];
    } else {
        (_datePickerPopOver.myDatePicker).minimumDate = [NSDate date];
    }
    _datePickerPopOver.preferredContentSize = CGSizeMake(300.0f, 150.0f);
    _datePickerPopOver.modalPresentationStyle = UIModalPresentationPopover;
    
    return _datePickerPopOver;
}

// MARK: - Table Popover Delegate
- (void)popover:(nonnull CAPopoverViewController *)obj selectedData:(nullable CACustomAlertObject *)data {
    if ([_delegate respondsToSelector:@selector(alertView:completedWithData:)]) {
        if (_pickerType == CAAlertViewTypeTable) {
            [_delegate alertView:self completedWithData:@[ data ]];
        }
    }
}

// MARK: - UIPopover Delegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController: (UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    if (_pickerType == CAAlertViewTypeDatePicker) {
        if ([_delegate respondsToSelector:@selector(alertView:completedWithData:)]) {
            
            NSString *dateString = nil;
            if (_isDateAndTimeBoth) {
                dateString = kformatDateAndTimeToString(_datePickerPopOver.myDatePicker.date);
            } else {
                dateString = kformatDateToString(_datePickerPopOver.myDatePicker.date);
            }
            if (dateString) {
                CACustomAlertObject *obj = [[CACustomAlertObject alloc] initWithObjectName:dateString AndID:1];
                [_delegate alertView:self completedWithData:@[ obj ]];
            }
        }
    } else {
        if (_isMultipleSelectionAllowed) {
            if ([_delegate respondsToSelector:@selector(alertView:completedWithData:)]) {
                [_delegate alertView:self completedWithData:_tablePopoverRef.selectedObjects.allObjects];
            }
        }
    }
}

// MARK: - Helper Methods
NSString *kformatDateToString(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd-yyyy";
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

NSString *kformatDateAndTimeToString(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMATTER];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

// MARK: -
// MARK: - releasing object
- (void)dealloc {
    
    if (_tablePopoverRef) {
        [_tablePopoverRef dismissViewControllerAnimated:NO completion:nil];
        _tablePopoverRef = nil;
    }
    
    if (_datePickerPopOver) {
        [_datePickerPopOver dismissViewControllerAnimated:NO completion:nil];
        _datePickerPopOver = nil;
    }
    _objectArray = nil;
}

@end
