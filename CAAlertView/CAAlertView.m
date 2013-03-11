//
//  CAAlertView.m
//  CAAlertView
//
//  Created by Chandan on 11/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CAAlertView.h"

@interface CAAlertView() {
    NSArray *objectArray;
    NSMutableSet *selectedObjects;
    UITableView *myTableView;
    UIDatePicker *picker;
}
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) CAAlertViewType myType;
@property (nonatomic, strong) UIAlertView *myAlertView;

- (void) configureAlertView;
@end

@implementation CAAlertView
@synthesize delegate = _delegate;
@synthesize alertView = _alertView;
@synthesize myType = _myType;
@synthesize myAlertView = _myAlertView;

- (id) initWithType:(CAAlertViewType) type andData:(NSArray *) array {
    if (self = [super init]) {
        _myType = type;
        objectArray = [[NSArray alloc] initWithArray:array];
        selectedObjects = [[NSMutableSet alloc] init];
        [self configureAlertView];
    }
    return self;
}

- (void) configureAlertView {
    if (_myType == CAAlertViewTypeDatePicker) {
        _myAlertView = [[UIAlertView alloc] initWithTitle:@"Select Date" message:@"\n\n\n\n\n\n\n"
                                                 delegate:self 
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"OK", nil];
        
        picker = [[UIDatePicker alloc] init];
        [picker setFrame:CGRectMake(10, 36, 264, 150)];
        [picker setDatePickerMode:UIDatePickerModeDate];
        [picker setMinimumDate:[NSDate date]];
        
       
        [_myAlertView addSubview:picker];
       //  [_myAlertView sizeToFit];
    }
    else {
     
            _myAlertView = [[UIAlertView alloc] initWithTitle:@"Select" message:@"\n\n\n\n\n\n\n"
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            
            myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150) style:UITableViewStyleGrouped];
            myTableView.delegate = self;
            myTableView.dataSource = self;
            myTableView.backgroundColor = [UIColor clearColor];
            [_myAlertView addSubview:myTableView];
    }
}

- (void) showAlertView {
     [_myAlertView show];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return objectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const TableCellID = @"TableCell";
    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:TableCellID];
    if( aCell == nil ) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableCellID];
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [aCell setAccessoryType:UITableViewCellAccessoryNone];
    
    NSString *toShow = [objectArray objectAtIndex:indexPath.row];
    
    if ([selectedObjects containsObject:toShow]) {
        [aCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    aCell.textLabel.text = toShow;
    
    return aCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *object = [objectArray objectAtIndex:indexPath.row];
   
    if ([selectedObjects containsObject:object]) {
        [selectedObjects removeObject:object];
    }
    else {
         [selectedObjects addObject:object];
    }
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        if ([_delegate respondsToSelector:@selector(CAAlertView:completedWithData:)]) {
            if (_myType == CAAlertViewTypeTable) {
                 [_delegate CAAlertView:self completedWithData:selectedObjects.allObjects];
            }
            else {
                 [_delegate CAAlertView:self completedWithData:[NSArray arrayWithObject:picker.date]];
            }
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(CAAlertView:cancelledWithNoData:)]) {
            [_delegate CAAlertView:self cancelledWithNoData:nil];
        }
    }
}

- (void) dealloc {
    
}

@end
