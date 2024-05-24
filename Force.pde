class Force{
    PVector point, force;
    Force(PVector point, PVector force){
        this.point = point;
        this.force = force;
    }

    Force(){
        this.point = new PVector(0,0,0);
        this.force = new PVector(0,0,0);
    }
}