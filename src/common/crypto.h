#pragma once

// this cryption unit uses for windows only

#include <windows.h>

//typedef cdecl void(*DecryptFunc)(unsigned char*, int, int);
//typedef cdecl void(*EncryptFunc)(unsigned char*, int, int, unsigned char**, int*);
//typedef cdecl void(*FreeMemFunc)(unsigned char**);

typedef cdecl void(*ClientEncryptFunc)(unsigned char*, int, unsigned char**, int*, unsigned char);
typedef cdecl void(*ClientDecryptFunc)(unsigned char*, int, unsigned char**, int*, unsigned char);
typedef cdecl void(*ServerEncryptFunc)(unsigned char*, int, unsigned char**, int*, unsigned char);
typedef cdecl void(*ServerDecryptFunc)(unsigned char*, int, unsigned char**, int*, unsigned char);
typedef cdecl void(*FreeMemFunc)(unsigned char**);

void crypt_init();
void crypt_final();

extern ClientEncryptFunc client_encrypt;
extern ClientDecryptFunc client_decrypt;
extern ServerEncryptFunc server_encrypt;
extern ServerDecryptFunc server_decrypt;

extern FreeMemFunc freemem;