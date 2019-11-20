//
//  RotatableDraggable.swift
//  
//
//  Created by Kieran Brown on 11/20/19.
//

import Foundation
import SwiftUI



@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct RotationDraggable<Handle: View, R: RotationModel, T: TranslationModel>: ViewModifier {
    @ObservedObject var rotationModel: R
    @ObservedObject var rotationGestureModel: RotationGestureModel
    @ObservedObject var translationModel: T
    var includesRotationGesture: Bool
    
    public init(dependencies: ObservedObject<GestureDependencies>, includesRotationGesture: Bool = true, rotationModel: R, translationModel: T) {
        
        
        self.rotationModel = rotationModel
        self.rotationGestureModel = RotationGestureModel(angle: dependencies.projectedValue.angle, rotation: dependencies.projectedValue.rotation)
        self.includesRotationGesture = includesRotationGesture
        self.translationModel = translationModel
        
    }
    
    var currentAngle: CGFloat {
        rotationModel.angle + rotationModel.gestureState.deltaTheta + rotationModel.rotation
    }
    
    public func body(content: Content) -> some View  {
        includesRotationGesture ?
        AnyView(content
            .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.rotationModel.isSelected.toggle()
                    }
            }
            .simultaneousGesture(translationModel.gesture)
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .simultaneousGesture(rotationGestureModel.rotationGesture)
            .overlay(self.rotationModel.overlay)
        .offset(x: translationModel.offset.width + translationModel.gestureState.translation.width,
                y: translationModel.offset.height + translationModel.gestureState.translation.height)
            )
        :
        AnyView(content
            .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.rotationModel.isSelected.toggle()
                    }
            }
            .simultaneousGesture(translationModel.gesture)
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .overlay(self.rotationModel.overlay)
        .offset(x: translationModel.offset.width + translationModel.gestureState.translation.width,
                y: translationModel.offset.height + translationModel.gestureState.translation.height)
            )
    }
}


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public extension View {
    func rotatable<RotationHandle: View>(initialSize: CGSize, includesRotationGesture: Bool = true,  @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle, dragType: TranslationType) -> some View {
        
        switch dragType {
        case .drag:
        return AnyView(self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            RotationDraggable<RotationHandle, RotationOverlayModel, DragGestureModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: RotationOverlayModel<RotationHandle>(dependencies: dependencies, handle: handle), translationModel: DragGestureModel(offset: dependencies.projectedValue.offset, dragState: dependencies.projectedValue.dragState))
        })
        case .throwable(let model, let threshold):
            return AnyView(self.injectDependencies(initialSize: initialSize) { (dependencies)  in
                RotationDraggable<RotationHandle, RotationOverlayModel, ThrowableModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: RotationOverlayModel<RotationHandle>(dependencies: dependencies, handle: handle), translationModel: ThrowableModel(offset: dependencies.projectedValue.offset, dragState: dependencies.projectedValue.dragState, model: model, threshold: threshold))
                
            })
        }
        
    }
    
    
    
    
    func spinnable<RotationHandle: View>(initialSize: CGSize = CGSize(width: 100, height: 100), includesRotationGesture: Bool = true, model: AngularVelocityModel = AngularVelocity(), threshold: CGFloat = 0, @ViewBuilder handle: @escaping (Bool, Bool) -> RotationHandle, dragType: TranslationType) -> some View {
        
        switch dragType {
        case .drag:
        return AnyView(self.injectDependencies(initialSize: initialSize) { (dependencies)  in
            
            RotationDraggable<RotationHandle, SpinnableModel, DragGestureModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: SpinnableModel<RotationHandle>(dependencies: dependencies, model: model, threshold: threshold, handle: handle), translationModel: DragGestureModel(offset: dependencies.projectedValue.offset, dragState: dependencies.projectedValue.dragState))
            
        
        })
        case .throwable(let vModel, let vThreshold):
            return AnyView(self.injectDependencies(initialSize: initialSize) { (dependencies)  in
                
                RotationDraggable<RotationHandle, SpinnableModel, ThrowableModel>(dependencies: dependencies, includesRotationGesture: includesRotationGesture, rotationModel: SpinnableModel<RotationHandle>(dependencies: dependencies, model: model, threshold: threshold, handle: handle), translationModel: ThrowableModel(offset: dependencies.projectedValue.offset, dragState: dependencies.projectedValue.dragState, model: vModel, threshold: vThreshold))
            })
        }
        
    }
}
