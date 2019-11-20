//
//  DragGestureModel.swift
//  
//
//  Created by Kieran Brown on 11/20/19.
//

import Foundation
import SwiftUI


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
class DragGestureModel: DragModel, ObservableObject {
    
    // MARK: Drag Gesture

    
    @Binding public var offset: CGSize
    @Binding public var gestureState: TranslationState
    
    public enum DragState: TranslationState {
        case inactive
        case active(translation: CGSize)
        
        
        
        public var translation: CGSize {
            switch self {
            case .active(translation: let t):
                return t
            default:
                return .zero
            }
        }
        
        
        public var velocity: CGSize {
            return .zero
        }
        
        
        public var velocityMagnitude: CGFloat {
            return 0
        }
    }
    
    
    #if os(macOS)
    public var gesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ (value) in
                self.gestureState = DragState.active(translation: CGSize(width: value.translation.width, height: -value.translation.height))
            })
            .onEnded { (value) in
                self.offset.width += value.translation.width
                self.offset.height -= value.translation.height
                self.gestureState = DragState.inactive
        }
    }
    
    #else
    public var gesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ (value) in
                self.gestureState = DragState.active(translation: value.translation)
            })
            .onEnded { (value) in
                self.offset.width += value.translation.width
                self.offset.height += value.translation.height
                self.gestureState = DragState.inactive
        }
    }
    #endif
    
    // MARK: Init
    public init(offset: Binding<CGSize>, dragState: Binding<TranslationState>) {
        self._offset = offset
        self._gestureState = dragState
    }
}
