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

final class ImageCache {
  static let globalCache = ImageCache()
  
  fileprivate var imageCache = [String: ImageReference]()
  fileprivate let cacheAccessQueue = DispatchQueue(label: "CacheAcess", attributes: .concurrent)
  
  fileprivate init() {}
  
  // TODO (dseitz): Uh... I think statics in Swift are automatically synchronized across
  // threads... So I don't think we need any of these synchronization operations... Let's
  // do some research
  fileprivate subscript(key: String) -> ImageReference? {
    get {
      var imageReference: ImageReference? = nil
      self.readLock() {
        imageReference = self.imageCache[key]
      }
      return imageReference
    }
    set {
      guard let imageReference = newValue else {
        return
      }
      self.writeLock() {
        self.imageCache[key] = imageReference
      }
    }
  }
  
  /**
      Flush all images in the cache
   */
  func flush() {
    self.writeLock() {
      self.imageCache.removeAll()
    }
  }

  /**
      Check if an image for a given url is stored in the cache
   
      - Parameter url: The url to check for
   
      - Returns: true if the image is in the cache, false if it is not
   */
  func contains(_ url: URL) -> Bool {
    return self[url.absoluteString] != nil
  }
  
  /**
      Check if an image for a given image reference is stored in the cache
   
      - Parameter imageReference: The image reference to check for
   
      - Returns: true if the image is in the cache, false if it is not
   */
  func contains(_ imageReference: ImageReference) -> Bool {
    return self[imageReference.url.absoluteString] != nil
  }
  
  fileprivate func readLock(_ block: () -> Void) {
    self.cacheAccessQueue.sync(execute: block)
  }
  
  fileprivate func writeLock(_ block: () -> Void) {
    self.cacheAccessQueue.sync(flags: .barrier, execute: block)
  }
  
}

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
public final class ImageReference {
  
  fileprivate enum State {
    case idle
    case loading
  }
  fileprivate var state: ImageReference.State
  
  fileprivate let session: HTTPClient
  
  fileprivate var _cachedImage: UIImage?
  /// A copy of the cached image or nil if no image has been loaded yet
  fileprivate(set) var cachedImage: UIImage? {
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
  
  let url: URL
  
  /**
      Initialize a new ImageReference with the specified url. Two ImageReferences initialized with the same
      url will functionally be the same image reference.
   
      - Parameter url: The url to retrieve the image from
      - Parameter session: The session to use to make network requests, generally keep this as default
   
      - Returns: An ImageLoader that is ready to load an image from the url
   */
  init(from url: URL, session: HTTPClient = HTTPClient.sharedSession) {
    self.url = url
    self.state = .idle
    self.session = session
  }
  
  convenience init?(from string: String, session: HTTPClient = HTTPClient.sharedSession) {
    guard let url = URL(string: string) else { return nil }
    self.init(from: url, session: session)
  }
  
  private func getCopyOfCachedImage(withScale scale: CGFloat = 1.0) -> UIImage? {
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
    if self.state == .loading {
      handler(.err(.loadInProgress))
      return
    }
    self.state = .loading
    if let imageReference = ImageCache.globalCache[self.url.absoluteString] {
      self.cachedImage = imageReference._cachedImage
    }
    if let image = getCopyOfCachedImage(withScale: scale) {
      handler(.ok(image))
      self.state = .idle
      return
    }
    
    self.session.send(self.url) {(data, response, error) in
      var result: Result<UIImage, ImageLoadError>
      defer {
        self.state = .idle
        handler(result)
      }
      if let err = error {
        result = .err(.requestError(err as NSError))
        return
      }

      guard let imageData = data else {
        result = .err(.noDataReceived)
        return
      }
      
      guard let image = UIImage(data: imageData, scale: scale) else {
        result = .err(.invalidData)
        return
      }
      
      self.cachedImage = image
      ImageCache.globalCache[self.url.absoluteString] = self
      result = .ok(image)
    }
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
