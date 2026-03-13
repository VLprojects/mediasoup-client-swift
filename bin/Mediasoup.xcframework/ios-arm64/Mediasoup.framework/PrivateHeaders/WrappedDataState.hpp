#ifndef WrappedDataState_h
#define WrappedDataState_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WrappedDataState) {
	WrappedDataStateConnecting,
	WrappedDataStateOpen,
	WrappedDataStateClosing,
	WrappedDataStateClosed,
};

#endif /* WrappedDataState_h */
