import SwiftUI
import AVKit
import SwiftHaptics

public struct CodeScanner: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let animationSingleRunTime = 1.5

    let codeTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .ean13, .ean8, .code93, .code128, .pdf417, .qr, .aztec]
    
    @State var lineY: CGFloat = 0
    var handleScan: ((Result<String, CodeScanner.ScanError>) -> Void)
    
    public init(handleScan: @escaping (Result<String, CodeScanner.ScanError>) -> Void) {
        self.handleScan = handleScan
    }
    
    public var body: some View {
        ZStack {
            scannerCameraView
                .edgesIgnoringSafeArea(.bottom)
            scannerOverlayView
        }
    }
    
    var scannerCameraView: some View {
        CodeScanRawView(codeTypes: codeTypes,
                        simulatedData: "Simulated\nDATA",
                        completion: self.handleScan)
    }
    
    var scannerOverlayView: some View {
        ZStack {
            GeometryReader { proxy in
                Group {
                    LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.0), .accentColor, Color.accentColor.opacity(0.0)]), startPoint: .top, endPoint: .bottom)
                        .position(x: proxy.size.width/2.0, y: lineY)
                        .frame(width: proxy.size.width, height: 50)
                }
                .animation(Animation.easeInOut(duration: animationSingleRunTime).repeatForever(autoreverses: true), value: lineY)
                .onAppear {
                    lineY = lineY == 0 ? proxy.size.height : 0
                }
            }
            barcodeButtonLayer
        }
    }
    
    var barcodeButtonLayer: some View {
        VStack {
            Spacer()
            HStack {
                global_button(action: {
                    presentationMode.wrappedValue.dismiss()
                } , image: "xmark.circle.fill", alwaysDarkShadow: true)
                Spacer()
                global_button(action: {
                    Haptics.feedback(style: .rigid)
                    //                    Haptics.shared.complexSuccess()
                    toggleTorch()
                }, image: "flashlight.on.fill", alwaysDarkShadow: true)
            }
            Spacer().frame(height: 30.0)
        }
        .padding()
    }
    
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                switch device.torchMode {
                case .on : device.torchMode = .off
                case .off : device.torchMode = .on
                default: device.torchMode = .on
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
