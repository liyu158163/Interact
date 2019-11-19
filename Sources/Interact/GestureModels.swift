//
//  GestureModels.swift
//  
//
//  Created by Kieran Brown on 11/18/19.
//

import Foundation
import SwiftUI




@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
class DragGestureModel: ObservableObject {
    
    // MARK: Drag Gesture

    @Binding var dragState: CGSize
    @Binding var offset: CGSize
    
    
    #if os(macOS)
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ (value) in
                self.dragState = CGSize(width: value.translation.width, height: -value.translation.height)
            })
            .onEnded { (value) in
                self.offset.width += value.translation.width
                self.offset.height -= value.translation.height
                self.dragState = .zero
        }
    }
    
    #else
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ (value) in
                self.dragState = value.translation
            })
            .onEnded { (value) in
                self.offset.width += value.translation.width
                self.offset.height += value.translation.height
                self.dragState = .zero
        }
    }
    #endif
    
    // MARK: Init
    init(offset: Binding<CGSize>, dragState: Binding<CGSize>) {
        self._offset = offset
        self._dragState = dragState
    }
}


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
class RotationGestureModel: ObservableObject {
    
    // MARK: Rotation Gesture
    
    @Binding var rotationState: CGFloat
    @Binding var angle: CGFloat
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged({ (value) in
                self.rotationState = CGFloat(value.radians)
            })
            .onEnded { (value) in
                self.angle += CGFloat(value.radians)
                self.rotationState = 0
        }
    }
    
    // MARK: Init
    init(angle: Binding<CGFloat>, rotation: Binding<CGFloat>) {
        self._angle = angle
        self._rotationState = rotation
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
class MagnificationGestureModel: ObservableObject {
    
    // MARK: Magnification Gesture
    
    @Binding var magnification: CGFloat
    @Binding var size: CGSize
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged({ (value) in
                self.magnification = value
            })
            .onEnded { (value) in
                self.size.width *= value
                self.size.height *= value
                self.magnification = 1
        }
        
    }
    
    
    // MARK: Init
    init(size: Binding<CGSize>, magnification: Binding<CGFloat>) {
        self._size = size
        self._magnification = magnification
    }
}
