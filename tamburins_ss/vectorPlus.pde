/**
 * PVectorPlus mult() & div() (v1.1)
 * GoToLoop (2016-Oct-16)
 * forum.Processing.org/two/discussion/18585/multiplying-vectors#Item_6
 */

static class PVectorPlus extends PVector {
  PVectorPlus() {
  }
 
  PVectorPlus(float x, float y) {
    super(x, y);
  }
 
  PVectorPlus(float x, float y, float z) {
    super(x, y, z);
  }
 
  static PVector mult(PVector v1, PVector v2) {
    return mult(v1, v2, null);
  }
 
  static PVector mult(PVector v1, PVector v2, PVector t) {
    if (t != null)  t.set(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);
    else t = new PVectorPlus(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);
    return t;
  }
 
  PVectorPlus mult(PVector v) {
    x *= v.x;
    y *= v.y;
    z *= v.z;
    return this;
  }
 
  static PVector div(PVector v1, PVector v2) {
    return div(v1, v2, null);
  }
 
  static PVector div(PVector v1, PVector v2, PVector t) {
    if (t != null)  t.set(v1.x/v2.x, v1.y/v2.y, v1.z/v2.z);
    else t = new PVectorPlus(v1.x/v2.x, v1.y/v2.y, v1.z/v2.z);
    return t;
  }
 
  PVectorPlus div(PVector v) {
    x /= v.x;
    y /= v.y;
    z /= v.z;
    return this;
  }
}
