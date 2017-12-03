//
//  CAAlertView.h
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CACustomAlertObject;
@protocol CAAlertViewDelegate;

typedef NS_ENUM(NSInteger, CAAlertViewType) {
    CAAlertViewTypeDatePicker,
    CAAlertViewTypeTable
};

#define kCAAlertObjectIDKey @"CAALERTOBJECTID"
#define kCAAlertObjectNameKey @"CAALERTOBJECTNAME"

@interface CAAlertView: NSObject

@property(nonatomic, assign, nullable) id<CAAlertViewDelegate> delegate;
@property(nonatomic, assign, readonly) BOOL isMultipleSelectionAllowed; // default is NO
@property(nonatomic, assign, readonly) BOOL isDatePickerTypeDOB;        // default is YES
@property(nonatomic, assign, readonly) BOOL isDateAndTimeBoth;          // Default is NO
@property(nonatomic, assign, readonly) CAAlertViewType pickerType; // default is CAAlertViewTypeDatePicker

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CAAlertViewType)type
                     andData:(nullable NSArray<CACustomAlertObject*>*)array NS_DESIGNATED_INITIALIZER; // data in case of tableview. other case you can pass nil.
- (void)showAlertView:(id)sender; // sender should be a UIView Object
@end

@protocol CAAlertViewDelegate <NSObject>
- (void)alertView:(CAAlertView *)obj completedWithData:(NSArray <CACustomAlertObject*> *)data;
- (void)alertView:(CAAlertView *)obj cancelledWithNoData:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
