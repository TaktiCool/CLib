#define DFNC(f) class f
#define FNC(f) DFNC(f)
#define FNCSERVER(f) DFNC(f) { serverOnly = 1; }
#define APIFNC(f) DFNC(f) { api = 1; }
#define APIFNCSERVER(f) DFNC(f) { api = 1; serverOnly = 1;}
#define MODULE(m) class m
