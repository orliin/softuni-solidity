pragma solidity 0.4.19;

contract PokemonGame {
    
    event PokemonCaught(address owner, bool[allPokes] pokes);
    
    enum Pokemons { BaiIvan, ChichoGosho, StrinkaKalinka, KumchoValcho, KumaLisa,
        RadkaPiratka, ZayoBayo, BabaMeca, KakaLili, KolyoTerorista }
    uint8 constant allPokes = 10;
    
    struct Person {
        bool[allPokes] pokesCaught;
        uint256 lastPokeCaughtTime;
    }
    
    mapping(address => Person) public people;
    address[][allPokes] public pokemonOwners;
    
    function PokemonGame() public {
        
    }
    
    function catchPoke(Pokemons poke) public {
        require(people[msg.sender].pokesCaught[uint8(poke)] == false);
        require(people[msg.sender].lastPokeCaughtTime + 15 seconds <= now);
        
        people[msg.sender].pokesCaught[uint8(poke)] = true;
        people[msg.sender].lastPokeCaughtTime = now;
        
        pokemonOwners[uint8(poke)].push(msg.sender);
        
        PokemonCaught(msg.sender, people[msg.sender].pokesCaught);
    }
    
    function listPersonPokes(address personAddress) public view returns(Pokemons[]){
        uint8 pokesCaught = 0;
        for(uint8 i = 0; i<allPokes; i++) {
            if(people[personAddress].pokesCaught[i]) {
                pokesCaught++;
            }
        }
        Pokemons[] memory personPokes = new Pokemons[](pokesCaught);
        for(; i>0; i--) {
            if(people[personAddress].pokesCaught[i-1]) {
                pokesCaught--;
                personPokes[pokesCaught]=Pokemons(i-1);
            }
        }
        return personPokes;
    }
    
    function listPokemonOwners(Pokemons poke) public view returns(address[]) {
        return pokemonOwners[uint8(poke)];
    }
}