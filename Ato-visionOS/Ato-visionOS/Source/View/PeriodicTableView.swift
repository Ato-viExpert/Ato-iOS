//
//  PeriodicTableView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI
import RealityFoundation

// MARK: - PeriodicTableView

/// 주기율표
/// 원소들을 버튼으로 배치하고, 선택 시 상위 뷰에 바인딩된 selectedElement를 업데이트함

struct PeriodicTableView: View {
    
    // MARK: - Binding
    /// 선택된 원소를 상위 뷰(SplitPeriodicView)와 공유
    @Binding var selectedElement: Element?
    
    // MARK: - Properties
    /// 2차원 원소 배열 (빈 칸은 nil)
    let elementsGrid: [[Element?]]
    
    /// 전체 컨테이너의 너비와 높이 (뷰 외부에서 전달됨)
    private let containerWidth: CGFloat
    private let containerHeight: CGFloat
    
    /// 버튼 간 간격
    private let buttonSpacing: CGFloat = 10.0
    
    @Environment(AppModel.self) private var appModel
    
    // MARK: - Init
    
    /// - Parameters:
    ///   - selectedElement: 상위에서 선택된 원소
    ///   - elementsGrid: 2차원 원소 배열(주기율표 데이터)
    ///   - containerWidth: 뷰 너비
    ///   - containerHeight: 뷰 높이
    init(selectedElement: Binding<Element?>, elementsGrid: [[Element?]], containerWidth: CGFloat, containerHeight: CGFloat) {
        self._selectedElement = selectedElement
        self.elementsGrid = elementsGrid
        self.containerWidth = containerWidth
        self.containerHeight = containerHeight
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            
            // MARK: - 버튼 배치 계산
            let maxColumns = 8.0 // 한 줄 최대 버튼 수
            let maxRows = Double(elementsGrid.count) // 총 행 수 5
            
            let spacing = buttonSpacing * (maxColumns + 30)
            
            let availableWidth = containerWidth - spacing
            let availableHeight = containerHeight - spacing
            
            let buttonSize = min(availableWidth / maxColumns,
                                 availableHeight / maxRows)
            
            let titleFontSize = buttonSize * 0.65
            let descriptionFontSize = buttonSize * 0.38
            
            
            VStack(spacing: buttonSpacing) {
                
                // MARK: - 타이틀 및 설명
                
                Spacer(minLength: 50)
                Text("주기율표")
                    .font(
                        Font.custom("SF Pro", size: titleFontSize)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.98))
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("주기율표의 원소들을 클릭하여 관찰하고\n 아래 도구를 이용해 원자들을 결합하여 분자로 만들어보세요!")
                    .font(
                        Font.custom("SF Pro", size: descriptionFontSize)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.98))
                Spacer(minLength: 55)
                
                // MARK: - 주기율표 버튼
                ForEach(0..<elementsGrid.count, id: \.self) { row in
                    HStack(spacing: buttonSpacing) {
                        ForEach(0..<elementsGrid[row].count, id: \.self) { col in
                            if let element = elementsGrid[row][col],
                               let atomType = atomType(from: element) {
                                CustomButton(col: element.imageName, size: buttonSize) {
                                    selectedElement = element
                                    spawnAtom(of: atomType)
                                }
                            } else {     //빈 문자열("") → nil
                                Color.clear
                                    .frame(width: buttonSize, height: buttonSize)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 50)
            }
        }
        .padding()
    }
    
    // MARK: - Methods
    
    /// Element로부터 AtomType을 안전하게 추출합니다.
    /// - Parameter element: 원소 정보
    /// - Returns: AtomType (예: .hydrogen, .oxygen) 또는 nil
    private func atomType(from element: Element?) -> AtomType? {
        guard let symbol = element?.imageName else { return nil }
        return AtomType(rawValue: symbol)
    }
    
    /// 주어진 원자 타입을 기반으로 AtomEntity를 생성하고 RealityViewContent에 추가합니다.
    /// 커맨드 패턴을 이용해 생성 작업을 비동기적으로 실행하며, 실행된 커맨드는 undo/redo를 위해 기록됩니다.
    /// - Parameter type: 생성할 원자의 AtomType (예: .hydrogen, .carbon 등)
    private func spawnAtom(of type: AtomType) {
        guard let content = appModel.realityContent else { return }
        let command = SpawnAtomCommand(atomType: type)
        Task {
            let _ = await appModel.commandManager.execute(command, in: content)
        }
    }
}
