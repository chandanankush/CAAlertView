//
//  CAAlertView.h
//  CAAlertView
//
//  Created by Chandan on 11/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

/*
 This class is created by me(Chandan) just to show tableview inside the alertView
 
 
 
 in .h
 #import "CAAlertView.h" and add delegate  CAAlertViewDelegate
 
 
 in .m
 
 define class variable CAAlertView * alertView;
 
 and use method to call...
 alertView = [[CAAlertView alloc] initWithType:CAAlertViewTypeTable andData:[NSArray arrayWithObjects:@"Apple", @"Banana",@"Mango",@"Papaya",@"Grapes", nil]];
 [alertView setDelegate:self];
 [alertView showAlertView];
 
 
 use delegate method to get selected data
 
 - (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data;
 - (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSString *) info;
 
 
 this class also supports UIDatePicker inside UIAlertView
 
 for more help mail me @ chandan.ankush@gmail.com
 
 */


#import <Foundation/Foundation.h>

@protocol CAAlertViewDelegate;

typedef enum {
    CAAlertViewTypeDatePicker = 100,
    CAAlertViewTypeTable
}CAAlertViewType;


@interface CAAlertView : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, assign) id<CAAlertViewDelegate>delegate;

- (id) initWithType:(CAAlertViewType) type andData:(NSArray *) array;
- (void) showAlertView;
@end


@protocol CAAlertViewDelegate<NSObject>
- (void) CAAlertView:(CAAlertView *) obj completedWithData:(NSArray *) data;
- (void) CAAlertView:(CAAlertView *) obj cancelledWithNoData:(NSString *) info;
@end