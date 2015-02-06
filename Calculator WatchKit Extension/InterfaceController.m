//
//  InterfaceController.m
//  Calculator WatchKit Extension
//
//  Created by KASEY MOFFAT on 2/5/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "InterfaceController.h"
NSInteger const maxDigits = 9;

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;
@property (copy, nonatomic) NSString *labelText;
@property (strong, nonatomic) NSNumber *operandOne;
@property (strong, nonatomic) NSNumber *operandTwo;
@property (strong, nonatomic) NSNumber *result;
@property (assign, nonatomic) OperatorSymbol operator;
@property (assign, nonatomic) CalculationState state;
@end


@implementation InterfaceController
@synthesize label;
@synthesize labelText;
@synthesize state;
@synthesize operandOne;
@synthesize operandTwo;
@synthesize result;
@synthesize operator;

#pragma mark Number Buttons
- (IBAction)press0 {
    NSLog(@"pressed 0");
    if (state == Operator) {
        labelText = @"0";
        [label setText:labelText];
        state = OperandTwo;
    } else if (state == ShowResult) {
        labelText = @"0";
        [label setText:labelText];
        state = OperandOne;
    } else {
        if ([labelText isEqualToString:@"0"]) {
            // never add leading zero
        } else {
            if ([self numberLength:labelText] < 9) {
                labelText = [labelText stringByAppendingString:@"0"];
                [label setText:labelText];
            }
        }
    }
}

- (void)press1To9:(NSString *)num {
    if (state == Operator) {
        labelText = num;
        [label setText:labelText];
        state = OperandTwo;
    } else if (state == ShowResult) {
        labelText = num;
        [label setText:labelText];
        state = OperandOne;
    } else {
        if ([labelText isEqualToString:@"0"]) {
            labelText = num;
        } else {
            if ([self numberLength:labelText] < 9) {
                labelText = [labelText stringByAppendingString:num];
            }
        }
        [label setText:labelText];
    }
}


- (IBAction)press1 {
    NSLog(@"pressed 1");
    [self press1To9:@"1"];
}

- (IBAction)press2 {
    NSLog(@"pressed 2");
    [self press1To9:@"2"];
}

- (IBAction)press3 {
    NSLog(@"pressed 3");
    [self press1To9:@"3"];
}

- (IBAction)press4 {
    NSLog(@"pressed 4");
    [self press1To9:@"4"];
}

- (IBAction)press5 {
    NSLog(@"pressed 5");
    [self press1To9:@"5"];
}

- (IBAction)press6 {
    NSLog(@"pressed 6");
    [self press1To9:@"6"];
}


- (IBAction)press7 {
    NSLog(@"pressed 7");
    [self press1To9:@"7"];
}

- (IBAction)press8 {
    NSLog(@"pressed 8");
    [self press1To9:@"8"];
}

- (IBAction)press9 {
    NSLog(@"pressed 9");
    [self press1To9:@"9"];
}

- (IBAction)pressDecimal {
    NSLog(@"pressed decimal");
    if (state == Operator) {
        labelText = @"0.";
        [label setText:labelText];
        state = OperandTwo;
    } else if (state == ShowResult) {
        labelText = @"0.";
        [label setText:labelText];
        state = OperandOne;
    } else {
        if ([labelText rangeOfString:@"."].location != NSNotFound) {
            NSLog(@"already have a decimal, do nothing");
        } else {
            if ([self numberLength:labelText] < 9) {
                NSLog(@"no decimal found, add one");
                labelText = [labelText stringByAppendingString:@"."];
                [label setText:labelText];
            }
        }
    }
}

-(NSInteger)numberLength:(NSString *)s {
    if ([labelText rangeOfString:@"."].location != NSNotFound) {
        return s.length-1;
    } else {
        return s.length;
    }
}

#pragma mark Operator Buttons
- (void)pressOperator:(OperatorSymbol)op {
    if (state == OperandOne) {
        operandOne = [NSNumber numberWithDouble:[labelText doubleValue]];
        NSLog(@"labelText: %@", labelText);
        NSLog(@"setting operandOne to %f", [operandOne doubleValue]);
        operator = op;
        state = Operator;
    } else if (state == Operator) {
        operator = op;
    } else if (state == OperandTwo) {
        operandTwo = [NSNumber numberWithDouble:[labelText doubleValue]];
        result = [self performCalculation:operator withOperandOne:operandOne andOperandTwo:operandTwo];
        operator = op;
        operandOne = result;
        labelText = [result stringValue];
        [label setText:labelText];
        state = Operator;
    } else if (state == ShowResult) {
        operandOne = result;
        operator = op;
        state = Operator;
    }
}

- (IBAction)pressDivide {
    [self pressOperator:Divide];
}

- (IBAction)pressMultiply {
    [self pressOperator:Multiply];
}

- (IBAction)pressSubtract {
    [self pressOperator:Subtract];
}

- (IBAction)pressAdd {
    [self pressOperator:Add];
}

- (NSNumber *)performCalculation:(OperatorSymbol) op
                  withOperandOne:(NSNumber *) op1
                   andOperandTwo:(NSNumber *) op2
{
    switch (op) {
        case Divide:
            return [NSNumber numberWithDouble:[operandOne doubleValue] / [operandTwo doubleValue]];
            break;
        case Multiply:
            return [NSNumber numberWithDouble:[operandOne doubleValue] * [operandTwo doubleValue]];
            break;
        case Add:
            return [NSNumber numberWithDouble:[operandOne doubleValue] + [operandTwo doubleValue]];
            break;
        case Subtract:
            return [NSNumber numberWithDouble:[operandOne doubleValue] - [operandTwo doubleValue]];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark Equals Button
- (IBAction)pressEquals {
    if (state == OperandTwo) {
        NSLog(@"operandOne: %f", [operandOne doubleValue]);
        operandTwo = [NSNumber numberWithDouble:[labelText doubleValue]];
        NSLog(@"operandTwo: %f", [operandTwo doubleValue]);
        state = ShowResult;
        result = [self performCalculation:operator withOperandOne:operandOne andOperandTwo:operandTwo];
        labelText = [result stringValue];
        [label setText:labelText];
    }
}

#pragma mark Clear Button
- (IBAction)pressClear {
    if (state == OperandOne) {
        labelText = @"0";
        [label setText:labelText];
    } else if (state == Operator) {
        labelText = @"0";
        [label setText:labelText];
        state = OperandOne;
    } else if (state == OperandTwo) {
        labelText = @"0";
        [label setText:labelText];
        state = Operator;
    } else if (state == ShowResult) {
        labelText = @"0";
        [label setText:labelText];
        state = OperandOne;
    }
}



- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    labelText = @"0";
    [label setText:labelText];
    state = OperandOne;

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



