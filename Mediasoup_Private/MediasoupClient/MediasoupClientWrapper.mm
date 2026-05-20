#import "MediasoupClientWrapper.hpp"
#import <mediasoupclient.hpp>


@implementation MediasoupClientWrapper

+ (void)initialize {
	mediasoupclient::Initialize();
}

+ (void)cleanup {
	mediasoupclient::Cleanup();
}

+ (NSString *_Nonnull)version {
	return [NSString stringWithUTF8String:mediasoupclient::Version().c_str()];
}

@end
