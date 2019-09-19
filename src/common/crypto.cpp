#include "crypto.h"

ClientEncryptFunc client_encrypt = nullptr;
ClientDecryptFunc client_decrypt = nullptr;
ServerEncryptFunc server_encrypt = nullptr;
ServerDecryptFunc server_decrypt = nullptr;
FreeMemFunc freemem = nullptr;
HINSTANCE hInst = nullptr;

void crypt_init() {
	hInst = LoadLibraryA("C:\\Users\\kitth\\source\\repos\\Pang-dll-master\\Release\\pang.dll");

	if (!hInst) {
		return;
	}

	client_encrypt = (ClientEncryptFunc)GetProcAddress(hInst, "pangya_client_encrypt");
	client_decrypt = (ClientDecryptFunc)GetProcAddress(hInst, "pangya_client_decrypt");
	server_encrypt = (ServerEncryptFunc)GetProcAddress(hInst, "pangya_server_encrypt");
	server_decrypt = (ServerDecryptFunc)GetProcAddress(hInst, "pangya_server_decrypt");
	freemem = (FreeMemFunc)GetProcAddress(hInst, "pangya_free");

	if (!client_encrypt) {
		return;
	}

	if (!client_decrypt) {
		return;
	}

	if (!server_encrypt) {
		return;
	}

	if (!server_decrypt) {
		return;
	}

	if (!freemem) {
		return;
	}
}

void crypt_final() {
	FreeLibrary(hInst);
}