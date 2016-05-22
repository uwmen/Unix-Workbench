//Thanks to Edenwaith for EdenMath code and tutorial

#import "UCResponder.h"

@implementation UCResponder


// -------------------------------------------------------
// (id) init
// -------------------------------------------------------
- (id) init
{
    currentValue	= 0.0;
    previousValue	= 0.0;
    _Operation 		= ' ';
    trailing_digits 	= 0;
    isNewDigit		= YES;
    
    return self;
}

// -------------------------------------------------------
// (double) getCurrentValue
// Simple return function which returns the current
// value
// -------------------------------------------------------
- (double) getCurrentValue
{
    return currentValue;
}


// -------------------------------------------------------
// (int) getTrailingDigits
// Simple return function which returns the number of
// trailing digits on the currently displayed number
// so the proper amount of precision can be displayed.
// Limit the number of trailing digits precision so odd
// errors don't occur.
// -------------------------------------------------------
- (int) getTrailingDigits
{
    if (trailing_digits == 0)
    {
        trailing_digits = 0;
    }
    else if (trailing_digits > 10)
    {
        trailing_digits = 10;
    }
    
    return trailing_digits;
}

// -------------------------------------------------------
// (void) setCurrentValue:(double)num
// -------------------------------------------------------
- (void) setCurrentValue:(double)num
{
    currentValue = num;
}


// -------------------------------------------------------
// (void) setState:(NSDictionary *)stateDictionary
// -------------------------------------------------------
- (void)setState:(NSDictionary *)stateDictionary 
{
    currentValue 	= [[stateDictionary objectForKey: @"currentValue"] doubleValue];
    previousValue   	= [[stateDictionary objectForKey: @"previousValue"] doubleValue];
    _Operation     	= [[stateDictionary objectForKey: @"operation"] intValue];
    trailing_digits   	= [[stateDictionary objectForKey: @"trailing_digits"] intValue];
    isNewDigit    	= [[stateDictionary objectForKey: @"isNewDigit"] boolValue];
}

// -------------------------------------------------------
// (NSDictionary *) state
// -------------------------------------------------------
- (NSDictionary *)state 
{
    NSDictionary *stateDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithDouble: currentValue], @"currentValue",
        [NSNumber numberWithDouble: previousValue], @"previousValue",
        [NSNumber numberWithInt: _Operation], @"operation",
        [NSNumber numberWithInt: trailing_digits], @"trailing_digits",
        [NSNumber numberWithBool: isNewDigit], @"isNewDigit",
        nil]; 
    return stateDictionary;
}

// -------------------------------------------------------
// (void)newDigit:(int)digit
// -------------------------------------------------------
- (void)newDigit:(int)digit 
{

    if (isNewDigit) 
    {
        previousValue = currentValue;
        isNewDigit  = NO;
        currentValue = digit;
    } 
    else 
    {
        BOOL negative = NO;
        if (currentValue < 0) 
        {
            currentValue = - currentValue;
            negative = YES;
        }
        
        if (trailing_digits == 0) 
        {
            currentValue = currentValue * 10 + digit;
        } 
        else 
        {
            currentValue = currentValue + (digit/pow(10.0, trailing_digits));

            trailing_digits++;
        }
        
        if (negative == YES)
        {
            currentValue = - currentValue;
        }
    }
}

// -------------------------------------------------------
// (void) period
// -------------------------------------------------------
- (void)period 
{
    if (isNewDigit) 
    {
        currentValue = 0.0;
        isNewDigit = NO;
    }
    if (trailing_digits == 0) 
    {
        trailing_digits = 1;
    }
}

// -------------------------------------------------------
// (void) clear
// clear the displayField and reset several variables
// -------------------------------------------------------
- (void) clear 
{
    currentValue 	= 0;
    previousValue 	= 0;
    _Operation 		= ' ';
    trailing_digits 	= 0;
    isNewDigit 	= YES;
}

// -------------------------------------------------------
// (void)operation:(char)new_operation
// -------------------------------------------------------
- (void)operation:(char)new_operation
{
    if (_Operation == ' ') 
    {
        previousValue 	= currentValue;
        isNewDigit 	= YES;
        _Operation 	= new_operation;
        trailing_digits = 0;
    } 
    else 
    {
        // cascading operations
        [self enter]; // calculate previous value, first
        previousValue = currentValue;
        isNewDigit = YES;
        _Operation = new_operation;
        trailing_digits = 0;        
    }
}

// -------------------------------------------------------
// (void)enter
// For binary operators (+, -, x, /, etc.), calculate
// the value and place into currentValue
// -------------------------------------------------------
- (void)enter 
{
    switch (_Operation) 
    {
        case ' ':
            break;
        case '+':
            currentValue = previousValue + currentValue;
            break;
        case '-':
            currentValue = previousValue - currentValue;
            break;
        case '*':
            currentValue = previousValue * currentValue;
            break;
        case '/':
                currentValue = previousValue / currentValue;
            break;
    }
    previousValue 	= 0.0;
    _Operation 		= '=';
    trailing_digits 	= 0;
    isNewDigit 		= YES;
}

// =====================================================================================
// ALGEBRAIC FUNCTIONS
// =====================================================================================

// -------------------------------------------------------
// (void) reverse_sign
// -------------------------------------------------------
- (void) reverse_sign
{
    currentValue = - currentValue;
}

// -------------------------------------------------------
// (void)percentage
// -------------------------------------------------------
- (void)percentage
{
    currentValue = currentValue / 100;
    isNewDigit 	  = YES;
    trailing_digits = 0;
}

@end
