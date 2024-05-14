static class Keyboard {
    static private boolean up, down, left, right;

    static public void keyPressed(int keyCode){
        switch(keyCode){
            case UP: up = true; break;
            case DOWN: down = true; break;
            case LEFT: left = true; break;
            case RIGHT: right = true; break;
        }
    }

    static public void keyReleased(int keyCode){
        switch(keyCode){
            case UP: up = false; break;
            case DOWN: down = false; break;
            case LEFT: left = false; break;
            case RIGHT: right = false; break;
        }
    }

    static public boolean up(){
        return up;
    }

    static public boolean down(){
        return down;
    }

    static public boolean left(){
        return left;
    }

    static public boolean right(){
        return right;
    }
}