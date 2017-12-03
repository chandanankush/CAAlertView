//
//  CACustomAlertObject.h
//  CAAlertView
//
//  Created by Singh, Chandan F. on 16/05/16.
//
//

#import <Foundation/Foundation.h>

@interface CACustomAlertObject : NSObject

- (instancetype)initWithObjectName:(NSString *)objName
                             AndID:(NSInteger)obID NS_DESIGNATED_INITIALIZER;

@property(nonatomic, strong) NSString *objName;
@property(nonatomic, assign) NSInteger objID;
@property(nonatomic, assign) BOOL isSelectable; // default is YES
@property(nonatomic, assign) BOOL isDefaultSelected;

@end
