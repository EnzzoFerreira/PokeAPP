import SwiftUI

struct Detalhes: View {
    let pokemon: PokemonResumo

    @State private var detalhe: PokemonDetalhe?
    @State private var carregando = true
    @State private var erro: String?

    private let service = PokemonDetalheService()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange.opacity(0.35), .red.opacity(0.15)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    imagemPokemon
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32))
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

                    Text(pokemon.nome.capitalized)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))

                    if carregando {
                        ProgressView("Carregando informações...")
                    } else if let erro {
                        Text(erro)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    } else if let detalhe {
                        infoView(detalhe)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(pokemon.nome.capitalized)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task { await carregar() }
    }

    // MARK: - Dados

    private func carregar() async {
        carregando = true
        erro = nil
        do {
            detalhe = try await service.buscar(nome: pokemon.nome)
        } catch {
            erro = "Não foi possível carregar as informações."
        }
        carregando = false
    }

    // MARK: - Subviews

    private func infoView(_ d: PokemonDetalhe) -> some View {
        VStack(spacing: 20) {
            // Tipos
            HStack(spacing: 10) {
                ForEach(d.types, id: \.type.name) { slot in
                    Text(slot.type.name.capitalized)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(corDoTipo(slot.type.name), in: Capsule())
                }
            }

            // Altura e peso
            HStack {
                caixa(titulo: "Altura", valor: String(format: "%.1f m", d.alturaMetros))
                caixa(titulo: "Peso", valor: String(format: "%.1f kg", d.pesoKg))
            }

            // Habilidades
            VStack(alignment: .leading, spacing: 8) {
                Text("Habilidades").font(.headline)
                Text(d.abilities.map { $0.ability.name.capitalized }.joined(separator: ", "))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))

            // Atributos
            VStack(alignment: .leading, spacing: 12) {
                Text("Atributos").font(.headline)
                ForEach(d.stats, id: \.stat.name) { s in
                    HStack {
                        Text(nomeDoStat(s.stat.name))
                            .font(.subheadline)
                            .frame(width: 110, alignment: .leading)
                        Text("\(s.baseStat)")
                            .font(.subheadline.bold())
                            .frame(width: 36)
                        ProgressView(value: min(Double(s.baseStat), 150), total: 150)
                            .tint(.orange)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            
            
            if let moves = d.moves, !moves.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Principais Movimentos").font(.headline)

                    // Exibe uma lista em 'chips' flexíveis
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(moves.prefix(15), id: \.move.name) { item in
                                Text(item.move.name.replacingOccurrences(of: "-", with: " ").capitalized)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.primary.opacity(0.08), in: Capsule())
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    private func caixa(titulo: String, valor: String) -> some View {
        VStack(spacing: 4) {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor).font(.title3.bold())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private var imagemPokemon: some View {
        if let url = pokemon.imagemURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(height: 250)
                case .success(let image):
                    image.resizable().scaledToFit().frame(height: 250)
                case .failure:
                    fallbackImageView
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            fallbackImageView
        }
    }

    private var fallbackImageView: some View {
        Image(systemName: "photo")
            .font(.system(size: 80))
            .foregroundStyle(.gray)
            .frame(height: 250)
    }


    private func nomeDoStat(_ nome: String) -> String {
        switch nome {
        case "hp": return "HP"
        case "attack": return "Ataque"
        case "defense": return "Defesa"
        case "special-attack": return "Ataque Esp."
        case "special-defense": return "Defesa Esp."
        case "speed": return "Velocidade"
        default: return nome.capitalized
        }
    }

    private func corDoTipo(_ tipo: String) -> Color {
        switch tipo {
        case "fire": return .orange
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "poison": return .purple
        case "bug": return .mint
        case "flying": return .cyan
        case "ground": return .brown
        case "psychic": return .pink
        case "ice": return .teal
        case "fighting": return .red
        case "ghost": return .indigo
        default: return .gray
        }
    }
}
