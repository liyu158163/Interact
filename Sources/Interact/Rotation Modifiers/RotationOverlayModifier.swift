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
    var includesRotationGesture: Bool
    
    public init(dependencies: ObservedObject<GestureDependencies>, includesRotationGesture: Bool = true, rotationModel: R) {
        
        
        self.model = rotationModel
        self.rotationGestureModel = RotationGestureModel(angle: dependencies.projectedValue.angle, rotation: dependencies.projectedValue.rotation)
        self.includesRotationGesture = includesRotationGesture
        
    }
    
    var currentAngle: CGFloat {
        model.angle + model.gestureState.deltaTheta + model.rotation
    }
    
    public func body(content: Content) -> some View  {
        includesRotationGesture ?
        AnyView(content
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .simultaneousGesture(rotationGestureModel.rotationGesture)
            .overlay(self.model.overlay)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.model.isSelected.toggle()
                }
        })
        :
        AnyView(content
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .overlay(self.model.overlay)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.model.isSelected.toggle()
                }
        })
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public extension View {
    
    func rotatable<RotationHandle: View>(initialSize: CGSize, includesRotationGesture: Bool = true,  @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle) -> some View {
        self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            RotationOverlay<RotationHandle, RotationOverlayModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: RotationOverlayModel(dependencies: dependencies, handle: handle))
        }
    }
    

    
    
    func spinnable<RotationHandle: View>(initialSize: CGSize = CGSize(width: 100, height: 100), includesRotationGesture: Bool = true, model: AngularVelocityModel = AngularVelocity(), threshold: CGFloat = 0, @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle) -> some View {
        self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            RotationOverlay<RotationHandle, SpinnableModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: SpinnableModel(dependencies: dependencies, model: model, threshold: threshold, handle: handle))
        }
    }
    
    
    

    
}


