#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "UCResponder.h"

@interface UCController : NSObject
{
    UCResponder *ucalc; 			// model responder to buttons
    IBOutlet NSTextField *displayField; // display field showing output
    IBOutlet NSTextField *expressionField;
    IBOutlet NSTextView *historyField;
    NSUndoManager *undoManager;
    NSMutableString *expression;
    NSMutableString *history;
    NSString *new_string;
    BOOL thousand_sep;
}

- (void)clear:(id)sender;
- (void)cut:(id)sender;
- (void)copy:(id)sender;
- (void)paste:(id)sender;

- (void)updateDisplay;
- (void)saveState;
- (void)setState:(NSDictionary *)ucalcState;
- (void)undoAction:(id)sender;
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)sender;

- (void)digitButton: (id) sender;
- (void)dot:(id)sender;

- (void)equal:(id)sender;
- (void)add:(id)sender;
- (void)sub:(id)sender;
- (void)mul:(id)sender;
- (void)div:(id)sender;
- (void)reverse:(id)sender;
- (void)percent:(id)sender;
- (void) clearHistory: (id)sender;
- (void)thousand_separator:(id)sender;
@end
