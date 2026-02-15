// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DCCRoulette {
    IERC20 public dccToken;
    address public owner;
    uint256 public pot;              // Pozo acumulado de apuestas
    uint256 public lastSpinTime;
    uint256 public constant COOLDOWN = 60; // 60 segundos entre spins (ajusta si quieres)

    // Eventos para que el agent o frontend los lea
    event BetPlaced(address indexed player, uint256 amount);
    event SpinResult(uint256 randomNumber, address indexed winner, uint256 payout);
    event FeesCollected(uint256 amount);

    constructor(address _dccTokenAddress) {
        dccToken = IERC20(_dccTokenAddress);
        owner = msg.sender;
        lastSpinTime = block.timestamp;
    }

    // Función para apostar (el jugador debe aprobar primero el gasto de DCC)
    function bet(uint256 amount) external {
        require(amount > 0, "Bet amount must be greater than 0");
        require(dccToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        pot += amount;
        emit BetPlaced(msg.sender, amount);
    }

    // Función para girar la ruleta (puede llamarla el agent o manualmente para demo)
    function spin() external {
        require(block.timestamp >= lastSpinTime + COOLDOWN, "Cooldown not finished");
        require(pot > 0, "No bets in pot");

        // Random simple basado en block (suficiente para demo/hackathon, no es VRF seguro)
        uint256 random = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender
        ))) % 37; // 0-36 como ruleta europea

        lastSpinTime = block.timestamp;

        // Lógica simple de ganador (ejemplo: 0 = verde/0, 1-18 = rojo, 19-36 = negro)
        // Aquí puedes cambiar las reglas: payout 35x para número exacto, 1:1 para color, etc.
        address winner;
        uint256 payout = 0;

        // Ejemplo básico: si random == 0 → casa gana todo (verde)
        if (random == 0) {
            payout = 0; // Casa se queda el pot
        } else {
            // Supongamos que el ganador es el último que apostó (para demo simple)
            // En producción: trackea jugadores y distribuye proporcional o elige random
            winner = msg.sender; // Simplificado para demo
            payout = pot * 30 / 10; // 3x el pot (ajusta el multiplier)
        }

        // Transfiere premio al ganador
        if (payout > 0) {
            dccToken.transfer(winner, payout);
        }

        // Fee para buyback o treasury (ej: 5%)
        uint256 fee = pot / 20; // 5%
        if (fee > 0) {
            dccToken.transfer(owner, fee); // O envía a un treasury contract
            emit FeesCollected(fee);
        }

        // Resetea pot
        pot = 0;

        emit SpinResult(random, winner, payout);
    }

    // Función para que el owner retire fondos si algo falla (solo owner)
    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        uint256 balance = dccToken.balanceOf(address(this));
        dccToken.transfer(owner, balance);
    }
}
