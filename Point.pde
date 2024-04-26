class Point3D<T extends Number>{
  T x, y, z;
  Point3D(T x, T y, T z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Point2D<T extends Number>{
  T x, y;
  Point2D(T x, T y){
    this.x = x;
    this.y = y;
  }
}
