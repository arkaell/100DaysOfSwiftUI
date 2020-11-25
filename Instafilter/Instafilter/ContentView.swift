//
//  ContentView.swift
//  Instafilter
//
//  Created by David Liongson on 11/14/20.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var filterTitle = "InstaFilter"
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingErrorMessage = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    
    let context = CIContext()
    
    private enum Filter: String {
        case sepia = "Sepia"
        case crystallize = "Crystallize"
        case edges = "Edges"
        case gaussianBlur = "Gaussian Blur"
        case pixellate = "Pixellate"
        case unsharpMask = "Unsharp Mask"
        case vignette = "Vignette"
        
        static func getCIFilterFor(_ filter: Filter) -> CIFilter {
            switch filter {
            case .sepia:
                return .sepiaTone()
            case .crystallize:
                return .crystallize()
            case .edges:
                return .edges()
            case .gaussianBlur:
                return .gaussianBlur()
            case .pixellate:
                return .pixellate()
            case .unsharpMask:
                return .unsharpMask()
            case .vignette:
                return .vignette()

            }
        }
    }
    
    var body: some View {
        
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        let radius = Binding<Double> (
            get: {
                self.filterRadius
            },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )
        
        let scale = Binding<Double> (
            get: {
                self.filterScale
            },
            set: {
                self.filterScale = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    // display the image
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                        
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    // select an image
                    self.showingImagePicker = true
                }
                
                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity")
                        Slider(value: intensity)
                    }
                    .padding(.vertical)
                }
                
                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius")
                        Slider(value: radius)
                    }
                    .padding(.vertical)
                }
                
                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale")
                        Slider(value: scale)
                    }
                    .padding(.vertical)
                }
                
                
                HStack {
                    Button("Change Filter") {
                        // change filter
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        // save the picture
                        guard let _ = self.image else {
                            self.showingErrorMessage = true
                            return
                        }
                        
                        guard let processedImage = self.processedImage else { return }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle(filterTitle)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                // action sheet here
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text(Filter.crystallize.rawValue)) { self.setFilter(Filter.crystallize) },
                    .default(Text(Filter.edges.rawValue)) { self.setFilter(Filter.edges) },
                    .default(Text(Filter.gaussianBlur.rawValue)) { self.setFilter(Filter.gaussianBlur) },
                    .default(Text(Filter.pixellate.rawValue)) { self.setFilter(Filter.pixellate) },
                    .default(Text(Filter.sepia.rawValue)) { self.setFilter(Filter.sepia) },
                    .default(Text(Filter.unsharpMask.rawValue)) { self.setFilter(Filter.unsharpMask) },
                    .default(Text(Filter.vignette.rawValue)) { self.setFilter(Filter.vignette) }
                ])
            }
            .alert(isPresented: $showingErrorMessage) {
                Alert(title: Text("Error"), message: Text("Please select an image"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        // currentFilter.intensity = Float(filterIntensity)
        
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)}
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    private func setFilter(_ filter: Filter) {
                
        self.filterTitle = filter.rawValue
        currentFilter = Filter.getCIFilterFor(filter)
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
