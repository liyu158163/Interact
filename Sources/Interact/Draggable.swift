//
//  Draggable.swift
//  
//
//  Created by Kieran Brown on 11/17/19.
//

import Foundation
import SwiftUI


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct Draggable<T: TranslationModel>: ViewModifier {
    @ObservedObject var model: T
    
    
    
    public func body(content: Content) -> some View {
        content
            .gesture(model.gesture)
            .offset(x: model.offset.width + model.gestureState.translation.width,
                    y: model.offset.height + model.gestureState.translation.height)
    }
    
    
    public init(model: T) {
        self.model = model
    }
}




@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public extension View {
    
    /// Add To Drag Your View Around The Screen
    ///
    ///
    func draggable(initialSize: CGSize, type: TranslationType) -> some View {
        switch type {
        case .drag:
            return AnyView(self.dependencyBuffer(initialSize: initialSize) { (offset, dragState, size, magnification, topLeadingState, bottomLeadingState, topTrailingState, bottomTrailingState, angle, rotation, isSelected)  in
                Draggable<DragGestureModel>(model: DragGestureModel(offset: offset, dragState: dragState))
            })
        case .throwable(let model, let threshold):
            return AnyView(self.dependencyBuffer(initialSize: initialSize) { (offset, dragState, size, magnification, topLeadingState, bottomLeadingState, topTrailingState, bottomTrailingState, angle, rotation, isSelected)  in
                Draggable<ThrowableModel>(model: ThrowableModel(offset: offset, dragState: dragState, model: model, threshold: threshold))
            })
        }
    }
}
