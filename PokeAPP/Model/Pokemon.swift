//
//  Pokemon.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 09/10/26.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id:    Int
    let nome:  String
    let tipo:  String
    let imagem: String
    let habilidades: [String]
    let altura: Int
    let peso: Int
    let ordemPokedex: Int
    let som: String
    let estatisticas: [String]
    var movimentos: [String]
}
