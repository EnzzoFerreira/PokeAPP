//
//  PokemonCardView.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 16/10/26.
//

import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon // Substitua pelo modelo do seu Pokémon, caso tenha outro nome

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            if let url = URL(string: pokemon.imagem) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 180)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                    case .failure:
                        fallbackImageView
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                fallbackImageView
            }
            
            Text(pokemon.nome.capitalized)
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .frame(width: 280, height: 420)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private var fallbackImageView: some View {
        Image(systemName: "photo")
            .font(.system(size: 50))
            .foregroundColor(.gray)
            .frame(height: 180)
    }
}
