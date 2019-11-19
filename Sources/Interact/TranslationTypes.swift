//
//  TranslationTypes.swift
//  
//
//  Created by Kieran Brown on 11/19/19.
//

import Foundation
import SwiftUI




@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public protocol TranslationState {
    
    var translation: CGSize { get }
    
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public protocol TranslationModel: ObservableObject {
   
    
    var offset: CGSize { get set }
    var gestureState: TranslationState { get set }
    associatedtype Drag: Gesture
    var gesture: Drag { get }
    
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public enum TranslationType {
    case drag
    case throwable(model: VelocityModel, threshold: CGFloat)
}
