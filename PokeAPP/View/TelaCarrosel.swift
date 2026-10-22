//
//  TelaCarrosel.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

//
//  TelaCarrosel.swift
//  PokeAPP
//

import SwiftUI

struct TelaCarrosel: View {
    let tipo: TipoPokemon
    @StateObject private var viewModel = CarrosselViewModel()
    
    private let larguraCard: CGFloat = 280
    
    @ViewBuilder
    var body: some View {
        GeometryReader { geo in
            let margem = max((geo.size.width - larguraCard) / 2, 0)
            ZStack {
                LinearGradient(
                    colors: [tipo.cor.opacity(0.4), .black.opacity(0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Image(systemName: "circle.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380)
                    .foregroundStyle(.white.opacity(0.04))
                    .offset(x: 80, y: -100)
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Carregando...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let erro = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Text(erro)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                            
                            Button("Tentar novamente") {
                                Task { await viewModel.carregar(tipo: tipo) }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(viewModel.pokemons) { pokemon in
                                    NavigationLink {
                                        Detalhes(pokemon: pokemon)
                                    } label: {
                                        CardPokemon(pokemon: pokemon, tipo: tipo)
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: larguraCard)
                                    .visualEffect { content, proxy in
                                        let frame = proxy.frame(in: .scrollView)
                                        let largura = proxy.bounds(of: .scrollView)?.width ?? 400
                                        let centroScroll = largura / 2
                                        let distancia = abs(frame.midX - centroScroll)
                                        let progresso = min(distancia / centroScroll, 1.0)
                                        
                                        let escala: CGFloat = 1.0 - (0.15 * progresso)
                                        let opacidade: Double = 1.0 - (0.4 * progresso)
                                        
                                        return content
                                            .scaleEffect(escala)
                                            .opacity(opacidade)
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .contentMargins(.horizontal, margem, for: .scrollContent)
                        .frame(maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle(tipo.nome)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.pokemons.isEmpty {
                    await viewModel.carregar(tipo: tipo)
                }
            }
        }
    }
    
    struct CardPokemon: View {
        let pokemon: PokemonResumo
        let tipo: TipoPokemon
        
        var body: some View {
            VStack(spacing: 12) {
                AsyncImage(url: pokemon.imagemURL) { fase in
                    switch fase {
                    case .success(let imagem):
                        imagem.resizable().scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
                .frame(height: 200)
                
                Text(pokemon.nome.capitalized)
                    .font(.title2.bold())
                
                Text(String(format: "#%03d", pokemon.id))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .background(tipo.cor.opacity(0.2), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
#Preview {
    NavigationStack {
        TelaCarrosel(tipo: .ghost)
    }
}
