attribute vec4 position;
uniform vec2 midpoint;
void main()
{
gl_Position.x=((position.x)-midpoint.x)/midpoint.x;
gl_Position.y=(position.y-midpoint.y)/-midpoint.y;
gl_Position.z=0.0;
gl_Position.w=1.0;
}
