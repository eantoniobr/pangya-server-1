#include "pcs.h"
#include "pc.h"
#include "../common/packet.h"
#include "../common/utils.h"

PC_Manager* pc_manager = nullptr;

PC_Manager::PC_Manager() {}
PC_Manager::~PC_Manager() {}

pc* PC_Manager::pc_new(Session* session) {
	int index = -1;

	// get pc free index slot
	for (int i = 0; i < MAX_PLAYER; ++i) {
		if (pc_list[i] == nullptr) {
			index = i;
			break;
		}
	}

	if (index == -1)
		return nullptr;

	pc_list[index] = new pc(index, session);
	return pc_list[index];
}

void PC_Manager::pc_remove(pc* pc) {
	int index = pc->get_connection_id();
	if (pc_list[index] == pc) {
		NULL_POINTER(pc_list[index]); // Delete and null
	}
}

void PC_Manager::broadcast(Packet* packet) {
	for (int p = 0; p < MAX_PLAYER; p++) {
		if (pc_list[p]) {
			pc_list[p]->send_packet(packet);
		}
	}
}