import processing.serial.*;

class Manipulator{
    private Serial serial = null;

    Manipulator(PApplet papplet){
        reconnect(papplet);
    }

    public boolean connected(){
        return serial != null;
    }

    public void reconnect(PApplet papplet){
        String[] ports = Serial.list();
        
        if(ports.length > 0){
            serial = new Serial(papplet, ports[ports.length - 1], 115200);
        }
    }

    public PVector getStickPositions(){
        if(serial != null){
            serial.write((byte)0);
            while(serial.available() < 2);
            return new PVector(serial.read(), serial.read());
        }
        else {
            return new PVector(0, 0);
        }
    }

    public void exit(){
        if(serial != null){
            serial.stop();
        }
    }
}