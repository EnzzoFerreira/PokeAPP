//
//  Carroselviewmodel.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 22/10/26.
//




import Foundation
import Combine

struct PokemonResumo: Identifiable, Hashable {
    let id: Int
    let nome: String

    var imagemURL: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}

// JSON de https://pokeapi.co/api/v2/type/ghost
private struct TipoResponse: Decodable {
    struct Entrada: Decodable { let pokemon: Ref }
    struct Ref: Decodable {
        let name: String
        let url: String
    }
    let pokemon: [Entrada]
}

@MainActor
final class CarrosselViewModel: ObservableObject {
    @Published var pokemons: [PokemonResumo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func carregar(tipo: TipoPokemon, quantidade: Int = 15) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(tipo.rawValue)") else {
            errorMessage = "URL inválida."
            return
        }

        do {
            let (data, resposta) = try await URLSession.shared.data(from: url)

            guard let http = resposta as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                errorMessage = "Erro ao acessar a PokeAPI."
                return
            }

            let decodificado = try JSONDecoder().decode(TipoResponse.self, from: data)

            // O id vem no final da URL: .../pokemon/92/
            pokemons = decodificado.pokemon
                .compactMap { entrada -> PokemonResumo? in
                    guard let idTexto = entrada.pokemon.url.split(separator: "/").last,
                          let id = Int(idTexto) else { return nil }
                    return PokemonResumo(id: id, nome: entrada.pokemon.name)
                }
                .prefix(quantidade)
                .map { $0 }
        } catch {
            errorMessage = "Não foi possível carregar os Pokémon.\nVerifique sua conexão."
        }
    }
}
