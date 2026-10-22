//
//  PokemonService.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

import SwiftUI

final class PokemonService {
    struct PokemonListResponse: Codable {
        let results: [PokemonEntry]
    }

    private struct PokemonDTO: Codable {
        let id: Int
        let name: String
        let height: Int
        let weight: Int
        let order: Int
        let types: [TypeEntry]
        let abilities: [AbilityEntry]
        let sprites: Sprites
        let stats: [StatEntry]
        let moves: [MoveEntry]
        let cries: Cries?

        struct TypeEntry: Codable {
            let type: NamedResource
        }
        struct AbilityEntry: Codable {
            let ability: NamedResource
        }
        struct MoveEntry: Codable {
            let move: NamedResource
        }
        struct StatEntry: Codable {
            let baseStat: Int
            let stat: NamedResource
            
            enum CodingKeys: String, CodingKey {
                case baseStat = "base_stat"
                case stat
            }
        }
        struct NamedResource: Codable {
            let name: String
        }
        struct Sprites: Codable {
            let frontDefault: String?
            
            enum CodingKeys: String, CodingKey {
                case frontDefault = "front_default"
            }
        }
        struct Cries: Codable {
            let latest: String?
        }
    }


    struct PokemonEntry: Codable {
        let name: String
        let url: String
    }
    
    func fetchPokemon() async throws -> [Pokemon] {
            // Adicionamos ?limit=50 para trazer mais itens de uma vez (você pode alterar esse número)
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=50") else {
                throw URLError(.badURL)
            }
             
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokeListUrl = try JSONDecoder().decode(PokemonListResponse.self, from: data)
             
            // Usamos withThrowingTaskGroup para carregar todos os detalhes em paralelo (em vez de um loop lento)
            return try await withThrowingTaskGroup(of: Pokemon.self) { group in
                for pok in pokeListUrl.results {
                    group.addTask {
                        return try await self.fetchPokemonDetails(from: pok.url)
                    }
                }
                
                var pokemons: [Pokemon] = []
                for try await pokemon in group {
                    pokemons.append(pokemon)
                }
                
                // Ordena os Pokémon pelo ID para manter a Pokédex organizada corretamente
                return pokemons.sorted { $0.id < $1.id }
            }
        }
    
    func fetchPokemonDetails(from urlString: String) async throws -> Pokemon {
        
        let cleanUrlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL(string: cleanUrlString) else {
            throw URLError(.badURL)
        }
        
        // 1. Busca os dados brutos da API
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 2. Decodifica no DTO que espelha a API
        let dto = try JSONDecoder().decode(PokemonDTO.self, from: data)
        
        // 3. Mapeia o DTO para o seu struct Pokemon em Português
        let pokemon = Pokemon(
            id: dto.id,
            nome: dto.name,
            tipo: dto.types.map { $0.type.name }.joined(separator: ", "),
            imagem: dto.sprites.frontDefault ?? "",
            habilidades: dto.abilities.map { $0.ability.name },
            altura: dto.height,
            peso: dto.weight,
            ordemPokedex: dto.order,
            som: dto.cries?.latest ?? "https://raw.githubusercontent.com/vapor/tortoise/main/Resources/audio/pokemon.mp3",
            estatisticas: dto.stats.map { "\($0.stat.name): \($0.baseStat)" },
            movimentos: dto.moves.map { $0.move.name }
        )
        
        return pokemon
    }
    
    
}
