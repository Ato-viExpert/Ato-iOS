//
//  MoleculeDetailView.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/26/25.
//

import SwiftUI

struct MoleculeDetailView: View {
    
    let molecule: DetailMoleculeModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(molecule.name)
                .font(.title.bold())
            Text("분자식: \(molecule.symbol)")
                .font(.subheadline)
            Text(molecule.description)
        }
        .padding()
    }
}
