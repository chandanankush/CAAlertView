//
//  CAPopOverViewController.h
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CACustomAlertObject;
@protocol CAPopOverViewControllerDelegate;

@interface CAPopoverViewController : UITableViewController

@property(nonatomic, assign) BOOL isMultipleSelectionAllowed;
@property(nonatomic, assign, nullable) id<CAPopOverViewControllerDelegate> delegate;
@property(nonatomic, strong) NSMutableSet *selectedObjects;

- (instancetype)initWithDataSource:(NSArray <CACustomAlertObject*>*)dataToShow NS_DESIGNATED_INITIALIZER;
- (void)modifyDataSource:(NSArray <CACustomAlertObject*>*)array;

@end

@protocol CAPopOverViewControllerDelegate <NSObject>

- (void)popover:(CAPopoverViewController *)obj selectedData:(nullable CACustomAlertObject *)data;

@end
NS_ASSUME_NONNULL_END
