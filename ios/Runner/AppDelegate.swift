import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Canal nativo para identificar o país do aparelho (mesmo nome usado no Android)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "DeviceInfoChannel") {
      let channel = FlutterMethodChannel(
        name: "br.dev.yago.climapp/device",
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { call, result in
        if call.method == "getDeviceCountry" {
          result(Locale.current.regionCode?.uppercased() ?? "")
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
