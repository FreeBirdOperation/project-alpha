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
      imageReference.load() { result in
        // Do something with the result here
      }
 
      imageReference.cachedImage // COULD BE NIL HERE EVEN IF THE IMAGE WILL BE SUCCESSFULLY LOADED
    ```
 */
open class ImageReference {
  public static let globalCache: Cache<ImageReference> = Cache(identifier: "ImageCache")

  // The networking state of the image reference, used to defer
  // load requests if one is already in progress
  private enum State {
    case idle
    case loading
  }
  private var state: ImageReference.State
  
  // Dependency injected network session
  private let session: HTTPClient
  // Condition variable to signal threads that are waiting on a load to finish
  private let loadCondVar = Condition<ImageLoadResult>()
  // Background thread to enqueue deferred loads
  private let backgroundQueue: DispatchQueue
  
  private var _cachedImage: UIImage?
  /// A copy of the cached image or nil if no image has been loaded yet
  private(set) open var cachedImage: UIImage? {
    get {
      return _cachedImage?.copy()
    }
    set {
      assert(_cachedImage == nil, "Attempted to update a cached image that has already been cached")
      if self._cachedImage == nil {
        self._cachedImage = newValue
      }
    }
  }

  /// The URL that this image reference points to
  public let url: URL
  
  /**
      Initialize a new ImageReference with the specified url. Two ImageReferences initialized with the same
      url will functionally be the same image reference.
   
      - Parameter url: The url to retrieve the image from
      - Parameter session: The session to use to make network requests, generally keep this as default
   
      - Returns: An ImageLoader that is ready to load an image from the url
   */
  public init(from url: URL,
              using cache: Cache<ImageReference> = ImageReference.globalCache,
              session: HTTPClient = HTTPClient.sharedSession) {
    self.url = url
    self.state = .idle
    self.session = session
    self.backgroundQueue = DispatchQueue(label: "com.yapi.image-load.\(url)",
                                         qos: DispatchQoS.background,
                                         attributes: .concurrent)
  }
  
  /**
      Initialize a new ImageReference with the specified URL string.
   
      - Parameter string: The string representation of a URL to load the image from
      - Parameter session: The session to use to make network requests, generally keep this as default
   
      - Returns: An ImageLoader that is ready to load an image from the URL or nil if the URL was malformed
   */
  public convenience init?(from string: String,
                           using cache: Cache<ImageReference> = ImageReference.globalCache,
                           session: HTTPClient = HTTPClient.sharedSession) {
    guard let url = URL(string: string) else { return nil }
    self.init(from: url, using: cache, session: session)
  }
  
  /**
      Load an image in the background and pass it to the completion handler once finished. This can be 
      called multiple times to retrieve the same image at different scales. Each call will return a new instance of a UIImage
   
      - Parameter scale: The scale factor to apply to the image
      - Parameter completionHandler: The handler to call once the image load has completed.
   */
  public func load(withScale scale: CGFloat = 1.0,
                   completionHandler handler: @escaping (ImageLoadResult) -> Void) {
    
    // First check if our endpoint is in the cache already, then load our cached image
    // if we have one
    // NOTE: if we have two separate image references pointing to the same endpoint and we
    // fire off load requests for each simultaneously, we will likely send both before one
    // can be cached, and so we would have an extra network request involved. This isn't much
    // of a problem since there should really only ever be one image reference for a given
    // endpoint, and even if the situation does arise it should be a minimal performance hit.
    if
      let imageReference = ImageReference.globalCache[self.cacheKey],
      self.cachedImage == nil {
        self.cachedImage = imageReference._cachedImage
    }
    if let image = cachedImage?.copy(withScale: scale) {
      log(.info, for: .imageLoading, message: "Image at \(self.url) was loaded from cache")
      handler(.ok(image))
      return
    }

    // FIXME: There is a race condition here, but the atomics API is pretty ugly, come back
    // later and figure out a clean way to do a CAS on the state. Worst case we do an unnecessary
    // network call, so it's not that important.
    if self.state == .loading {
      // We're already loading the image, defer this handler until after the
      // load finishes so we don't duplicate network work.
      backgroundQueue.async {
        let result = self.loadCondVar.wait()
        let copyResult = result.map { image -> UIImage in
          guard let copyImage = image.copy(withScale: scale) else {
            assertionFailure("Failed to copy image with scale \(scale)")
            return image
          }
          
          return copyImage
        }
        handler(copyResult)
      }
      return
    }
    self.state = .loading
    
    self.session.send(self.url) { data, response, error in
      var result: Result<UIImage, ImageLoadError>
      defer {
        self.state = .idle
        // Make sure we signal any waiting threads
        self.loadCondVar.broadcast(value: result)
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
  public var isCacheable: Bool {
    return _cachedImage != nil
  }
  
  public var cacheKey: CacheKey {
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
}
