//
//  CAAlertView.h
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CAAlertViewDelegate;

typedef enum {
    CAAlertViewTypeDatePicker = 100,
    CAAlertViewTypeTable
}CAAlertViewType;

#define kCAAlertObjectIDKey @"CAALERTOBJECTID"
#define kCAAlertObjectNameKey @"CAALERTOBJECTNAME"


@interface CAAlertView : NSObject

@property (nonatomic, assign) id<CAAlertViewDelegate>delegate;
@property (nonatomic, assign) BOOL isMultipleSelectionAllowed;// default is NO
@property (nonatomic, assign) BOOL isDatePickerTypeDOB;// default is YES
@property (nonatomic, assign) BOOL isDateAndTimeBoth; // Default is NO

- (id) initWithType:(CAAlertViewType) type andData:(NSArray *) array;// data in case of tableview. other case you can pass nil.
- (void) showAlertView:(id) sender; // sender should be a UIView Object
@end

@protocol CAAlertViewDelegate<NSObject>
- (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data;
- (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSString *) info;
@end