//
//  RotatableModifier.swift
//  
//
//  Created by Kieran Brown on 11/17/19.
//

import Foundation
import SwiftUI


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct Rotatable<Handle: View>: ViewModifier {
    @ObservedObject var rotationModel: RotationOverlayModel<Handle>
    @ObservedObject var rotationGestureModel: RotationGestureModel
    
    /// The first boolean gives access to the isSelected property of the rotationModel, while the second boolean represents the drag state of the rotation overlay handle .
    public init(size: Binding<CGSize>,
                magnification: Binding<CGFloat>,
                topLeadingState: Binding<CGSize>,
                bottomLeadingState: Binding<CGSize>,
                topTrailingState: Binding<CGSize>,
                bottomTrailingState: Binding<CGSize>,
                angle: Binding<CGFloat>,
                rotation: Binding<CGFloat>,
                isSelected: Binding<Bool>,
                @ViewBuilder handle: @escaping (_ isSelected: Bool, _ isActive: Bool) -> Handle) {
        
        self.rotationModel = RotationOverlayModel(size: size,
                                                  magnification: magnification,
                                                  topLeadingState: topLeadingState,
                                                  bottomLeadingState: bottomLeadingState,
                                                  topTrailingState: topTrailingState,
                                                  bottomTrailingState: bottomTrailingState,
                                                  angle: angle,
                                                  rotation: rotation,
                                                  isSelected: isSelected,
                                                  handle: handle)
        self.rotationGestureModel = RotationGestureModel(angle: angle, rotation: rotation)
    }
    
    var currentAngle: CGFloat {
        rotationModel.angle + rotationModel.gestureState.deltaTheta + rotationGestureModel.rotationState
    }
    
    
    public func body(content: Content) -> some View  {
        content
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .gesture(rotationGestureModel.rotationGesture)
            .overlay(
                GeometryReader { proxy in
                    ZStack {
                        self.rotationModel.overlay
                    }
                }
        )
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.rotationModel.isSelected = !self.rotationModel.isSelected
                }
        }
    }
}
