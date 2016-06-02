//
//  ViewController.swift
//  pokedex
//
//  Created by Devin on 6/2/16.
//  Copyright © 2016 hantian. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonArr = [Pokemon]()
    var filteredPokemonArr = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        parsePokemonCSV()
        initMusic()
    }
    
    func initMusic() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
        
        do{
            
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV(){
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do{
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
    
                let pokemonID = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokemonID)
                pokemonArr.append(poke)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemonArr.count
        }
        return pokemonArr.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //set cell
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let pokemon: Pokemon!
            
            if !inSearchMode {
                pokemon = pokemonArr[indexPath.row]
            }else{
                pokemon = filteredPokemonArr[indexPath.row]
            }
            
            cell.settingCell(pokemon)
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" || searchBar.text == nil {
            inSearchMode = false
            view.endEditing(!inSearchMode)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemonArr = pokemonArr.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
        
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }

}

