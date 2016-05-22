/* 
   Project: UCalc

   Author: Bruno Maximo

   Created: 2016-03-17 21:18:44 +0000 by dharc
*/

#import <AppKit/AppKit.h>
#import "UCController.h"

int 
main(int argc, const char *argv[])
{
// Uncomment if your application is Renaissance application
/*  CREATE_AUTORELEASE_POOL (pool);
  [NSApplication sharedApplication];
  [NSApp setDelegate: [AppController new]];

  #ifdef GNUSTEP
    [NSBundle loadGSMarkupNamed: @"MainMenu-GNUstep"  owner: [NSApp delegate]];
  #else
    [NSBundle loadGSMarkupNamed: @"MainMenu-OSX"  owner: [NSApp delegate]];
  #endif
   
  RELEASE (pool);
*/
  
  return NSApplicationMain (argc, argv);
}

