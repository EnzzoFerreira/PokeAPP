//
//  TelaInicial.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

//
//  TelaInicial.swift
//  PokeAPP
//

import SwiftUI

struct TelaInicial: View {
    private let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                
                
                Image(systemName: "circle.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320)
                    .foregroundStyle(.red.opacity(0.3))
                    .offset(x: -100, y: -200)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(TipoPokemon.allCases) { tipo in
                            NavigationLink(value: tipo) {
                                CategoriaRow(tipo: tipo)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                .navigationTitle("PokeApp")
                .navigationDestination(for: TipoPokemon.self) { tipo in
                    TelaCarrosel(tipo: tipo)
                }
            }
        }
    }
}
private struct CategoriaRow: View {
    let tipo: TipoPokemon

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: tipo.icone)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(tipo.cor, in: Circle())

            Text(tipo.nome)
                .font(.title2.weight(.semibold))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(tipo.cor.opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    TelaInicial()
}
