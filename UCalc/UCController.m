#import "UCController.h"

@implementation UCController

// -------------------------------------------------------
// (id)init
// Allocate memory and french fries for EdenMath
// -------------------------------------------------------
- (id)init 
{
	ucalc	= [[UCResponder alloc] init];
	undoManager = [[NSUndoManager alloc] init];
	expression = [[NSMutableString alloc] init];
	history = [[NSMutableString alloc] init];
	return self;
}

// -------------------------------------------------------
// (void)dealloc
// Deallocate/free up memory used by Edenmath
// -------------------------------------------------------
- (void)dealloc 
{
    [ucalc release];
    [super dealloc];
}

// -------------------------------------------------------
// (void) clear:(id)sender
// -------------------------------------------------------
- (void)clear:(id)sender 
{
    [self saveState];
    [ucalc clear];
    [expression setString: @""];
    [self updateDisplay];
}

- (void) clearHistory: (id)sender {
	[history setString: @""];
	[historyField setString: @""];
}

// -------------------------------------------------------
// (void) cut:(id)sender
// -------------------------------------------------------
- (void)cut:(id)sender 
{
    [self copy:sender];
    [self saveState];
    [self clear:self];
}

// -------------------------------------------------------
// (void) copy:(id)sender
// -------------------------------------------------------
- (void)copy:(id)sender 
{
    NSString *contents = [displayField stringValue];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteboard setString:contents forType:NSStringPboardType];
}

// -------------------------------------------------------
// (void) paste:(id)sender
// -------------------------------------------------------
- (void)paste:(id)sender 
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSString *type = [pasteboard availableTypeFromArray:[NSArray arrayWithObject:NSStringPboardType]];
    if (type != nil) 
    {
        NSString *contents = [pasteboard stringForType:type];
        if (contents != nil) {
            NSScanner *scanner = [NSScanner scannerWithString:contents];
            double value;
            if ([scanner scanDouble:&value]) 
            {
                [self saveState];
                [ucalc setCurrentValue:value];
                [self updateDisplay];
            }
        }
    }
}

// -------------------------------------------------------
// (void) updateDisplay:(id)sender
// Update the value in the display field on the
// calculator.  In versions 1.0.0 and 1.0.1, this was
// a 1 line method.  Because of odd precision problems and
// numbers like 0.001 not showing the 0's as they are 
// typed has required the extra 50 (or so) lines of code
// -------------------------------------------------------
- (void)updateDisplay
 {
    double currentValue = [ucalc getCurrentValue];
    char *y = "%15.";
    int i = [ucalc getTrailingDigits];
    char *z = "f";
    char c_string[32] = "";
    NSString *true_precision = [[NSString alloc] initWithFormat: @"%s%d%s", y, i-1, z];
    
    // variables for the new algorithm to format numbers properly and eliminate unncessary
    // '0' from the end of a final number.
    char final_string[32] = "";
    //int cs_len = 0;
    int j = 0;
    int decimal_places = 0;
    BOOL is_decimal = NO; // 0 is false, 1 is true
    BOOL is_zero = YES; // is true
    int new_len = 0;
    int num_zeros = 0;

    NSString *precision = @"%15.10f"; // default precision
    NSString *string_value = [NSString stringWithFormat:precision, currentValue]; // convert to string with certain string format

    if (i != 0) // if there ARE some set trailing digits like 65.2 or 0.001
    {
        NSString *other_value = [NSString stringWithFormat:true_precision, currentValue];
        [displayField setStringValue: other_value];
    }
    else // no trailing_digits because it is a number like 6 or it is an answer and
        // trailing_digits was reset to 0
    {   
        // loop through the string converted version of the currentValue, and cut
        // off any excess 0's at the end of the number, so 63.20 will appear like 63.2
        
        currentValue = [string_value doubleValue];
        [string_value getCString: c_string];
        
        // new algorithm for formating numbers properly on output
        
        // check to see if there is a decimal place, and if so, how many
        // decimal places exist
        
        for (j = 0; j < strlen(c_string); j++)
        {
            if (c_string[j] == '.')
            {
                is_decimal = YES;
                while (j < strlen(c_string))
                {
                    j++;
                    decimal_places++;
                }
            }
        }
  
        // if a decimal place exists, go through to get rid of unnecessary 0's at
        // the end of the number so 65.20 will appear to be 65.2
        if (is_decimal == YES)
        {
            for (j = 0; (j < decimal_places) && (is_zero == YES); j++)
            {
                new_len = strlen(c_string) - (1 + j);
                // count the number of 0's at the end
                if (c_string[new_len] == '0')
                {
                    num_zeros++;
                }
                else if (c_string[new_len] == '.')
                {
                    num_zeros++;
                    is_zero = NO;
                }
                else // otherwise, no more excess 0's to be found
                {
                    is_zero = NO;
                }
            }


            // loop through the necessary number of times to get rid of
            // unneeded 0's
            for (j = 0; j < (strlen(c_string) - num_zeros); j++)
            {
                final_string[j] = c_string[j];
            }
        }
        else // otherwise, there is no decimal place 
        {
            strcpy(final_string, c_string);
        }
        
        new_string = [NSString stringWithFormat:@"%s", final_string];

	if(thousand_sep){
		double n = [new_string doubleValue];	
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
		new_string = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: n]];	
		[expression setString: [numberFormatter stringFromNumber: [NSNumber numberWithInteger: n]]];
	}


        // When printing out to NSLog, new_string looks odd (\\304\\026\\010\\304),
        // but when placed as a parameter, it seems to work.  Go figure.
        [expressionField setStringValue: expression];

        [displayField setStringValue: new_string];
	if(ucalc.Operation == '=') {
		[history appendFormat:@"%@%@\n", expression,new_string];
		[historyField setString: history];
		[expression setString: new_string];
	}
    }
}


- (void)thousand_separator:(id)sender{
	thousand_sep = YES;
	[self updateDisplay];
}

// -------------------------------------------------------
// (void) saveState
// -------------------------------------------------------
- (void)saveState
{
    [undoManager registerUndoWithTarget:self selector:@selector(setState:) object:[ucalc state]];
}

// -------------------------------------------------------
// (void) setState
// -------------------------------------------------------
- (void)setState:(NSDictionary *)ucalcState 
{
    [self saveState];
    [ucalc setState:ucalcState];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) undoAction
// -------------------------------------------------------
- (void)undoAction:(id)sender 
{
    if ([undoManager canUndo])
    {
        [undoManager undo];
    }
}

// -------------------------------------------------------
// (NSUndoManager *) windowWillReturnUndoManager:(NSWindow *)sender
// -------------------------------------------------------
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)sender 
{
    return undoManager;
}

// =====================================================================================
// CONSTANTS
// =====================================================================================

// -------------------------------------------------------
// (void) digitButton:(id)sender
// -------------------------------------------------------
- (void) digitButton: (id) sender
{
    [self saveState];
    [ucalc newDigit: [[sender title] intValue]];
    [expression appendString: [sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) dot:(id)sender
// -------------------------------------------------------
- (void)dot:(id)sender 
{
    [self saveState];
    [ucalc period];
    [expression appendString:@"."];
    [self updateDisplay];
}

// =====================================================================================
// STANDARD FUNCTIONS
// =====================================================================================

// -------------------------------------------------------
// (void) equal:(id)sender
// -------------------------------------------------------
- (void)equal:(id)sender 
{
    [self saveState];
    [ucalc enter];
    [expression appendString: [sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) add:(id)sender
// -------------------------------------------------------
- (void)add:(id)sender 
{
    [self saveState];
    [ucalc operation:'+'];
    [expression appendString: [sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) sub:(id)sender
// -------------------------------------------------------
- (void)sub:(id)sender 
{
    [self saveState];
    [ucalc operation:'-'];
    [expression appendString:[sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) mul:(id)sender
// -------------------------------------------------------
- (void)mul:(id)sender 
{
    [self saveState];
    [ucalc operation:'*'];
    [expression appendString:[sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) div:(id)sender
// -------------------------------------------------------
- (void)div:(id)sender 
{
    [self saveState];
    [ucalc operation:'/'];
    [expression appendString:[sender title]];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) reverse:(id)sender
// -------------------------------------------------------
- (void)reverse:(id)sender 
{
    [self saveState];
    [ucalc reverse_sign];
    [expression appendString:@"* (-1)"];
    [self updateDisplay];
}

// -------------------------------------------------------
// (void) percent:(id)sender
// -------------------------------------------------------
- (void)percent:(id)sender
{
    [self saveState];
    [ucalc percentage];
    [expression appendString:@"/100"];
    [self updateDisplay];
}

// -------------------------------------------------------

@end
