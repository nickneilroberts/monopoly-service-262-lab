/**
 * Type definitions for the Monopoly service
 *
 * @author: nickneilroberts
 * @date: Fall, 2025
 */

export interface PlayerGame {
    gameId: number;
    playerId: number;
    score: number;
    piece: string;
    boardPosition: number;
    cash: number;
}