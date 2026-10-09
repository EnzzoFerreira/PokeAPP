//
//  PokemonViewModel.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

import Foundation
import Combine

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    let pokemonService: PokemonService = PokemonService()
    
    
    // Filtra a lista com base no que o usuário digita na barra de busca
    var filteredPokemons: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter { $0.nome.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadPokemons() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.pokemons = try await pokemonService.fetchPokemon()
        } catch {
            self.errorMessage = "Falha ao carregar os Pokémon: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
