//
//  CAPopOverViewController.m
//  CAAlertView
//
//  Created by Chandan on 16/05/16.
//

#import "CAPopoverViewController.h"
#import "CAAlertView.h"
#import "CACustomAlertObject.h"

@interface CAPopoverViewController ()
@property(nonatomic, strong) NSMutableArray <CACustomAlertObject*> *objectArray;
@end

@implementation CAPopoverViewController

- (instancetype)initWithDataSource:(NSArray *)dataToShow {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _objectArray = [[NSMutableArray alloc] init];
        [_objectArray addObjectsFromArray:dataToShow];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedObjects = [[NSMutableSet alloc] init];
    
    if (_objectArray && _objectArray.count > 0) {
        NSPredicate *p =
        [NSPredicate predicateWithFormat:@"isDefaultSelected == YES"];
        NSArray *filteredArray = [_objectArray filteredArrayUsingPredicate:p];
        
        if (filteredArray && filteredArray.count > 0) {
            CACustomAlertObject *o = filteredArray[0];
            [_selectedObjects addObject:o];
        }
    }
}

- (void)modifyDataSource:(NSArray *)array {
    
    if (!_objectArray) {
        _objectArray = [[NSMutableArray alloc] init];
    } else {
        [_objectArray removeAllObjects];
    }
    [_objectArray addObjectsFromArray:array];
}

// MARK: -
// MARK: - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _objectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableCellID = @"TableCell";
    
    UITableViewCell *aCell =  [tableView dequeueReusableCellWithIdentifier:TableCellID];
    CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:TableCellID];
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    aCell.accessoryType = UITableViewCellAccessoryNone;
    if (version > 6) {
        aCell.backgroundColor = [UIColor clearColor];
    } else {
        (aCell.textLabel).textColor = [UIColor blackColor];
        aCell.selected = false;
    }
    CACustomAlertObject *toShow = _objectArray[indexPath.row];
    
    if ([toShow isKindOfClass:[CACustomAlertObject class]]) {
        aCell.textLabel.text = toShow.objName;
        
        if (!toShow.isSelectable) {
            (aCell.textLabel).textColor = [UIColor grayColor];
        }
        if ([_selectedObjects containsObject:toShow]) {
            aCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        aCell.textLabel.text = @"No Data To Display";
    }
    return aCell;
}

// MARK: -
// MARK: - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CACustomAlertObject *object = _objectArray[indexPath.row];
    if ([object isKindOfClass:[NSString class]] &&
        [(NSString *)object isEqualToString:@"No Data To Display"]) {
        
        if ([_delegate respondsToSelector:@selector(popover:selectedData:)]) {
            [_delegate popover:self selectedData:nil];
        }
        return;
    }
    if (_isMultipleSelectionAllowed) {
        if ([_selectedObjects containsObject:object]) {
            [_selectedObjects removeObject:object];
        } else {
            [_selectedObjects addObject:object];
        }
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [_selectedObjects removeAllObjects];
        [_selectedObjects addObject:object];
        [self.tableView reloadData];
        if ([_delegate respondsToSelector:@selector(popover:selectedData:)]) {
            [_delegate popover:self selectedData:object];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    CACustomAlertObject *object = _objectArray[indexPath.row];
    if ([object isKindOfClass:[NSString class]] &&
        [(NSString *)object isEqualToString:@"No Data To Display"]) {
        return NO;
    }
    if (object.isSelectable) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    _delegate = nil;
    _selectedObjects = nil;
    _objectArray = nil;
}

@end
