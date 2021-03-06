//
//  ImageSaver.swift
//  Instafilter
//
//  Created by David Liongson on 11/23/20.
//

import UIKit

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        // Save complete
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
