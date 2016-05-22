//
//  EMResponder.h
//  EdenMath
//
//  Created by admin on Thu Feb 21 2002.
//  Copyright (c) 2002-2004 Edenwaith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface UCResponder : NSObject 
{
    double currentValue;		// the current number (which is being edited)
    double previousValue;		// the other operand (previous operand)
    int trailing_digits;		// used in decimal number input
    BOOL isNewDigit;                 	// allow new number in display
}

@property char Operation;
// class method prototypes

- (double)getCurrentValue;
- (int)getTrailingDigits;
- (void)setCurrentValue:(double)num;
- (void)setState:(NSDictionary *)stateDictionary;
- (NSDictionary *)state;

- (void)newDigit:(int)digit;
- (void)period;

- (void)clear;
- (void)operation:(char)new_operation;
- (void)enter;

// Algebraic functions
- (void)reverse_sign;
- (void)percentage;
@end
