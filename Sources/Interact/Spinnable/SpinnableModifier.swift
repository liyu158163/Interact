//
//  SpinnableModifier.swift
//  
//
//  Created by Kieran Brown on 11/17/19.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct Spinnable<Handle: View>: ViewModifier {
    @ObservedObject var spinModel: SpinnableModel<Handle>
    @ObservedObject var rotationGestureModel: RotationGestureModel
    
    public init(size: Binding<CGSize>,
                magnification: Binding<CGFloat>,
                topLeadingState: Binding<CGSize>,
                bottomLeadingState: Binding<CGSize>,
                topTrailingState: Binding<CGSize>,
                bottomTrailingState: Binding<CGSize>,
                angle: Binding<CGFloat>,
                rotation: Binding<CGFloat>,
                isSelected: Binding<Bool>,
                model: AngularVelocityModel,
                threshold: CGFloat = 0,
                handle: @escaping (_ isSelected: Bool, _ isActive: Bool) -> Handle) {
        
        
        self.spinModel = SpinnableModel(size: size,
                                        magnification: magnification,
                                        topLeadingState: topLeadingState,
                                        bottomLeadingState: bottomLeadingState,
                                        topTrailingState: topTrailingState,
                                        bottomTrailingState: bottomTrailingState,
                                        angle: angle,
                                        rotation: rotation,
                                        isSelected: isSelected,
                                        model: model,
                                        threshold: threshold,
                                        handle: handle)
        self.rotationGestureModel = RotationGestureModel(angle: angle, rotation: rotation)
        
    }
    
    var currentAngle: CGFloat {
        rotationGestureModel.angle  + rotationGestureModel.rotationState
    }
    
    public func body(content: Content) -> some View  {
        content
            .onAppear(perform: {
                self.spinModel.angle = 0
            })
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .gesture(rotationGestureModel.rotationGesture)
            .overlay(self.spinModel.overlay)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.spinModel.isSelected.toggle()
                }
        }
    }
}
