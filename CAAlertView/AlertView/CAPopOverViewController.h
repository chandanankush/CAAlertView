//
//  CAPopOverViewController.h
//  Symplast
//
//  Created by Chetu on 16/01/14.
//
//

#import <UIKit/UIKit.h>

@protocol CAPopOverViewControllerDelegate;

@interface CAPopOverViewController : UITableViewController

@property (nonatomic, assign) BOOL isMultipleSelectionAllowed;
@property (nonatomic, assign) id<CAPopOverViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableSet *selectedObjects;

- (id) initWithDataSource:(NSArray *)dataS;
- (void) modefyDataSource:(NSArray *) array;
@end

@protocol CAPopOverViewControllerDelegate <NSObject>
- (void) CAPopover:(CAPopOverViewController *) obj selectedData:(id) data;
@end
