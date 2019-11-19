//
//  RotationOverlayModifier.swift
//  
//
//  Created by Kieran Brown on 11/19/19.
//

import Foundation
import SwiftUI 


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct RotationOverlay<Handle: View, R: RotationModel>: ViewModifier {
    @ObservedObject var model: R
    @ObservedObject var rotationGestureModel: RotationGestureModel
    
    public init(dependencies: ObservedObject<GestureDependencies>, rotationModel: R) {
        
        
        self.model = rotationModel
        self.rotationGestureModel = RotationGestureModel(angle: dependencies.projectedValue.angle, rotation: dependencies.projectedValue.rotation)
        
    }
    
    var currentAngle: CGFloat {
        rotationGestureModel.angle + model.gestureState.deltaTheta + rotationGestureModel.rotationState
    }
    
    public func body(content: Content) -> some View  {
        content
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .gesture(rotationGestureModel.rotationGesture)
            .overlay(self.model.overlay)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.model.isSelected.toggle()
                }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public extension View {
    
    func rotatable<RotationHandle: View>(initialSize: CGSize, @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle) -> some View {
        self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            RotationOverlay<RotationHandle, RotationOverlayModel>(dependencies: dependencies, rotationModel: RotationOverlayModel(dependencies: dependencies, handle: handle))
        }
    }
    
    
    func spinnable<RotationHandle: View>(initialSize: CGSize = CGSize(width: 100, height: 100), model: AngularVelocityModel = AngularVelocity(), threshold: CGFloat = 0, @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle) -> some View {
        self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            RotationOverlay<RotationHandle, SpinnableModel>(dependencies: dependencies, rotationModel: SpinnableModel(dependencies: dependencies, model: model, threshold: threshold, handle: handle))
        }
    }
    
}


