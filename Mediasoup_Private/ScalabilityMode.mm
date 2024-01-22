#import "ScalabilityMode.h"
#import <scalabilityMode.hpp>


@interface ScalabilityMode ()
@property(nonatomic, readwrite) int spatialLayers;
@property(nonatomic, readwrite) int temporalLayers;
@end


@implementation ScalabilityMode

+ (instancetype _Nonnull)parseScalabilityMode:(NSString * _Nonnull)scalabilityMode {
	const nlohmann::json& layers = mediasoupclient::parseScalabilityMode(scalabilityMode.UTF8String);
	ScalabilityMode *instance = [[ScalabilityMode alloc] init];
	instance.spatialLayers = layers["spatialLayers"].get<int>();
	instance.temporalLayers = layers["temporalLayers"].get<int>();
	return instance;
}

@end
