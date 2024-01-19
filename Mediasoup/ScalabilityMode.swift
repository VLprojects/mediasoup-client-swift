import Foundation
import Mediasoup_Private


public struct ScalabilityMode {
	public var spatialLayers: Int
	public var temporalLayers: Int

	internal init(spatialLayers: Int, temporalLayers: Int) {
		self.spatialLayers = spatialLayers
		self.temporalLayers = temporalLayers
	}

	public static func parse(_ scalabilityModeString: String) -> ScalabilityMode {
		let mode = Mediasoup_Private.ScalabilityMode.parseScalabilityMode(scalabilityModeString)
		return ScalabilityMode(
			spatialLayers: Int(mode.spatialLayers),
			temporalLayers: Int(mode.temporalLayers)
		)
	}
}
