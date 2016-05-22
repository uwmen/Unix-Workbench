#
# Dictionary Reader Makefile
#

include $(GNUSTEP_MAKEFILES)/common.make

ifeq ($(warnings), yes)
	ADDITIONAL_OBJCFLAGS += -W
	ADDITIONAL_OBJCPPFLAGS += -W
	ADDITIONAL_CFLAGS += -W
	ADDITIONAL_CPPFLAGS += -W
endif

ifeq ($(allwarnings), yes)
	ADDITIONAL_OBJCFLAGS += -Wall
	ADDITIONAL_OBJCPPFLAGS += -Wall
	ADDITIONAL_CFLAGS += -Wall
	ADDITIONAL_CPPFLAGS += -Wall
endif

APP_NAME = UDict

UDict_OBJC_FILES = \
	AppController.m \
	StreamLineWriter.m \
	StreamLineReader.m \
	DictConnection.m \
	HistoryManager.m \
	NSString+Convenience.m \
	NSString+Clickable.m \
	NSString+DictLineParsing.m \
	DictionaryHandle.m \
	NSScanner+Base64Encoding.m \
	LocalDictionary.m \
	Definition.m \
	Preferences.m \
	main.m \

UDict_HEADER_FILES = \
	AppController.h \
	StreamLineWriter.h \
	StreamLineReader.h \
	DictConnection.h \
	HistoryManager.h \
	NSString+Convenience.h \
	NSString+Clickable.h \
	NSString+DictLineParsing.h \
	DictionaryHandle.h \
	NSScanner+Base64Encoding.h \
	LocalDictionary.h \
	Definition.h \
	Preferences.h \

UDict_OBJCC_FILES = 
UDict_C_FILES = 
UDict_RESOURCE_FILES = \
	Resources/DictionaryReader.tif \
	Resources/dict.png \
	Resources/etoile_back.tiff \
	Resources/etoile_forward.tiff \

UDict_LANGUAGES = English

UDict_LOCALIZED_RESOURCE_FILES = \
	DictionaryReader.gorm \
	Preferences.gorm \
	DictionaryReader.nib \
	Preferences.nib

UDict_MAIN_MODEL_FILE = DictionaryReader.gorm

UDict_PRINCIPAL_CLASS = 

# If we're compiling on Etoile, we'll link to EtoileUI
# to not duplicate UKNibOwner in the code.
#ifeq ($(etoile), yes)
#	ADDITIONAL_GUI_LIBS += $(ETOILE_CORE_LIBS)
#	ADDITIONAL_OBJCFLAGS += -DETOILE
#else
	UDict_OBJC_FILES += UKNibOwner.m
	UDict_HEADER_FILES += UKNibOwner.h
#endif

#ifeq ($(debug), yes)
#	ADDITIONAL_FLAGS += -fprofile-arcs -ftest-coverage
#	ADDITIONAL_OBJC_LIBS += -lgcov
#endif

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/application.make
include $(GNUSTEP_MAKEFILES)/aggregate.make
-include ../../../etoile.make
-include GNUmakefile.postamble

