import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i ++) {
        for(int j = 0; j < NUM_COLS; j ++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    
    
    
     int bombCount = 50;
    while(bombCount > 0) {
        setBombs();
        bombCount--;
    }
}
public void setBombs()
{
    //your code
    int rr = (int)(Math.random() * NUM_ROWS);
    int rc = (int)(Math.random() * NUM_COLS);
    //System.out.println(rr + "," + rc);
    if(!bombs.contains(buttons[rr][rc])) {
        bombs.add(buttons[rr][rc]);
        //System.out.println(bombs);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int count = 0;
    for(int i = 0; i < NUM_ROWS; i ++) {
        for(int j = 0; j < NUM_COLS; j ++) {
            if(buttons[i][j].isClicked() == true || buttons[i][j].isMarked() == true) {
                count++;
            }
        }
    }
    if(count == 350) {
        return true; 
    }
    else {
        return false;
    }
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < bombs.size(); i ++) {
        bombs.get(i).clicked = true;
    }
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("S");
    buttons[9][13].setLabel("E");

}
public void displayWinningMessage()
{
    //setLabel();
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][10].setLabel("W");
    buttons[9][11].setLabel("I");
    buttons[9][12].setLabel("N");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        // if marked/ flagged black (right click)
        return marked;
    }
    public boolean isClicked()  
    {
        //if clicked on before (right or left click)
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        //if right click, flag box; if right click again, it will unflag it (as if made a mistake and flagged the wrong box, want to undo it)
        if(mouseButton == RIGHT && clicked == false) {
            marked = !marked;
            if(marked == false) {
                //set box back to white
                clicked = false;
            }
            
        }

        else if(bombs.contains(this)) {
            clicked = true;
            displayLosingMessage();
        }

        else if(countBombs(r, c) > 0) {
            clicked = true;
            label = "" + countBombs(r, c);
        }

        else {
            clicked = true;
            for(int i = r - 1; i <= r + 1; i ++) {
                for(int j = c - 1; j <= c + 1; j ++) {
                    if(isValid(i, j) == true && buttons[i][j].clicked == false) {
                        buttons[i][j].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
            return true;
        }
        else {
            return false;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = row - 1; i <= row + 1; i ++) {
            for(int j = col - 1; j <= col + 1; j ++) {
                if(isValid(i, j) && bombs.contains(buttons[i][j])) {
                    numBombs ++;
                }
            }
        }
        if(bombs.contains(buttons[row][col])) {
            numBombs --; 
        }
        return numBombs;
    }
}



