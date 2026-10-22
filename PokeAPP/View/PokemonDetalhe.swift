//
//  DetalhesDoPokemon.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 20/10/26.
//

import Foundation

struct PokemonDetalhe: Decodable {
    let height: Int      // em decímetros
    let weight: Int      // em hectogramas
    let types: [TipoSlot]
    let abilities: [HabilidadeSlot]
    let stats: [StatSlot]

    var alturaMetros: Double { Double(height) / 10 }
    var pesoKg: Double { Double(weight) / 10 }

    struct Nome: Decodable { let name: String }
    struct TipoSlot: Decodable { let type: Nome }

    struct HabilidadeSlot: Decodable {
        let ability: Nome
    }

    struct StatSlot: Decodable {
        let baseStat: Int
        let stat: Nome

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }
}

struct PokemonDetalheService {
    func buscar(nome: String) async throws -> PokemonDetalhe {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(nome.lowercased())") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetalhe.self, from: data)
    }
}
