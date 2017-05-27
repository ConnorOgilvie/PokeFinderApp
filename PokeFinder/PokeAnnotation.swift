//
//  PokeAnnotation.swift
//  PokeFinder
//
//  Created by Connor - Udemy on 2017-04-04.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import Foundation
import MapKit

//let pokemon = [
//    "bulbasaur",
//    "ivysaur",
//    "venusaur",
//    "charmander",
//    "charmeleon",
//    "charizard",
//    "squirtle",
//    "wartortle",
//    "blastoise",
//    "caterpie",
//    "metapod",
//    "butterfree",
//    "weedle",
//    "kakuna",
//    "beedrill",
//    "pidgey",
//    "pidgeotto",
//    "pidgeot",
//    "rattata",
//    "raticate",
//    "spearow",
//    "fearow",
//    "ekans",
//    "arbok",
//    "pikachu",
//    "raichu",
//    "sandshrew",
//    "sandslash",
//    "nidoran-f",
//    "nidorina",
//    "nidoqueen",
//    "nidoran-m",
//    "nidorino",
//    "nidoking",
//    "clefairy",
//    "clefable",
//    "vulpix",
//    "ninetales",
//    "jigglypuff",
//    "wigglytuff",
//    "zubat",
//    "golbat",
//    "oddish",
//    "gloom",
//    "vileplume",
//    "paras",
//    "parasect",
//    "venonat",
//    "venomoth",
//    "diglett",
//    "dugtrio",
//    "meowth",
//    "persian",
//    "psyduck",
//    "golduck",
//    "mankey",
//    "primeape",
//    "growlithe",
//    "arcanine",
//    "poliwag",
//    "poliwhirl",
//    "poliwrath",
//    "abra",
//    "kadabra",
//    "alakazam",
//    "machop",
//    "machoke",
//    "machamp",
//    "bellsprout",
//    "weepinbell",
//    "victreebel",
//    "tentacool",
//    "tentacruel",
//    "geodude",
//    "graveler",
//    "golem",
//    "ponyta",
//    "rapidash",
//    "slowpoke",
//    "slowbro",
//    "magnemite",
//    "magneton",
//    "farfetchd",
//    "doduo",
//    "dodrio",
//    "seel",
//    "dewgong",
//    "grimer",
//    "muk",
//    "shellder",
//    "cloyster",
//    "gastly",
//    "haunter",
//    "gengar",
//    "onix",
//    "drowzee",
//    "hypno",
//    "krabby",
//    "kingler",
//    "voltorb",
//    "electrode",
//    "exeggcute",
//    "exeggutor",
//    "cubone",
//    "marowak",
//    "hitmonlee",
//    "hitmonchan",
//    "lickitung",
//    "koffing",
//    "weezing",
//    "rhyhorn",
//    "rhydon",
//    "chansey",
//    "tangela",
//    "kangaskhan",
//    "horsea",
//    "seadra",
//    "goldeen",
//    "seaking",
//    "staryu",
//    "starmie",
//    "mr-mime",
//    "scyther",
//    "jynx",
//    "electabuzz",
//    "magmar",
//    "pinsir",
//    "tauros",
//    "magikarp",
//    "gyarados",
//    "lapras",
//    "ditto",
//    "eevee",
//    "vaporeon",
//    "jolteon",
//    "flareon",
//    "porygon",
//    "omanyte",
//    "omastar",
//    "kabuto",
//    "kabutops",
//    "aerodactyl",
//    "snorlax",
//    "articuno",
//    "zapdos",
//    "moltres",
//    "dratini",
//    "dragonair",
//    "dragonite",
//    "mewtwo",
//    "mew"]

class PokeAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var pokemonNumber: Int
    var pokemonName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, pokemonNumber: Int) {
        self.coordinate = coordinate
        self.pokemonNumber = pokemonNumber
        print("CONNOR: pokemonNumber: \(pokemonNumber)")
        self.pokemonName = GlobalVariables.listOfPokemon[pokemonNumber-1].capitalized
        self.title = self.pokemonName
    }
    
    
    
    
    
    
    
}
