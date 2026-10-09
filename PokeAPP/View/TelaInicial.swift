//
//  TelaInicial.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

import SwiftUI

struct TelaInicial: View {
    @StateObject private var viewModel = PokemonViewModel()
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.pokemons.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Carregando Pokedex...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Tentar Novamente") {
                            Task {
                                await viewModel.loadPokemons()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List(viewModel.filteredPokemons) { pokemon in
                        NavigationLink(destination: Text("Detalhes de \(pokemon.nome)")) {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchText, prompt: "Buscar Pokémon...")
                    .refreshable {
                        await viewModel.loadPokemons()
                    }
                }
            }
            .navigationTitle("Pokédex")
            .task {
                if viewModel.pokemons.isEmpty {
                    await viewModel.loadPokemons()
                }
            }
        }
    }
}






struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(spacing: 16) {
            // Imagem do Pokémon vinda da URL
            AsyncImage(url: URL(string: pokemon.imagem)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 70, height: 70)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(width: 70, height: 70)
                @unknown default:
                    EmptyView()
                }
            }
            .background(Color.red)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("#\(pokemon.id) - \(pokemon.nome.capitalized)")
                    .font(.headline)
                    .bold()
                
                Text("Tipo: \(pokemon.tipo.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(8)
    }
}
