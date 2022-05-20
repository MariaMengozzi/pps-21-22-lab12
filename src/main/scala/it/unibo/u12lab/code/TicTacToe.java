package it.unibo.u12lab.code;

/**
 * Created by mirko on 4/10/17.
 */
public interface TicTacToe {
    void createBoard();
    boolean checkCompleted();
    boolean checkVictory();
    boolean isAFreeCell(int i, int j);
    void setHumanCell(int i, int j);
    int[] setComputerCell();
}
