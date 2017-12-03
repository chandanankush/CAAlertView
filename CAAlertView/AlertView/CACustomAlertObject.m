//
//  CACustomAlertObject.m
//  CAAlertView
//
//  Created by Singh, Chandan F. on 16/05/16.
//
//

#import "CACustomAlertObject.h"

@implementation CACustomAlertObject

- (instancetype)initWithObjectName:(NSString *)objName AndID:(NSInteger)obID {
    if (self = [super init]) {
        self.objName = objName;
        self.objID = obID;
        self.isSelectable = YES;
        self.isDefaultSelected = NO;
    }
    return self;
}

@end
