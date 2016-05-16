//
//  CAAlertView.h
//  CAAlertView
//
//  Created by Chetu on 11/03/13.
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


//UIPopover+Iphone.h
@interface UIPopoverController (overrides)
+ (BOOL)_popoversDisabled;
@end

@interface CACustomAlertObject : NSObject
- (id) initWithObjectName:(NSString *) objName AndID:(NSInteger ) obID;
@property (nonatomic, strong) NSString *objName;
@property (nonatomic, assign)  NSInteger objID;
@property (nonatomic, assign)  BOOL isSelectable;//default is YES
@property (nonatomic, assign)  BOOL isDefaultSelected;
@end

@interface CAAlertView : NSObject

@property (nonatomic, assign) id<CAAlertViewDelegate>delegate;
@property (nonatomic, assign) BOOL isMultipleSelectionAllowed;// default is NO
@property (nonatomic, assign) BOOL isDatePickerTypeDOB;// default is YES
@property (nonatomic, assign) BOOL isDateAndTineBoth; // Default is NO
@property (nonatomic, assign) CAAlertViewType myType; // default is CAAlertViewTypeDatePicker


- (id) initWithType:(CAAlertViewType) type andData:(NSArray *) array;// data in case of tableview. other case you can pass nil.
- (void) showAlertView:(id) sender;
- (void) showAlertViewWithFrame:(CGRect) frame;// for UIBarButtonItem
@end


@protocol CAAlertViewDelegate<NSObject>
- (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data;
- (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSString *) info;
@end