class Quaternion {
  float x, y, z, w;
  
  Quaternion(float x, float y, float z, float w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }
  
  PVector rotateVector(PVector v) {
    Quaternion vQuat = new Quaternion(v.x, v.y, v.z, 0);
    Quaternion qConjugate = new Quaternion(-x, -y, -z, w);
    
    Quaternion result = multiply(multiply(this, vQuat), qConjugate);
    
    return new PVector(result.x, result.y, result.z);
  }
  
  Quaternion multiply(Quaternion q1, Quaternion q2) {
    float newX = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    float newY = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x;
    float newZ = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w;
    float newW = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    
    return new Quaternion(newX, newY, newZ, newW);
  }
}