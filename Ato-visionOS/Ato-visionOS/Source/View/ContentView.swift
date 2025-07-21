//
//  ContentView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
<<<<<<< Updated upstream
        ZStack(alignment: .bottom) {
            // TODO: - 주기율표 뷰로 대체
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 50)
                
                Text("Hello, world!")
                
                ToggleImmersiveSpaceButton()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .bg()
            .clipShape(RoundedRectangle(cornerRadius: 55))
            .padding(.bottom, 35)
            
            
            ToolbarView()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 305)
=======
        VStack {
            RealityView { content in
                           do {
                               let li = try await Entity(named: "Al", in: realityKitContentBundle)
                               li.scale = [1.0, 1.0, 1.0] // 크기 줄여둔 것
                               content.add(li)
                               
                               let be = try await Entity(named: "Be", in: realityKitContentBundle)// 여기 파일 이름 입력
                               be.scale = [0.05, 0.05, 0.05]
                               be.position = [0.2, 0, 0] // 두개 띠울려고 옆으로 0.2만큼 x 좌표 옮겨둠
                               content.add(be)


   
                           } catch {
                               print("⚠️ 모델 로드 실패: \(error)")
                           }
                       }
                       .frame(height: 300)


            Text("Hello, world!")

            ToggleImmersiveSpaceButton()
>>>>>>> Stashed changes
        }
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}
