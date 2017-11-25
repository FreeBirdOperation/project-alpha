//
//  ImageLoader.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/28/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import UIKit

public typealias ImageLoadResult = Result<UIImage, ImageLoadError>

/**
    A class representing an image retrieved from a network source. After being loaded an ImageReference 
    instance will contain a cachedImage property that allows you to access a copy of the image that was 
    loaded from the network source.
 
    It's less safe to use this cachedImage property than it is to just load the ImageReference again 
    through an image loader, so it is preferred to load and use the image returned by that. Be aware that 
    every time you access a cached image either through a load or the cachedImage property you are 
    recieving a **copy**, so each image can be scaled or modified independently of any others if they need 
    to be used more than once.
 
    - Usage:
    ```
      let imageReference = ImageReference(withURL: NSURL("some.image.com/path/to/image.jpg"))
 
      // This is an asynchronous operation, don't expect to have the cached image 
      // available after calling this
      imageReference.load() { (image, error) in 
        // Do something with the image here
      }
 
      imageReference.cachedImage // COULD BE NIL HERE EVEN IF THE IMAGE WILL BE SUCCESSFULLY LOADED
    ```
 */
open class ImageReference {
  static let globalCache: Cache<ImageReference> = Cache(identifier: "Image Cache")

  fileprivate enum State {
    case idle
    case loading
  }
  fileprivate var state: ImageReference.State
  
  fileprivate let session: HTTPClient
  
  fileprivate var _cachedImage: UIImage?
  /// A copy of the cached image or nil if no image has been loaded yet
  fileprivate(set) open var cachedImage: UIImage? {
    get {
      return getCopyOfCachedImage()
    }
    set {
      assert(_cachedImage == nil, "Attempted to update a cached image that has already been cached")
      if self._cachedImage == nil {
        self._cachedImage = newValue
      }
    }
  }
  
  private var scale: CGFloat = 1.0
  
  let url: URL
  
  /**
      Initialize a new ImageReference with the specified url. Two ImageReferences initialized with the same
      url will functionally be the same image reference.
   
      - Parameter url: The url to retrieve the image from
      - Parameter session: The session to use to make network requests, generally keep this as default
   
      - Returns: An ImageLoader that is ready to load an image from the url
   */
  public init(from url: URL, session: HTTPClient = HTTPClient.sharedSession) {
    self.url = url
    self.state = .idle
    self.session = session
  }
  
  public convenience init?(from string: String, session: HTTPClient = HTTPClient.sharedSession) {
    guard let url = URL(string: string) else { return nil }
    self.init(from: url, session: session)
  }
  
  private func getCopyOfCachedImage() -> UIImage? {
    guard
      let cachedImage = self._cachedImage,
      let cgImage = cachedImage.cgImage?.copy()
      else {
        return nil
    }
    
    return UIImage(cgImage: cgImage, scale: scale, orientation: cachedImage.imageOrientation)
  }
  
  /**
      Load an image in the background and pass it to the completion handler once finished. This can be 
      called multiple times to retrieve the same image at different scales. Only one load is allowed to be 
      in progress at a time. Each call will return a new instance of a UIImage
   
      - Parameter scale: The scale factor to apply to the image
      - Parameter completionHandler: The handler to call once the image load has completed. This handler 
          takes a UIImage? and a ImageLoaderError? as arguments. If the load was a success, the handler 
          will be called with the UIImage created and the error will be nil. If there is an error, the 
          image will be nil and an error object will be returned
   */
  public func load(withScale scale: CGFloat = 1.0,
                   completionHandler handler: @escaping (ImageLoadResult) -> Void) {
    self.scale = scale
    if self.state == .loading {
      // TODO (dseitz): Instead of forcing the user to handle this, we could shove off
      // the request to a background thread that waits for a signal from the loading
      // reference so the fact that there is already a load going on is opaque to the user.
      // I'm not quite sure how to signal between threads, maybe there is some condvar
      // primitive in the standard library? It should be a solvable problem, though it is
      // not high priority right now.
      //
      // Essentially it would work by handing off a block that calls the handler with the
      // cached image (or some error, not sure how we would get the error context if the
      // loading thread failed...). Once the loading thread finishes, it signals all waiting
      // threads that an image is cached and ready. Those threads then run, grab the image,
      // and call their handler with the result.
      log(.warning, for: .imageLoading, message: "Attempting to load an image from \(self.url) when a request is already in flight, wait for the previous request to finish before attempting to load again")
      handler(.err(.loadInProgress))
      return
    }
    self.state = .loading
    if
      let imageReference = ImageReference.globalCache[self.cacheKey],
      self.cachedImage == nil {
        self.cachedImage = imageReference._cachedImage
    }
    if let image = self.cachedImage {
      log(.info, for: .imageLoading, message: "Image at \(self.url) was loaded from cache")
      handler(.ok(image))
      self.state = .idle
      return
    }
    
    self.session.send(self.url) { data, response, error in
      var result: Result<UIImage, ImageLoadError>
      defer {
        self.state = .idle
        handler(result)
      }
      if let err = error {
        log(.error, for: .network, message: "Error loading image from \(self.url): \(err)")
        result = .err(.requestError(err as NSError))
        return
      }

      guard let imageData = data else {
        log(.error, for: .network, message: "Error loading image from \(self.url): No data was received")
        result = .err(.noDataReceived)
        return
      }
      
      guard let image = UIImage(data: imageData, scale: scale) else {
        log(.error, for: .network, message: "Error loading image from \(self.url): Invalid data format")
        result = .err(.invalidData)
        return
      }
      
      self.cachedImage = image
      ImageReference.globalCache.insert(self)
      
      log(.success, for: .network, message: "Image loaded from \(self.url)")
      result = .ok(image)
    }
  }
}

extension ImageReference: Cacheable {
  var isCacheable: Bool {
    return _cachedImage != nil
  }
  
  var cacheKey: CacheKey {
    return CacheKey(url.absoluteString)
  }
}

public enum ImageLoadError: Error {
  /// An error occurred when trying to send the request, check the wrapped NSError object for more details
  case requestError(NSError)
  /// No data was received when trying to load the image
  case noDataReceived
  /// Data was received, but it was not an image
  case invalidData
  /// A load is currently in progress, wait for that to finish
  case loadInProgress
  /// Failed to create a valid copy of the cached image
  case copyError
}
