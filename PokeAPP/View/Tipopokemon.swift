//
//  Tipopokemon.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 22/10/26.
//


import SwiftUI

enum TipoPokemon: String, CaseIterable, Identifiable, Hashable {
    case normal, fire, water, grass, electric, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, steel, fairy, dark

    var id: String { rawValue }

    var nome: String {
        switch self {
        case .normal:   return "Normal"
        case .fire:     return "Fogo"
        case .water:    return "Água"
        case .grass:    return "Planta"
        case .electric: return "Elétrico"
        case .ice:      return "Gelo"
        case .fighting: return "Lutador"
        case .poison:   return "Venenoso"
        case .ground:   return "Terrestre"
        case .flying:   return "Voador"
        case .psychic:  return "Psíquico"
        case .bug:      return "Inseto"
        case .rock:     return "Pedra"
        case .ghost:    return "Fantasma"
        case .dragon:   return "Dragão"
        case .steel:    return "Aço"
        case .fairy:    return "Fada"
        case .dark:     return "Sombrio"
        }
    }

    var icone: String {
        switch self {
        case .normal:   return "circle.circle"
        case .fire:     return "flame.fill"
        case .water:    return "drop.fill"
        case .grass:    return "leaf.fill"
        case .electric: return "bolt.fill"
        case .ice:      return "snowflake"
        case .fighting: return "figure.boxing"
        case .poison:   return "cross.case.fill"
        case .ground:   return "mountain.2.fill"
        case .flying:   return "wind"
        case .psychic:  return "eye.fill"
        case .bug:      return "ant.fill"
        case .rock:     return "cube.fill"
        case .ghost:    return "moon.stars.fill"
        case .dragon:   return "lizard.fill"
        case .steel:    return "shield.fill"
        case .fairy:    return "sparkles"
        case .dark:     return "moon.fill"
        }
    }

    var cor: Color {
        switch self {
        case .normal:   return Color(red: 0.65, green: 0.65, blue: 0.55)
        case .fire:     return .orange
        case .water:    return .blue
        case .grass:    return .green
        case .electric: return .yellow
        case .ice:      return .teal
        case .fighting: return .red
        case .poison:   return .purple
        case .ground:   return .brown
        case .flying:   return .cyan
        case .psychic:  return .pink
        case .bug:      return .mint
        case .rock:     return Color(red: 0.7, green: 0.6, blue: 0.3)
        case .ghost:    return .indigo
        case .dragon:   return Color(red: 0.4, green: 0.3, blue: 0.9)
        case .steel:    return Color(red: 0.7, green: 0.7, blue: 0.8)
        case .fairy:    return Color(red: 0.95, green: 0.55, blue: 0.75)
        case .dark:     return Color(red: 0.3, green: 0.25, blue: 0.25)
        }
    }
}
