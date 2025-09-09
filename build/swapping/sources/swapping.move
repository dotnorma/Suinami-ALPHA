
// Define module for swapping functionality
module swapping::swapping;

// Import necessary modules
use std::option;
use sui::transfer;
use sui::tx_context::{Self, TxContext};
use sui::coin::{Self, Coin, TreasuryCap};

// Create a witness struct to prove ownership
public struct SWAPPING has drop {}
// Run only once on publish anc create my test token
fun init(otw: SWAPPING, ctx: &mut TxContext) {
    let (treasurycap, metadata) = coin::create_currency(
        otw,
        8,
        b"TESTNAMI",
        b"Suinami Test Token",
        b"Jizz on a Donkey",
        option::none(),
        ctx
    );
    // Transfer TreasuryCap OBJECT to transaction sender
    transfer::public_transfer(treasurycap, tx_context::sender(ctx));
    // Freeze metadata of test token
    transfer::public_freeze_object(metadata);

}
// Mint new tokens using entry so users can call function from offchain
public entry fun mint_test(
    cap: &mut TreasuryCap<SWAPPING>,
    amount: u64,
    receiver: address,
    ctx: &mut TxContext
    ) {
        let new_coin = coin::mint(cap, amount, ctx);
        transfer::public_transfer(new_coin, receiver);
    }
//Destroy tokens by feeding them to fun with treasury cap
public entry fun unmint_test(
    cap: &mut TreasuryCap<SWAPPING>,
    coin: Coin<SWAPPING>
    ){
      coin::burn(cap, coin);
    }