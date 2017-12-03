//
//  CAAlertView.h
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CACustomAlertObject;
@protocol CAAlertViewDelegate;

typedef NS_ENUM(unsigned int, CAAlertViewType) {
    CAAlertViewTypeDatePicker = 100,
    CAAlertViewTypeTable
};

#define kCAAlertObjectIDKey @"CAALERTOBJECTID"
#define kCAAlertObjectNameKey @"CAALERTOBJECTNAME"

@interface CAAlertView: NSObject

@property(nonatomic, assign) id<CAAlertViewDelegate> delegate;
@property(nonatomic, assign, readonly) BOOL isMultipleSelectionAllowed; // default is NO
@property(nonatomic, assign, readonly) BOOL isDatePickerTypeDOB;        // default is YES
@property(nonatomic, assign, readonly) BOOL isDateAndTimeBoth;          // Default is NO
@property(nonatomic, assign, readonly) CAAlertViewType pickerType; // default is CAAlertViewTypeDatePicker

- (instancetype)initWithType:(CAAlertViewType)type
                     andData:(NSArray *)array NS_DESIGNATED_INITIALIZER; // data in case of tableview. other case you can pass nil.
- (void)showAlertView:(id)sender; // sender should be a UIView Object
@end

@protocol CAAlertViewDelegate <NSObject>
- (void)CAAlertView:(CAAlertView *)obj completedWithData:(NSArray <CACustomAlertObject*> *)data;
- (void)CAAlertView:(CAAlertView *)obj cancelledWithNoData:(NSString *)info;
@end
