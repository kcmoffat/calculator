//
//  InterfaceController.h
//  Calculator WatchKit Extension
//
//  Created by KASEY MOFFAT on 2/5/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CalculationState) {
    OperandOne,
    Operator,
    OperandTwo,
    ShowResult
};

typedef NS_ENUM(NSInteger, OperatorSymbol) {
    Divide,
    Multiply,
    Subtract,
    Add
};

@interface InterfaceController : WKInterfaceController

@end
